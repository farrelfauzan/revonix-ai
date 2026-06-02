# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2026-06-02

### Added

- **API**: NestJS backend with authentication (Better Auth), workspace management, AI agent system
- **Chat**: Next.js chat portal with real-time AI conversations, memory sharing, document generation
- **Dashboard**: Next.js admin dashboard with workspace management, agent configuration, analytics
- **Landing**: Next.js marketing landing page
- **Infrastructure**: Terraform modules for GCP (Cloud Run, Cloud SQL, GCS, VPC, CDN, Secret Manager)
- **CI/CD**: GitHub Actions workflows for test builds (PR/push) and production deploys (release tags)
- **Database**: PostgreSQL 16 with pgvector, Prisma ORM with migrations
- **Security**: Helmet, CORS, rate limiting, Cloud Armor, non-root Docker containers

### Infrastructure

- GCP Cloud Run deployment (asia-southeast2)
- Cloud SQL PostgreSQL 16 with private networking
- Artifact Registry for Docker images
- Cloud CDN with Global Load Balancer
- Secret Manager for sensitive configuration

### CI/CD

- `ci.yml` — Test builds on PR and push to main (path-based change detection)
- `deploy.yml` — Production deploy on release tags (`v*` / `v*-<app>`)

[0.0.1]: https://github.com/farrelfauzan/revonix-ai/releases/tag/v0.0.1
