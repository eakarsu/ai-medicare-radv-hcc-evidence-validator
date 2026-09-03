-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'MANAGER', 'ANALYST');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'ANALYST',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "actorId" TEXT,
    "actorName" TEXT,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT,
    "detail" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditYear" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "payer" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "dueDate" TIMESTAMP(3),
    "sampledMembers" INTEGER NOT NULL,
    "estimatedExposure" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AuditYear_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Member" (
    "id" TEXT NOT NULL,
    "memberRef" TEXT NOT NULL,
    "plan" TEXT NOT NULL,
    "pcpName" TEXT NOT NULL,
    "rafScore" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "dob" TIMESTAMP(3),
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Member_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Diagnosis" (
    "id" TEXT NOT NULL,
    "icd10" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "hccCategory" TEXT NOT NULL,
    "memberRef" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "paymentYearImpact" DOUBLE PRECISION NOT NULL,
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Diagnosis_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EvidenceDocument" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "source" TEXT NOT NULL,
    "memberRef" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "serviceDate" TIMESTAMP(3),
    "providerNpi" TEXT,
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EvidenceDocument_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChartReview" (
    "id" TEXT NOT NULL,
    "memberRef" TEXT NOT NULL,
    "reviewer" TEXT NOT NULL,
    "result" TEXT NOT NULL,
    "supportedDx" INTEGER NOT NULL,
    "unsupportedDx" INTEGER NOT NULL,
    "completedAt" TIMESTAMP(3),
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ChartReview_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HccGap" (
    "id" TEXT NOT NULL,
    "memberRef" TEXT NOT NULL,
    "hccCategory" TEXT NOT NULL,
    "gapReason" TEXT NOT NULL,
    "severity" TEXT NOT NULL,
    "dollarImpact" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "HccGap_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Submission" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "cmsBatch" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "submittedAt" TIMESTAMP(3),
    "recordsIncluded" INTEGER NOT NULL,
    "trackingId" TEXT,
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Submission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RepaymentEstimate" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "lowEstimate" DOUBLE PRECISION NOT NULL,
    "midEstimate" DOUBLE PRECISION NOT NULL,
    "highEstimate" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "methodology" TEXT NOT NULL,
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RepaymentEstimate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CodingAppeal" (
    "id" TEXT NOT NULL,
    "memberRef" TEXT NOT NULL,
    "icd10" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "submittedAt" TIMESTAMP(3),
    "outcome" TEXT,
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CodingAppeal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VendorFile" (
    "id" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "vendor" TEXT NOT NULL,
    "recordType" TEXT NOT NULL,
    "recordCount" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    "receivedAt" TIMESTAMP(3),
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "VendorFile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Finding" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "severity" TEXT NOT NULL,
    "owner" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "exposure" DOUBLE PRECISION NOT NULL,
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Finding_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ComplianceTask" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "owner" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "dueDate" TIMESTAMP(3),
    "priority" TEXT NOT NULL,
    "notes" TEXT,
    "auditYearId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ComplianceTask_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "Member" ADD CONSTRAINT "Member_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Diagnosis" ADD CONSTRAINT "Diagnosis_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EvidenceDocument" ADD CONSTRAINT "EvidenceDocument_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChartReview" ADD CONSTRAINT "ChartReview_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HccGap" ADD CONSTRAINT "HccGap_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Submission" ADD CONSTRAINT "Submission_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RepaymentEstimate" ADD CONSTRAINT "RepaymentEstimate_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CodingAppeal" ADD CONSTRAINT "CodingAppeal_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VendorFile" ADD CONSTRAINT "VendorFile_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Finding" ADD CONSTRAINT "Finding_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ComplianceTask" ADD CONSTRAINT "ComplianceTask_auditYearId_fkey" FOREIGN KEY ("auditYearId") REFERENCES "AuditYear"("id") ON DELETE SET NULL ON UPDATE CASCADE;
