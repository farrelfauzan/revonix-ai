-- Migration: Auth, Subscription & Payment Overhaul
-- Phase 1: Enrich User Profile
-- Phase 2: Subscription Plan Table
-- Phase 3: Invitation Code System
-- Phase 4: Better Auth Tables
-- Phase 5: Data migration from agent_subscriptions

-- ═══════════════════════════════════════════════════════════════════
-- PHASE 1: Enrich User Profile
-- ═══════════════════════════════════════════════════════════════════

-- Add new profile columns to users table
ALTER TABLE "users" ADD COLUMN "email_verified" BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE "users" ADD COLUMN "name" TEXT;
ALTER TABLE "users" ADD COLUMN "first_name" TEXT;
ALTER TABLE "users" ADD COLUMN "last_name" TEXT;
ALTER TABLE "users" ADD COLUMN "avatar" TEXT;
ALTER TABLE "users" ADD COLUMN "phone" TEXT;
ALTER TABLE "users" ADD COLUMN "company" TEXT;
ALTER TABLE "users" ADD COLUMN "job_title" TEXT;
ALTER TABLE "users" ADD COLUMN "timezone" TEXT DEFAULT 'UTC';
ALTER TABLE "users" ADD COLUMN "locale" TEXT DEFAULT 'en';
ALTER TABLE "users" ADD COLUMN "last_login_at" TIMESTAMPTZ;
ALTER TABLE "users" ADD COLUMN "last_login_ip" TEXT;
ALTER TABLE "users" ADD COLUMN "status" TEXT NOT NULL DEFAULT 'active';
ALTER TABLE "users" ADD COLUMN "updated_at" TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Make password nullable (for future SSO users)
ALTER TABLE "users" ALTER COLUMN "password" DROP NOT NULL;

-- ═══════════════════════════════════════════════════════════════════
-- PHASE 2: Subscription Plan Table
-- ═══════════════════════════════════════════════════════════════════

-- Create subscription_plans table
CREATE TABLE "subscription_plans" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "max_agents" INTEGER NOT NULL,
    "max_integrations" INTEGER NOT NULL,
    "max_workspace_users" INTEGER NOT NULL,
    "max_tokens_per_month" BIGINT NOT NULL,
    "allowed_channels" TEXT[] NOT NULL,
    "price_monthly" DECIMAL(10,2),
    "price_currency" TEXT NOT NULL DEFAULT 'USD',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "subscription_plans_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "subscription_plans_slug_key" ON "subscription_plans"("slug");

-- Seed initial plans
INSERT INTO "subscription_plans" ("id", "slug", "name", "description", "max_agents", "max_integrations", "max_workspace_users", "max_tokens_per_month", "allowed_channels", "price_monthly", "display_order")
VALUES
    (gen_random_uuid(), 'starter', 'Starter', 'For individuals getting started with AI agents', 3, 1, 3, 1000000, ARRAY['web'], 19.00, 1),
    (gen_random_uuid(), 'pro', 'Pro', 'For professionals and small teams', 10, 3, 10, 10000000, ARRAY['web', 'api'], 49.00, 2),
    (gen_random_uuid(), 'enterprise', 'Enterprise', 'For large teams with unlimited needs', 999, 999, 100, 100000000, ARRAY['web', 'api', 'whatsapp'], 149.00, 3);

-- Create user_subscriptions table
CREATE TABLE "user_subscriptions" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "plan_id" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "current_period_start" TIMESTAMPTZ NOT NULL,
    "current_period_end" TIMESTAMPTZ NOT NULL,
    "messages_used" INTEGER NOT NULL DEFAULT 0,
    "tokens_used" BIGINT NOT NULL DEFAULT 0,
    "cancel_at_period_end" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_subscriptions_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "user_subscriptions_user_id_key" ON "user_subscriptions"("user_id");
CREATE INDEX "user_subscriptions_user_id_status_idx" ON "user_subscriptions"("user_id", "status");
CREATE INDEX "user_subscriptions_plan_id_idx" ON "user_subscriptions"("plan_id");

ALTER TABLE "user_subscriptions" ADD CONSTRAINT "user_subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "user_subscriptions" ADD CONSTRAINT "user_subscriptions_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "subscription_plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- Migrate existing agent_subscriptions data to user_subscriptions
INSERT INTO "user_subscriptions" ("id", "user_id", "plan_id", "status", "current_period_start", "current_period_end", "messages_used", "tokens_used", "cancel_at_period_end", "createdAt", "updatedAt")
SELECT
    a.id,
    a."userId",
    sp.id,
    a.status,
    a.current_period_start,
    a.current_period_end,
    a.messages_used,
    a.tokens_used,
    a.cancel_at_period_end,
    a."createdAt",
    a."updatedAt"
FROM "agent_subscriptions" a
JOIN "subscription_plans" sp ON sp.slug = a.tier;

-- Drop old agent_subscriptions table
DROP TABLE "agent_subscriptions";

-- ═══════════════════════════════════════════════════════════════════
-- PHASE 3: Invitation Code System
-- ═══════════════════════════════════════════════════════════════════

-- Create invitation_codes table
CREATE TABLE "invitation_codes" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "credit_amount" DECIMAL(12,6),
    "plan_id" TEXT,
    "duration_days" INTEGER,
    "max_redemptions" INTEGER NOT NULL DEFAULT 1,
    "times_redeemed" INTEGER NOT NULL DEFAULT 0,
    "expires_at" TIMESTAMPTZ NOT NULL DEFAULT NOW() + INTERVAL '2 months',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by_id" TEXT,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "invitation_codes_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "invitation_codes_code_key" ON "invitation_codes"("code");
CREATE INDEX "invitation_codes_code_idx" ON "invitation_codes"("code");
CREATE INDEX "invitation_codes_is_active_expires_at_idx" ON "invitation_codes"("is_active", "expires_at");

ALTER TABLE "invitation_codes" ADD CONSTRAINT "invitation_codes_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "subscription_plans"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Create code_redemptions table
CREATE TABLE "code_redemptions" (
    "id" TEXT NOT NULL,
    "code_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "credits_granted" DECIMAL(12,6),
    "plan_granted" TEXT,
    "days_granted" INTEGER,
    "redeemed_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "code_redemptions_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "code_redemptions_code_id_user_id_key" ON "code_redemptions"("code_id", "user_id");
CREATE INDEX "code_redemptions_user_id_idx" ON "code_redemptions"("user_id");

ALTER TABLE "code_redemptions" ADD CONSTRAINT "code_redemptions_code_id_fkey" FOREIGN KEY ("code_id") REFERENCES "invitation_codes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "code_redemptions" ADD CONSTRAINT "code_redemptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- ═══════════════════════════════════════════════════════════════════
-- PHASE 4: Better Auth Tables
-- ═══════════════════════════════════════════════════════════════════

-- Create accounts table
CREATE TABLE "accounts" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "account_id" TEXT NOT NULL,
    "provider_id" TEXT NOT NULL,
    "access_token" TEXT,
    "refresh_token" TEXT,
    "access_token_expires_at" TIMESTAMPTZ,
    "scope" TEXT,
    "id_token" TEXT,
    "password" TEXT,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "accounts_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "accounts_provider_id_account_id_key" ON "accounts"("provider_id", "account_id");
CREATE INDEX "accounts_user_id_idx" ON "accounts"("user_id");

ALTER TABLE "accounts" ADD CONSTRAINT "accounts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create sessions table
CREATE TABLE "sessions" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "sessions_token_key" ON "sessions"("token");
CREATE INDEX "sessions_user_id_idx" ON "sessions"("user_id");
CREATE INDEX "sessions_token_idx" ON "sessions"("token");

ALTER TABLE "sessions" ADD CONSTRAINT "sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create verifications table
CREATE TABLE "verifications" (
    "id" TEXT NOT NULL,
    "identifier" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "verifications_pkey" PRIMARY KEY ("id")
);

-- ═══════════════════════════════════════════════════════════════════
-- PHASE 5: Backfill Better Auth accounts for existing users
-- ═══════════════════════════════════════════════════════════════════

-- Create credential accounts for all existing users with passwords
INSERT INTO "accounts" ("id", "user_id", "account_id", "provider_id", "password", "createdAt", "updatedAt")
SELECT
    gen_random_uuid(),
    id,
    id,
    'credential',
    password,
    "createdAt",
    NOW()
FROM "users"
WHERE password IS NOT NULL;
