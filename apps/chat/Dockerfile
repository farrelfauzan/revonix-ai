# Build context: monorepo root
# Usage: docker build -f apps/chat/Dockerfile .

# ─── Stage 1: Install dependencies ───
FROM node:22-alpine AS deps
WORKDIR /app

COPY package.json ./
COPY apps/chat/package.json ./apps/chat/

RUN npm install --ignore-scripts --legacy-peer-deps

# ─── Stage 2: Build ───
FROM deps AS builder
WORKDIR /app

COPY . .
COPY --from=deps /app/node_modules ./node_modules

ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

ARG NEXT_PUBLIC_API_URL=https://api.renovix.id
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL

RUN cd apps/chat && npx next build

# ─── Stage 3: Production (Hardened) ───
FROM node:22-alpine

RUN apk add --no-cache dumb-init

WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 --ingroup nodejs nextjs

COPY --from=builder --chown=nextjs:nodejs /app/apps/chat/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/chat/.next/static ./apps/chat/.next/static
COPY --from=builder --chown=nextjs:nodejs /app/apps/chat/public ./apps/chat/public

USER nextjs

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "apps/chat/server.js"]
