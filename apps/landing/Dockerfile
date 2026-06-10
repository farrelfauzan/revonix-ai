# Build context: monorepo root
# Usage: docker build -f apps/landing/Dockerfile .

# ─── Stage 1: Install dependencies ───
FROM mirror.gcr.io/library/node:22-alpine AS deps
WORKDIR /app

COPY package.json ./
COPY apps/landing/package.json ./apps/landing/
COPY prisma/schema.prisma ./prisma/schema.prisma
COPY prisma.config.ts ./prisma.config.ts

RUN npm install --ignore-scripts --legacy-peer-deps

# ─── Stage 2: Build ───
FROM deps AS builder

COPY . .
COPY --from=deps /app/node_modules ./node_modules

ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

RUN cd apps/landing && npx next build

# ─── Stage 3: Production (Hardened) ───
FROM mirror.gcr.io/library/node:22-alpine

RUN apk add --no-cache dumb-init

WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 --ingroup nodejs nextjs

COPY --from=builder --chown=nextjs:nodejs /app/apps/landing/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/landing/.next/static ./apps/landing/.next/static
COPY --from=builder --chown=nextjs:nodejs /app/apps/landing/public ./apps/landing/public

USER nextjs

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3001/ || exit 1

EXPOSE 3001
ENV PORT=3001
ENV HOSTNAME="0.0.0.0"

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "apps/landing/server.js"]
