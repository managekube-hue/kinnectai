package compliance

import (
	"time"
)

// GDPRExportResponse represents user data export for GDPR compliance.
type GDPRExportResponse struct {
	ExportID       string    `json:"export_id"`
	UserID         string    `json:"user_id"`
	ExportFormat   string    `json:"export_format"` // "JSON", "CSV", "XML"
	DataCategories []string  `json:"data_categories"` // "PERSONAL", "ACTIVITY", "COMMUNICATIONS"
	ExportURL      string    `json:"export_url"`
	ExpiresAt      time.Time `json:"expires_at"`
	CreatedAt      time.Time `json:"created_at"`
	Status         string    `json:"status"` // "PENDING", "READY", "EXPIRED"
	FileSize       int       `json:"file_size"` // bytes
}

// ConsentAuditLog represents audit trail for user consent.
type ConsentAuditLog struct {
	LogID          string    `json:"log_id"`
	UserID         string    `json:"user_id"`
	ConsentType    string    `json:"consent_type"`
	Granted        bool      `json:"granted"`
	GrantedAt      time.Time `json:"granted_at"`
	RevokedAt      *time.Time `json:"revoked_at,omitempty"`
	ConsentVersion string    `json:"consent_version"`
	IPAddress      string    `json:"ip_address"`
	UserAgent      string    `json:"user_agent"`
	Jurisdiction   string    `json:"jurisdiction"`
}

// DataResidencyPolicy represents data residency policy for a user.
type DataResidencyPolicy struct {
	PolicyID       string    `json:"policy_id"`
	UserID         string    `json:"user_id"`
	PrimaryRegion  string    `json:"primary_region"` // "US", "EU", "CA", "AU"
	AllowedRegions []string  `json:"allowed_regions"`
	RestrictedRegions []string `json:"restricted_regions"`
	ComplianceFrameworks []string `json:"compliance_frameworks"` // "GDPR", "CCPA", "PIPEDA"
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
	EnforcedAt     time.Time `json:"enforced_at"`
}

// ComplianceReport represents a compliance audit report.
type ComplianceReport struct {
	ReportID       string    `json:"report_id"`
	Framework      string    `json:"framework"` // "SOC2", "ISO27001", "HIPAA"
	AuditDate      time.Time `json:"audit_date"`
	Period         string    `json:"period"` // "Q1_2024", "2024"
	Status         string    `json:"status"` // "PASSED", "PASSED_WITH_FINDINGS", "FAILED"
	Findings       []ComplianceFinding `json:"findings,omitempty"`
	CertificationURL string   `json:"certification_url,omitempty"`
	ExpiresAt      *time.Time `json:"expires_at,omitempty"`
}

// ComplianceFinding represents a single compliance finding.
type ComplianceFinding struct {
	FindingID      string    `json:"finding_id"`
	Severity       string    `json:"severity"` // "CRITICAL", "MAJOR", "MINOR"
	Description    string    `json:"description"`
	RemediationRequired bool   `json:"remediation_required"`
	RemediationDeadline *time.Time `json:"remediation_deadline,omitempty"`
	RemediatedAt   *time.Time `json:"remediated_at,omitempty"`
}

// HIPAAAudit represents HIPAA audit trail.
type HIPAAAudit struct {
	AuditID        string    `json:"audit_id"`
	Action         string    `json:"action"` // "PHI_ACCESS", "PHI_MODIFY", "PHI_EXPORT"
	UserID         string    `json:"user_id"`
	PHICategory    string    `json:"phi_category"` // "PATIENT_RECORDS", "GENETIC_DATA"
	AccessLevel    string    `json:"access_level"`
	Timestamp      time.Time `json:"timestamp"`
	IPAddress      string    `json:"ip_address"`
	Encrypted      bool      `json:"encrypted"`
}

// BIPAAudit represents BIPA (Illinois Biometric Information Privacy Act) audit trail.
type BIPAAudit struct {
	AuditID        string    `json:"audit_id"`
	Action         string    `json:"action"` // "CAPTURE", "STORE", "USE", "DELETE"
	UserID         string    `json:"user_id"`
	BiometricType  string    `json:"biometric_type"` // "VOICEPRINT", "FACIAL", "FINGERPRINT"
	ConsentPresent bool      `json:"consent_present"`
	Timestamp      time.Time `json:"timestamp"`
	Details        map[string]interface{} `json:"details,omitempty"`
}

// SOC2Control represents a SOC 2 control and its status.
type SOC2Control struct {
	ControlID      string    `json:"control_id"`
	Category       string    `json:"category"` // "CC", "A", "C", "I", "P"
	ControlName    string    `json:"control_name"`
	Description    string    `json:"description"`
	Status         string    `json:"status"` // "IMPLEMENTED", "OPERATING", "NEEDS_IMPROVEMENT"
	LastTestedAt   time.Time `json:"last_tested_at"`
	NextTestDue    time.Time `json:"next_test_due"`
	Findings       []string  `json:"findings,omitempty"`
}

// GDPRDeletionReport represents a GDPR data deletion report.
type GDPRDeletionReport struct {
	ReportID       string    `json:"report_id"`
	UserID         string    `json:"user_id"`
	DeletionType   string    `json:"deletion_type"` // "FULL", "PARTIAL", "ANONYMIZATION"
	DataCategories []string  `json:"data_categories"` // what was deleted
	ItemsDeleted   int       `json:"items_deleted"`
	ItemsRetained  int       `json:"items_retained"` // if partial
	DeletedAt      time.Time `json:"deleted_at"`
	VerifiedAt     *time.Time `json:"verified_at,omitempty"`
	Status         string    `json:"status"` // "PENDING", "COMPLETED", "VERIFIED"
	Reason         string    `json:"reason"`
}
