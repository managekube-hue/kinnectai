// SRS §23.1 Category 20 — GDPR / Compliance types
package compliance

import (
	"time"

	"github.com/google/uuid"
)

// GDPRExportResponse is the payload returned when a user requests their data export.
type GDPRExportResponse struct {
	ExportID    uuid.UUID `json:"export_id"`
	UserID      uuid.UUID `json:"user_id"`
	DownloadURL string    `json:"download_url"`
	ExpiresAt   time.Time `json:"expires_at"`
	GeneratedAt time.Time `json:"generated_at"`
	Checksum    string    `json:"checksum"`
}

// ConsentAuditLog records a consent grant or revocation for regulatory purposes.
type ConsentAuditLog struct {
	ID           uuid.UUID `json:"id"`
	UserID       uuid.UUID `json:"user_id"`
	ConsentKey   string    `json:"consent_key"`
	Action       string    `json:"action"` // granted | revoked | updated
	LegalBasis   string    `json:"legal_basis"` // consent | contract | legitimate_interest
	IPAddress    string    `json:"ip_address"`
	UserAgent    string    `json:"user_agent"`
	OccurredAt   time.Time `json:"occurred_at"`
}

// DataResidencyPolicy defines where data for a given user or region must be stored.
type DataResidencyPolicy struct {
	PolicyID      uuid.UUID `json:"policy_id"`
	Region        string    `json:"region"`
	DataTypes     []string  `json:"data_types"`
	RequiredZone  string    `json:"required_zone"` // us | eu | apac
	Enforced      bool      `json:"enforced"`
	EffectiveDate time.Time `json:"effective_date"`
}

// ComplianceReport is a scheduled or on-demand compliance summary.
type ComplianceReport struct {
	ReportID     uuid.UUID         `json:"report_id"`
	Framework    string            `json:"framework"` // GDPR | HIPAA | BIPAA | SOC2
	Period       string            `json:"period"`
	Status       string            `json:"status"` // passing | failing | partial
	Controls     map[string]string `json:"controls"` // control_id -> pass|fail
	GeneratedAt  time.Time         `json:"generated_at"`
	GeneratedBy  string            `json:"generated_by"`
}

// HIPAAAudit records access to health-adjacent data under HIPAA rules.
type HIPAAAudit struct {
	AuditID     uuid.UUID `json:"audit_id"`
	ActorID     uuid.UUID `json:"actor_id"`
	Resource    string    `json:"resource"`
	Action      string    `json:"action"`
	PHIAccessed bool      `json:"phi_accessed"`
	OccurredAt  time.Time `json:"occurred_at"`
}

// BIPAAAudit records access to biometric data under BIPA rules.
type BIPAAAudit struct {
	AuditID       uuid.UUID `json:"audit_id"`
	ActorID       uuid.UUID `json:"actor_id"`
	SubjectUserID uuid.UUID `json:"subject_user_id"`
	DataType      string    `json:"data_type"` // voiceprint | face | fingerprint
	ConsentOnFile bool      `json:"consent_on_file"`
	OccurredAt    time.Time `json:"occurred_at"`
}

// SOC2Control represents a single SOC 2 Trust Service Criterion control.
type SOC2Control struct {
	ControlID   string    `json:"control_id"`
	Category    string    `json:"category"` // CC1 | CC2 | CC3 | CC4 | CC5 | CC6 | CC7 | CC8 | CC9
	Description string    `json:"description"`
	Status      string    `json:"status"` // implemented | partial | not_implemented
	Evidence    string    `json:"evidence_ref,omitempty"`
	AssessedAt  time.Time `json:"assessed_at"`
}

// GDPRDeletionReport confirms completion of a right-to-erasure request.
type GDPRDeletionReport struct {
	RequestID    uuid.UUID   `json:"request_id"`
	UserID       uuid.UUID   `json:"user_id"`
	TablesCleared []string   `json:"tables_cleared"`
	BlobsDeleted  int        `json:"blobs_deleted"`
	CompletedAt  time.Time   `json:"completed_at"`
	Checksum     string      `json:"checksum"`
}
