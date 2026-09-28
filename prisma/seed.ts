// Seed script — creates demo users and realistic domain records.
import { PrismaClient, Role } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

const phones = ["(415) 555-0132", "(212) 555-0187", "(312) 555-0149", "(617) 555-0110"];
const cities = ["Chicago, IL", "Austin, TX", "Boston, MA", "Denver, CO", "Seattle, WA"];

function pick<T>(arr: T[], i: number): T { return arr[i % arr.length]; }
function amount(i: number, base = 1000): number { return Math.round((base + ((i * 7919) % 900) * base) * 100) / 100; }
function daysAgo(i: number, spread = 180): Date { return new Date(Date.now() - ((i * 37) % spread) * 86400000); }

async function main() {
  const database = new URL(process.env.DATABASE_URL || "").pathname.slice(1);
  if (process.env.NODE_ENV === "production" || process.env.ALLOW_DEMO_SEED !== "true" || !/^(demo_|inspection_test_)/.test(database)) throw new Error("Demo seeding requires ALLOW_DEMO_SEED=true and a dedicated demo_ or inspection_test_ database");
  if (!process.env.DEMO_PASSWORD || process.env.DEMO_PASSWORD.length < 16) throw new Error("Set DEMO_PASSWORD to at least 16 characters");
  const passwordHash = await bcrypt.hash(process.env.DEMO_PASSWORD!, 12);
  const demoUsers: Array<[string, string, Role]> = [
    ["admin@ai-medicare-radv-hcc-evidence-validator.local", "Demo Admin", "ADMIN"],
    ["manager@ai-medicare-radv-hcc-evidence-validator.local", "Demo Manager", "MANAGER"],
    ["analyst@ai-medicare-radv-hcc-evidence-validator.local", "Demo Analyst", "ANALYST"],
  ];
  for (const [email, name, role] of demoUsers) {
    await prisma.user.upsert({ where: { email }, update: {}, create: { email, name, role, passwordHash } });
  }

  const STATUSES_AuditYear = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.auditYear.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.auditYear.create({
      data: {
      name: `Name ${String(i + 1).padStart(3, "0")}`,
      year: 5 + ((i * 13) % 95),
      payer: `Payer ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_AuditYear, i),
      dueDate: daysAgo(i),
      sampledMembers: 5 + ((i * 13) % 95),
      estimatedExposure: amount(i, 250)
      },
    });
  }

  const auditYearRefs = await prisma.auditYear.findMany({ select: { id: true } });

  const STATUSES_Member = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.member.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.member.create({
      data: {
      memberRef: `MemberRef ${String(i + 1).padStart(3, "0")}`,
      plan: `Plan ${String(i + 1).padStart(3, "0")}`,
      pcpName: `PcpName ${String(i + 1).padStart(3, "0")}`,
      rafScore: amount(i, 250),
      status: pick(STATUSES_Member, i),
      dob: daysAgo(i),
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  const STATUSES_Diagnosis = ["SUPPORTED", "UNSUPPORTED", "PENDING_REVIEW", "QUERIED"];
  await prisma.diagnosis.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.diagnosis.create({
      data: {
      icd10: `Icd10 ${String(i + 1).padStart(3, "0")}`,
      description: `Description ${String(i + 1).padStart(3, "0")}`,
      hccCategory: `HccCategory ${String(i + 1).padStart(3, "0")}`,
      memberRef: `MemberRef ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_Diagnosis, i),
      paymentYearImpact: amount(i, 250),
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  const STATUSES_EvidenceDocument = ["RECEIVED", "LINKED", "GAP", "REJECTED"];
  await prisma.evidenceDocument.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.evidenceDocument.create({
      data: {
      title: `Title ${String(i + 1).padStart(3, "0")}`,
      source: `Source ${String(i + 1).padStart(3, "0")}`,
      memberRef: `MemberRef ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_EvidenceDocument, i),
      serviceDate: daysAgo(i),
      providerNpi: `ProviderNpi ${String(i + 1).padStart(3, "0")}`,
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  const STATUSES_ChartReview = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.chartReview.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.chartReview.create({
      data: {
      memberRef: `MemberRef ${String(i + 1).padStart(3, "0")}`,
      reviewer: `Reviewer ${String(i + 1).padStart(3, "0")}`,
      result: `Result ${String(i + 1).padStart(3, "0")}`,
      supportedDx: 5 + ((i * 13) % 95),
      unsupportedDx: 5 + ((i * 13) % 95),
      completedAt: daysAgo(i),
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  const STATUSES_HccGap = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.hccGap.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.hccGap.create({
      data: {
      memberRef: `MemberRef ${String(i + 1).padStart(3, "0")}`,
      hccCategory: `HccCategory ${String(i + 1).padStart(3, "0")}`,
      gapReason: `GapReason ${String(i + 1).padStart(3, "0")}`,
      severity: `Severity ${String(i + 1).padStart(3, "0")}`,
      dollarImpact: amount(i, 250),
      status: pick(STATUSES_HccGap, i),
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  const STATUSES_Submission = ["DRAFT", "ASSEMBLED", "SUBMITTED", "ACCEPTED"];
  await prisma.submission.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.submission.create({
      data: {
      name: `Name ${String(i + 1).padStart(3, "0")}`,
      cmsBatch: `CmsBatch ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_Submission, i),
      submittedAt: daysAgo(i),
      recordsIncluded: 5 + ((i * 13) % 95),
      trackingId: `TrackingId ${String(i + 1).padStart(3, "0")}`,
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  const STATUSES_RepaymentEstimate = ["DRAFT", "REVIEWED", "FINAL"];
  await prisma.repaymentEstimate.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.repaymentEstimate.create({
      data: {
      name: `Name ${String(i + 1).padStart(3, "0")}`,
      lowEstimate: amount(i, 250),
      midEstimate: amount(i, 250),
      highEstimate: amount(i, 250),
      status: pick(STATUSES_RepaymentEstimate, i),
      methodology: `Methodology ${String(i + 1).padStart(3, "0")}`,
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  const STATUSES_CodingAppeal = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.codingAppeal.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.codingAppeal.create({
      data: {
      memberRef: `MemberRef ${String(i + 1).padStart(3, "0")}`,
      icd10: `Icd10 ${String(i + 1).padStart(3, "0")}`,
      reason: `Reason ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_CodingAppeal, i),
      submittedAt: daysAgo(i),
      outcome: `Outcome ${String(i + 1).padStart(3, "0")}`,
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  const STATUSES_VendorFile = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.vendorFile.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.vendorFile.create({
      data: {
      fileName: `FileName ${String(i + 1).padStart(3, "0")}`,
      vendor: `Vendor ${String(i + 1).padStart(3, "0")}`,
      recordType: `RecordType ${String(i + 1).padStart(3, "0")}`,
      recordCount: 5 + ((i * 13) % 95),
      status: pick(STATUSES_VendorFile, i),
      receivedAt: daysAgo(i),
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  const STATUSES_Finding = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.finding.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.finding.create({
      data: {
      title: `Title ${String(i + 1).padStart(3, "0")}`,
      category: `Category ${String(i + 1).padStart(3, "0")}`,
      severity: `Severity ${String(i + 1).padStart(3, "0")}`,
      owner: `Owner ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_Finding, i),
      exposure: amount(i, 250),
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  const STATUSES_ComplianceTask = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.complianceTask.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.complianceTask.create({
      data: {
      title: `Title ${String(i + 1).padStart(3, "0")}`,
      owner: `Owner ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_ComplianceTask, i),
      dueDate: daysAgo(i),
      priority: `Priority ${String(i + 1).padStart(3, "0")}`,
      notes: `Notes ${String(i + 1).padStart(3, "0")}`,
      auditYear: { connect: { id: auditYearRefs[i % auditYearRefs.length].id } }
      },
    });
  }

  await prisma.auditLog.create({ data: { actorName: "Seeder", action: "SEED", entity: "system", detail: "Demo dataset created" } });

  console.log("Seeded demo users and domain records.");
}

main().catch((e) => { console.error(e); process.exit(1); }).finally(async () => { await prisma.$disconnect(); });
