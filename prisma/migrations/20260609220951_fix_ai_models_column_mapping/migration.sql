-- AlterTable
ALTER TABLE "ai_models" ALTER COLUMN "provider" SET DEFAULT 'openrouter';

-- AlterTable
ALTER TABLE "invitation_codes" ALTER COLUMN "expires_at" SET DEFAULT NOW() + INTERVAL '2 months';
