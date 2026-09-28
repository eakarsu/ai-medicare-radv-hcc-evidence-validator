export interface PageConfig {
  label: string;
  href: string;
  description: string;
  entities: string[];
  workflows: string[];
}

export interface EntityConfig {
  name: string;
  label: string;
  fields: Array<{ name: string; kind: "string" | "number" | "boolean" | "date" }>;
}

export interface WorkflowConfig {
  slug: string;
  title: string;
  description: string;
  prompt: string;
  fields: string[];
}

export const appConfig = {
  slug: "ai-medicare-radv-hcc-evidence-validator",
  title: "RADV Evidence Command",
  tagline: "Medicare Advantage RADV/HCC evidence validation",
  accent: "indigo",
};

export const pages: PageConfig[] = [
  {
    label: "Members & Diagnoses",
    href: "/members",
    description: "Sampled members and diagnosis support status.",
    entities: ["Member", "Diagnosis"],
    workflows: ["hcc-validate"],
  },
  {
    label: "Evidence",
    href: "/evidence",
    description: "Chart reviews, evidence documents, and HCC gaps.",
    entities: ["EvidenceDocument", "ChartReview", "HccGap"],
    workflows: ["evidence-gap-scan"],
  },
  {
    label: "Submissions & Exposure",
    href: "/submissions",
    description: "RADV packages, repayment estimates, vendor files.",
    entities: ["Submission", "RepaymentEstimate", "VendorFile"],
    workflows: ["exposure-estimate"],
  },
  {
    label: "Audit Control",
    href: "/audit",
    description: "Findings, coding appeals, audit years, compliance tasks.",
    entities: ["Finding", "CodingAppeal", "AuditYear", "ComplianceTask"],
    workflows: [],
  },
];

export const entities: Record<string, EntityConfig> = {
  AuditYear: {
    name: "AuditYear",
    label: "Audit Year",
    fields: [{ name: "name", kind: "string" }, { name: "year", kind: "number" }, { name: "payer", kind: "string" }, { name: "status", kind: "string" }, { name: "dueDate", kind: "date" }, { name: "sampledMembers", kind: "number" }, { name: "estimatedExposure", kind: "number" }],
  },
  Member: {
    name: "Member",
    label: "Member",
    fields: [{ name: "memberRef", kind: "string" }, { name: "plan", kind: "string" }, { name: "pcpName", kind: "string" }, { name: "rafScore", kind: "number" }, { name: "status", kind: "string" }, { name: "dob", kind: "date" }],
  },
  Diagnosis: {
    name: "Diagnosis",
    label: "Diagnosis",
    fields: [{ name: "icd10", kind: "string" }, { name: "description", kind: "string" }, { name: "hccCategory", kind: "string" }, { name: "memberRef", kind: "string" }, { name: "status", kind: "string" }, { name: "paymentYearImpact", kind: "number" }],
  },
  EvidenceDocument: {
    name: "EvidenceDocument",
    label: "Evidence Document",
    fields: [{ name: "title", kind: "string" }, { name: "source", kind: "string" }, { name: "memberRef", kind: "string" }, { name: "status", kind: "string" }, { name: "serviceDate", kind: "date" }, { name: "providerNpi", kind: "string" }],
  },
  ChartReview: {
    name: "ChartReview",
    label: "Chart Review",
    fields: [{ name: "memberRef", kind: "string" }, { name: "reviewer", kind: "string" }, { name: "result", kind: "string" }, { name: "supportedDx", kind: "number" }, { name: "unsupportedDx", kind: "number" }, { name: "completedAt", kind: "date" }],
  },
  HccGap: {
    name: "HccGap",
    label: "HCC Gap",
    fields: [{ name: "memberRef", kind: "string" }, { name: "hccCategory", kind: "string" }, { name: "gapReason", kind: "string" }, { name: "severity", kind: "string" }, { name: "dollarImpact", kind: "number" }, { name: "status", kind: "string" }],
  },
  Submission: {
    name: "Submission",
    label: "RADV Submission",
    fields: [{ name: "name", kind: "string" }, { name: "cmsBatch", kind: "string" }, { name: "status", kind: "string" }, { name: "submittedAt", kind: "date" }, { name: "recordsIncluded", kind: "number" }, { name: "trackingId", kind: "string" }],
  },
  RepaymentEstimate: {
    name: "RepaymentEstimate",
    label: "Repayment Estimate",
    fields: [{ name: "name", kind: "string" }, { name: "lowEstimate", kind: "number" }, { name: "midEstimate", kind: "number" }, { name: "highEstimate", kind: "number" }, { name: "status", kind: "string" }, { name: "methodology", kind: "string" }],
  },
  CodingAppeal: {
    name: "CodingAppeal",
    label: "Coding Appeal",
    fields: [{ name: "memberRef", kind: "string" }, { name: "icd10", kind: "string" }, { name: "reason", kind: "string" }, { name: "status", kind: "string" }, { name: "submittedAt", kind: "date" }, { name: "outcome", kind: "string" }],
  },
  VendorFile: {
    name: "VendorFile",
    label: "Vendor File",
    fields: [{ name: "fileName", kind: "string" }, { name: "vendor", kind: "string" }, { name: "recordType", kind: "string" }, { name: "recordCount", kind: "number" }, { name: "status", kind: "string" }, { name: "receivedAt", kind: "date" }],
  },
  Finding: {
    name: "Finding",
    label: "Audit Finding",
    fields: [{ name: "title", kind: "string" }, { name: "category", kind: "string" }, { name: "severity", kind: "string" }, { name: "owner", kind: "string" }, { name: "status", kind: "string" }, { name: "exposure", kind: "number" }],
  },
  ComplianceTask: {
    name: "ComplianceTask",
    label: "Compliance Task",
    fields: [{ name: "title", kind: "string" }, { name: "owner", kind: "string" }, { name: "status", kind: "string" }, { name: "dueDate", kind: "date" }, { name: "priority", kind: "string" }, { name: "notes", kind: "string" }],
  },
};

export const workflows: WorkflowConfig[] = [
  {
    slug: "hcc-validate",
    title: "Draft: HCC Evidence Validator",
    description: "Validate a submitted diagnosis against chart evidence.",
    prompt: "Draft a chart-evidence review with source quotations, service dates and missing documentation. Do not adjudicate clinical validity, invent a diagnosis mapping, or claim that a checklist establishes RADV compliance. Versioned coding rules and qualified human review are required.",
    fields: ["icd10", "hccCategory", "chartEvidence", "serviceDate"],
  },
  {
    slug: "exposure-estimate",
    title: "Draft: Repayment Exposure Estimator",
    description: "Estimate repayment exposure for a RADV audit year.",
    prompt: "Describe supplied repayment exposure assumptions and gaps. Do not invent an actuarial estimate, extrapolation rule, or liability without a versioned calculation model and supporting sample evidence.",
    fields: ["auditedMembers", "unsupportedRate", "avgPmpm", "paymentYear"],
  },
  {
    slug: "evidence-gap-scan",
    title: "Draft: Evidence Gap Scanner",
    description: "Scan a member profile for missing documentation.",
    prompt: "Compare the selected member diagnosis records with selected linked chart documents and encounters. List evidence gaps with source identifiers. Do not infer undocumented diagnoses or treat presence alone as clinical support.",
    fields: ["memberRef", "diagnoses", "encounters", "payer"],
  },
];

export function findPage(href: string): PageConfig | undefined {
  return pages.find((p) => p.href === href);
}
