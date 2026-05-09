// SRS §23.1 Category 12 — DNA / Bioidentity types
package dna

import (
	"time"

	"github.com/google/uuid"
)

// DNAUploadRequest is the payload for submitting raw DNA data.
type DNAUploadRequest struct {
	UserID      uuid.UUID `json:"user_id" binding:"required"`
	FileName    string    `json:"file_name" binding:"required"`
	FileFormat  string    `json:"file_format" binding:"required"` // vcf | 23andme | ancestry | raw_genotype
	StorageRef  string    `json:"storage_ref" binding:"required"` // pre-signed S3 key
	ConsentToken string   `json:"consent_token" binding:"required"`
}

// DNAUploadResponse confirms a DNA upload was accepted.
type DNAUploadResponse struct {
	UploadID    uuid.UUID `json:"upload_id"`
	UserID      uuid.UUID `json:"user_id"`
	Status      string    `json:"status"` // pending | processing | completed | failed
	QueuedAt    time.Time `json:"queued_at"`
}

// VCFError represents a parsing error in a VCF file.
type VCFError struct {
	Line        int    `json:"line"`
	Field       string `json:"field"`
	Description string `json:"description"`
	Severity    string `json:"severity"` // warning | error
}

// HaplogroupEmbedding stores a user's haplogroup as a vector embedding for similarity search.
type HaplogroupEmbedding struct {
	UserID      uuid.UUID `json:"user_id"`
	Haplogroup  string    `json:"haplogroup"`
	Clade       string    `json:"clade"`
	Embedding   []float64 `json:"embedding"`
	ComputedAt  time.Time `json:"computed_at"`
}

// SNPProfile holds a processed SNP (single-nucleotide polymorphism) profile.
type SNPProfile struct {
	ProfileID   uuid.UUID `json:"profile_id"`
	UserID      uuid.UUID `json:"user_id"`
	SNPCount    int       `json:"snp_count"`
	Coverage    float64   `json:"coverage_pct"`
	Quality     string    `json:"quality"` // low | medium | high
	Platform    string    `json:"platform"` // illumina | nanopore | 23andme
	ProcessedAt time.Time `json:"processed_at"`
}

// DNAProcessingStatus tracks pipeline stage for a DNA upload.
type DNAProcessingStatus struct {
	UploadID    uuid.UUID  `json:"upload_id"`
	Stage       string     `json:"stage"` // validate | normalize | embed | index | complete
	Progress    float64    `json:"progress_pct"`
	ErrorMsg    string     `json:"error,omitempty"`
	UpdatedAt   time.Time  `json:"updated_at"`
}

// DNAConfidence reports the confidence of a DNA-based relationship prediction.
type DNAConfidence struct {
	UserAID     uuid.UUID `json:"user_a_id"`
	UserBID     uuid.UUID `json:"user_b_id"`
	IBDPercent  float64   `json:"ibd_percent"`   // identity-by-descent
	Confidence  float64   `json:"confidence"`
	Relationship string   `json:"predicted_relationship"`
}

// PIHATResult is the output of PI_HAT (proportion identity-by-descent) analysis.
type PIHATResult struct {
	UserAID   uuid.UUID `json:"user_a_id"`
	UserBID   uuid.UUID `json:"user_b_id"`
	Z0        float64   `json:"z0"`
	Z1        float64   `json:"z1"`
	Z2        float64   `json:"z2"`
	PIHAT     float64   `json:"pi_hat"`
	ComputedAt time.Time `json:"computed_at"`
}

// GenomicSimilarityScore is the overall DNA-based similarity between two users.
type GenomicSimilarityScore struct {
	UserAID     uuid.UUID `json:"user_a_id"`
	UserBID     uuid.UUID `json:"user_b_id"`
	Score       float64   `json:"score"`        // 0.0–1.0
	IBDPercent  float64   `json:"ibd_percent"`
	ComputedAt  time.Time `json:"computed_at"`
}

// AncientDNAReference is a reference to a published ancient DNA sample used for comparison.
type AncientDNAReference struct {
	ReferenceID string `json:"reference_id"`
	Label       string `json:"label"`       // e.g. "Yamnaya_Samara"
	Source      string `json:"source"`      // publication or dataset
	Period      string `json:"period"`      // e.g. "3000–2500 BCE"
	Region      string `json:"region"`
}
