BEGIN;

CREATE TABLE IF NOT EXISTS moderation_jobs (
  id BIGSERIAL PRIMARY KEY,
  content_id TEXT NOT NULL,
  author_id TEXT NOT NULL,
  payload JSONB NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('queued', 'processing', 'review', 'approved', 'rejected')),
  severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  reason_codes TEXT[] NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_moderation_jobs_status ON moderation_jobs(status);
CREATE INDEX IF NOT EXISTS idx_moderation_jobs_author_id ON moderation_jobs(author_id);
CREATE INDEX IF NOT EXISTS idx_moderation_jobs_content_id ON moderation_jobs(content_id);

CREATE TABLE IF NOT EXISTS moderation_audit_log (
  id BIGSERIAL PRIMARY KEY,
  job_id BIGINT NOT NULL REFERENCES moderation_jobs(id) ON DELETE CASCADE,
  actor_id TEXT NOT NULL,
  action TEXT NOT NULL,
  note TEXT,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_moderation_audit_log_job_id ON moderation_audit_log(job_id);

CREATE TABLE IF NOT EXISTS prd_traceability (
  id BIGSERIAL PRIMARY KEY,
  requirement_key TEXT NOT NULL UNIQUE,
  source_doc TEXT NOT NULL,
  source_section TEXT NOT NULL,
  implementation_refs JSONB NOT NULL DEFAULT '[]'::jsonb,
  test_refs JSONB NOT NULL DEFAULT '[]'::jsonb,
  owner TEXT,
  status TEXT NOT NULL CHECK (status IN ('planned', 'in_progress', 'implemented', 'verified')),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMIT;
