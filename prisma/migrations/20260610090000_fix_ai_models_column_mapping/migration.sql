DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'ai_models'
      AND column_name = 'providerId'
  ) AND NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'ai_models'
      AND column_name = 'provider_id'
  ) THEN
    ALTER TABLE "ai_models" RENAME COLUMN "providerId" TO "provider_id";
  END IF;

  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'ai_models'
      AND column_name = 'inputPrice'
  ) AND NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'ai_models'
      AND column_name = 'input_price'
  ) THEN
    ALTER TABLE "ai_models" RENAME COLUMN "inputPrice" TO "input_price";
  END IF;

  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'ai_models'
      AND column_name = 'outputPrice'
  ) AND NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'ai_models'
      AND column_name = 'output_price'
  ) THEN
    ALTER TABLE "ai_models" RENAME COLUMN "outputPrice" TO "output_price";
  END IF;

  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'ai_models'
      AND column_name = 'maxTokens'
  ) AND NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'ai_models'
      AND column_name = 'max_tokens'
  ) THEN
    ALTER TABLE "ai_models" RENAME COLUMN "maxTokens" TO "max_tokens";
  END IF;
END
$$;

ALTER TABLE "ai_models"
  ADD COLUMN IF NOT EXISTS "max_output_tokens" INTEGER,
  ADD COLUMN IF NOT EXISTS "tier" TEXT NOT NULL DEFAULT 'standard',
  ADD COLUMN IF NOT EXISTS "credit_multiplier" DECIMAL(6,2) NOT NULL DEFAULT 1.0,
  ADD COLUMN IF NOT EXISTS "plan_required" TEXT NOT NULL DEFAULT 'free';

CREATE INDEX IF NOT EXISTS "ai_models_tier_idx" ON "ai_models"("tier");
CREATE INDEX IF NOT EXISTS "ai_models_active_tier_idx" ON "ai_models"("active", "tier");
