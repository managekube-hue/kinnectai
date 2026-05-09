package dna

import (
	"time"
)

// DNAUploadRequest represents a DNA data upload request.
type DNAUploadRequest struct {
	RequestID        string    `json:"request_id"`
	UserID           string    `json:"user_id"`
	VCFUrl           string    `json:"vcf_url"`
	DNAProvider      string    `json:"dna_provider"` // "ANCESTRY", "23ANDME", "MYHERITAGE"
	FileName         string    `json:"file_name"`
	FileSizeBytes    int64     `json:"file_size_bytes"`
	FileHash         string    `json:"file_hash"` // SHA256
	CreatedAt        time.Time `json:"created_at"`
	Status           string    `json:"status"` // "PENDING", "PROCESSING", "COMPLETED", "FAILED"
}

// DNAUploadResponse represents the result of a DNA upload.
type DNAUploadResponse struct {
	ResponseID       string    `json:"response_id"`
	RequestID        string    `json:"request_id"`
	UserID           string    `json:"user_id"`
	Status           string    `json:"status"`
	ProcessingStatus DNAProcessingStatus `json:"processing_status"`
	HasError         bool      `json:"has_error"`
	ErrorMessage     string    `json:"error_message,omitempty"`
	CompletedAt      *time.Time `json:"completed_at,omitempty"`
}

// VCFError represents an error in VCF file processing.
type VCFError struct {
	ErrorID          string    `json:"error_id"`
	UploadID         string    `json:"upload_id"`
	LineNumber       int       `json:"line_number,omitempty"`
	VariantID        string    `json:"variant_id,omitempty"`
	ErrorType        string    `json:"error_type"` // "INVALID_FORMAT", "MISSING_DATA", "DUPLICATE"
	Description      string    `json:"description"`
	CanContinue      bool      `json:"can_continue"`
}

// HaplogroupEmbedding represents a haplogroup genetic ancestry embedding.
type HaplogroupEmbedding struct {
	EmbeddingID      string    `json:"embedding_id"`
	UserID           string    `json:"user_id"`
	MtDNAHaplogroup  string    `json:"mtdna_haplogroup"`
	YDNAHaplogroup   string    `json:"ydna_haplogroup,omitempty"`
	MtDNAVector      []float64 `json:"mtdna_vector"` // embedding
	YDNAVector       []float64 `json:"ydna_vector,omitempty"`
	PopulationOrigins []string `json:"population_origins"`
	Confidence       float64   `json:"confidence"`
	CreatedAt        time.Time `json:"created_at"`
}

// SNPProfile represents Single Nucleotide Polymorphism analysis.
type SNPProfile struct {
	ProfileID        string    `json:"profile_id"`
	UserID           string    `json:"user_id"`
	TotalSNPsAnalyzed int      `json:"total_snps_analyzed"`
	RiskAlleleCount  int       `json:"risk_allele_count"`
	TraitPredictions map[string]interface{} `json:"trait_predictions"`
	HealthRisks      []string  `json:"health_risks,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
}

// DNAProcessingStatus represents detailed processing status.
type DNAProcessingStatus struct {
	FileValidated    bool      `json:"file_validated"`
	ValidatedAt      *time.Time `json:"validated_at,omitempty"`
	VariantsExtracted bool     `json:"variants_extracted"`
	ExtractedAt      *time.Time `json:"extracted_at,omitempty"`
	HaplogroupPhased bool      `json:"haplogroup_phased"`
	PhasedAt         *time.Time `json:"phased_at,omitempty"`
	MatchesComputed  bool      `json:"matches_computed"`
	ComputedAt       *time.Time `json:"computed_at,omitempty"`
	PercentComplete  int       `json:"percent_complete"`
}

// DNAConfidence represents confidence scores for DNA analysis.
type DNAConfidence struct {
	ConfidenceID     string    `json:"confidence_id"`
	UserID           string    `json:"user_id"`
	HaplogroupConfidence float64 `json:"haplogroup_confidence"`
	AncestryConfidence   float64 `json:"ancestry_confidence"`
	MatchConfidence      float64 `json:"match_confidence"`
	OverallConfidence    float64 `json:"overall_confidence"`
	AnalyzedAt       time.Time `json:"analyzed_at"`
}

// PIHATResult represents PIHAT (Probabilistic IBD Haplotype Analysis Tool) result.
type PIHATResult struct {
	ResultID         string    `json:"result_id"`
	UserID           string    `json:"user_id"`
	TargetUserID     string    `json:"target_user_id"`
	IBDSharing       float64   `json:"ibd_sharing"` // 0-1
	ExpectedRelation string    `json:"expected_relation"`
	Confidence       float64   `json:"confidence"`
	ComputedAt       time.Time `json:"computed_at"`
}

// GenomicSimilarityScore represents genomic similarity between two individuals.
type GenomicSimilarityScore struct {
	ScoreID          string    `json:"score_id"`
	UserID           string    `json:"user_id"`
	TargetUserID     string    `json:"target_user_id"`
	SimilarityScore  float64   `json:"similarity_score"` // 0-1
	SharedSegments   int       `json:"shared_segments"` // number of IBD segments
	TotalCentiMorgans float64  `json:"total_centiMorgans"` // cM
	ComputedAt       time.Time `json:"computed_at"`
}

// AncientDNAReference represents reference ancient DNA for ancestry matching.
type AncientDNAReference struct {
	ReferenceID      string    `json:"reference_id"`
	Population       string    `json:"population"`
	Era              string    `json:"era"` // "BRONZE_AGE", "IRON_AGE", etc
	Location         string    `json:"location"`
	CalibrationYears int       `json:"calibration_years"` // years before present
	GenomeCoverage   float64   `json:"genome_coverage"` // 0-1
	RelatedPopulations []string `json:"related_populations"`
}
