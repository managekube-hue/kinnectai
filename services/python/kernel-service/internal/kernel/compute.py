"""
KC (Kinnection Coefficient) compute layer — Immutable Algorithm v2, §4.3.

This module provides the high-level `compute_kc` entrypoint used by the
kernel-service API.  It delegates to the full :class:`KCKernel` for the
multi-layer score but applies the Layer-2 consent fallback defined in §4.3:

    If ``consent_flags & 0x02 == 0`` (genomic layer paused by user):
        * genetic_weight is zeroed out.
        * A 0.60 confidence multiplier is applied to the final score.
        * ``fallback_applied = True`` is returned so callers can surface a
          disclosure badge in the UI.

Usage
-----
>>> score, fallback = compute_kc(user_a_id, user_b_id, consent_flags=0x01)
"""

from __future__ import annotations

import logging
from typing import Tuple

logger = logging.getLogger(__name__)

# Consent bitmask constants (must stay in sync with mobile ConsentAnalytics)
_LAYER_GENOMIC = 0x02  # Layer 2: Genomic / bioidentity

# Confidence penalty applied when Layer 2 is paused (§4.3)
_GENOMIC_PAUSED_PENALTY = 0.60


def compute_kc(
    user_a_id: str,
    user_b_id: str,
    consent_flags: int,
    *,
    kernel: "KCKernel | None" = None,
) -> Tuple[float, bool]:
    """Compute the Kinnection Coefficient between two users.

    Parameters
    ----------
    user_a_id:
        UUID of the requesting user.
    user_b_id:
        UUID of the candidate user.
    consent_flags:
        Bitmask from the requesting user's consent record.
    kernel:
        Optional pre-constructed :class:`KCKernel` instance.  When *None*
        the module-level default kernel (initialised at service start-up) is
        used.  Provided for testing and dependency injection.

    Returns
    -------
    (score, fallback_applied):
        ``score`` is clamped to [0.0, 1.0].
        ``fallback_applied`` is *True* when Layer-2 was zeroed.
    """
    _kernel = kernel or _default_kernel()

    genomic_paused = (consent_flags & _LAYER_GENOMIC) == 0

    if genomic_paused:
        logger.info(
            "Layer-2 paused for user %s — applying genomic fallback (§4.3)",
            user_a_id,
        )
        result = _kernel.calculate_kin_score_no_genomic(user_a_id, user_b_id)
        raw_score = result.get("final_score")
        if raw_score is None:
            raw_score = float(result.get("kin_score", 0.0)) / 100.0
        final_score = _clamp(raw_score * _GENOMIC_PAUSED_PENALTY, 0.0, 1.0)
        return final_score, True
    else:
        result = _kernel.calculate_kin_score(user_a_id, user_b_id)
        raw_score = result.get("final_score")
        if raw_score is None:
            raw_score = float(result.get("kin_score", 0.0)) / 100.0
        return _clamp(raw_score, 0.0, 1.0), False


def _clamp(value: float, lo: float, hi: float) -> float:
    return max(lo, min(hi, value))


# ---------------------------------------------------------------------------
# Module-level kernel singleton (lazy, initialised by service startup)
# ---------------------------------------------------------------------------

_kernel_instance: "KCKernel | None" = None


def _default_kernel() -> "KCKernel":
    if _kernel_instance is None:
        raise RuntimeError(
            "KC kernel not initialised.  Call compute.init_kernel() at "
            "service startup before handling requests."
        )
    return _kernel_instance


def init_kernel(kernel: "KCKernel") -> None:
    """Register the singleton kernel.  Call once during service startup."""
    global _kernel_instance
    _kernel_instance = kernel


# ---------------------------------------------------------------------------
# KCKernel extension — no-genomic path
# ---------------------------------------------------------------------------
# The full KCKernel lives in kin_score_algorithm.py.  We monkey-patch a
# `calculate_kin_score_no_genomic` method so that the consent-aware path
# has a clean API without forking the core algorithm file.

try:
    from kin_score_algorithm import KCKernel  # type: ignore[import-untyped]

    if not hasattr(KCKernel, "calculate_kin_score_no_genomic"):

        def _calculate_kin_score_no_genomic(
            self: KCKernel, user_a_id: str, user_b_id: str
        ) -> dict:
            """Score without Layer-2 (genetic) signals.

            Zeroes the DNA / facial similarity weights and re-runs the
            standard scoring pipeline so all other layers still contribute.
            """
            original_weights = {
                k: self.WEIGHTS[k] for k in ("dna_cr_verified", "facial_similarity")
            }
            try:
                self.WEIGHTS["dna_cr_verified"] = 0.0
                self.WEIGHTS["facial_similarity"] = 0.0
                return self.calculate_kin_score(user_a_id, user_b_id)
            finally:
                # Always restore original weights (thread-unsafe at high
                # concurrency; kernel should be used behind an async lock or
                # per-request instances for production scale).
                self.WEIGHTS.update(original_weights)

        KCKernel.calculate_kin_score_no_genomic = (  # type: ignore[attr-defined]
            _calculate_kin_score_no_genomic
        )

except ImportError:
    # Running in test environments where the full algorithm is not present.
    logger.debug("kin_score_algorithm import unavailable in this environment")
