-- Moderation reports table for tracking user-reported content
CREATE TABLE moderation_reports (
    id UUID PRIMARY KEY,
    content_id VARCHAR(255) NOT NULL,
    content_type VARCHAR(50) NOT NULL DEFAULT 'memory',
    reporter_id UUID NOT NULL,
    reason VARCHAR(100) NOT NULL,
    details TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'under_review', 'resolved', 'dismissed')),
    priority VARCHAR(20) NOT NULL DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    reviewed_by UUID,
    reviewed_at TIMESTAMP,
    resolution TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for efficient querying
CREATE INDEX idx_moderation_reports_content_id ON moderation_reports(content_id);
CREATE INDEX idx_moderation_reports_reporter_id ON moderation_reports(reporter_id);
CREATE INDEX idx_moderation_reports_status ON moderation_reports(status);
CREATE INDEX idx_moderation_reports_priority ON moderation_reports(priority);
CREATE INDEX idx_moderation_reports_created_at ON moderation_reports(created_at DESC);
CREATE INDEX idx_moderation_reports_status_priority ON moderation_reports(status, priority, created_at DESC);

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_moderation_reports_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_moderation_reports_updated_at
    BEFORE UPDATE ON moderation_reports
    FOR EACH ROW
    EXECUTE FUNCTION update_moderation_reports_updated_at();
