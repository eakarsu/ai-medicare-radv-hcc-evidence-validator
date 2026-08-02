CREATE TABLE IF NOT EXISTS app_users(
  id BIGSERIAL PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,role TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS workflow_cases(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,reference TEXT UNIQUE NOT NULL,subject TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,payload JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_events(
  id BIGSERIAL PRIMARY KEY,event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),actor TEXT NOT NULL,action TEXT NOT NULL,object_type TEXT NOT NULL,object_reference TEXT NOT NULL,detail TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS saved_analyses(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,actor TEXT NOT NULL,analysis_type TEXT NOT NULL,inputs JSONB NOT NULL,result JSONB NOT NULL,provider TEXT NOT NULL,model TEXT,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS integration_state(
  id TEXT PRIMARY KEY,name TEXT NOT NULL,category TEXT NOT NULL,mode TEXT NOT NULL,status TEXT NOT NULL,last_tested TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_workflow ON workflow_cases(workflow_id);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_due ON workflow_cases(due_date);
CREATE INDEX IF NOT EXISTS idx_audit_events_time ON audit_events(event_time DESC);

CREATE TABLE IF NOT EXISTS "op_hcc_validation"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_memberId" TEXT NOT NULL,
  "data_paymentYear" NUMERIC(16,2) NOT NULL,
  "data_hccCode" TEXT NOT NULL,
  "data_clinicalEvidence" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_hcc_validation_due ON "op_hcc_validation"(due_date);

CREATE TABLE IF NOT EXISTS "op_record_chase"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_provider" TEXT NOT NULL,
  "data_memberId" TEXT NOT NULL,
  "data_serviceDate" DATE NOT NULL,
  "data_requestStatus" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_record_chase_due ON "op_record_chase"(due_date);

CREATE TABLE IF NOT EXISTS "op_coding_review"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_diagnosis" TEXT NOT NULL,
  "data_recordType" TEXT NOT NULL,
  "data_signatureStatus" TEXT NOT NULL,
  "data_reviewRationale" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_coding_review_due ON "op_coding_review"(due_date);

CREATE TABLE IF NOT EXISTS "op_audit_sample"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_auditYear" NUMERIC(16,2) NOT NULL,
  "data_sampleId" TEXT NOT NULL,
  "data_submissionDeadline" DATE NOT NULL,
  "data_sampleStatus" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_audit_sample_due ON "op_audit_sample"(due_date);

CREATE TABLE IF NOT EXISTS "op_repayment"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_contract" TEXT NOT NULL,
  "data_unsupportedHccs" NUMERIC(16,2) NOT NULL,
  "data_estimatedExposure" NUMERIC(16,2) NOT NULL,
  "data_methodology" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_repayment_due ON "op_repayment"(due_date);

CREATE TABLE IF NOT EXISTS "op_provider_pattern"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_provider" TEXT NOT NULL,
  "data_memberCount" NUMERIC(16,2) NOT NULL,
  "data_pattern" TEXT NOT NULL,
  "data_riskLevel" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_provider_pattern_due ON "op_provider_pattern"(due_date);

CREATE TABLE IF NOT EXISTS "op_appeal_package"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_findingId" TEXT NOT NULL,
  "data_appealBasis" TEXT NOT NULL,
  "data_supportingEvidence" TEXT NOT NULL,
  "data_dueDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_appeal_package_due ON "op_appeal_package"(due_date);

CREATE TABLE IF NOT EXISTS "op_readiness"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_contract" TEXT NOT NULL,
  "data_assessmentPeriod" TEXT NOT NULL,
  "data_controlGap" TEXT NOT NULL,
  "data_readinessScore" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_readiness_due ON "op_readiness"(due_date);

CREATE TABLE IF NOT EXISTS "op_ma_contracts"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_contractId" TEXT NOT NULL,
  "data_planName" TEXT NOT NULL,
  "data_enrollment" NUMERIC(16,2) NOT NULL,
  "data_paymentYear" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_ma_contracts_due ON "op_ma_contracts"(due_date);

CREATE TABLE IF NOT EXISTS "op_provider_directory"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_provider" TEXT NOT NULL,
  "data_npi" TEXT NOT NULL,
  "data_specialty" TEXT NOT NULL,
  "data_responseRate" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_provider_directory_due ON "op_provider_directory"(due_date);

CREATE TABLE IF NOT EXISTS "op_record_inventory"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_memberId" TEXT NOT NULL,
  "data_recordType" TEXT NOT NULL,
  "data_pageCount" NUMERIC(16,2) NOT NULL,
  "data_completeness" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_record_inventory_due ON "op_record_inventory"(due_date);

CREATE TABLE IF NOT EXISTS "op_submission_batches"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_batchId" TEXT NOT NULL,
  "data_auditYear" NUMERIC(16,2) NOT NULL,
  "data_recordCount" NUMERIC(16,2) NOT NULL,
  "data_submissionDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_submission_batches_due ON "op_submission_batches"(due_date);
