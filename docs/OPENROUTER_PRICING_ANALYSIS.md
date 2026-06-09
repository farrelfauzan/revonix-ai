# OpenRouter Pricing & Profit Analysis

> Exchange rate: **1 USD = Rp 17,800**
> Global markup: **2x** (applied on top of creditMultiplier)
> Formula: `userCost = providerCost × creditMultiplier × globalMarkup(2x)`
> Profit per request: `userCost - providerCost`

---

## 1. Per-Message Cost Estimate

Assumptions for a **typical message**:
- Input: ~800 tokens (user prompt + system prompt + context)
- Output: ~1,500 tokens (assistant response)
- Total: ~2,300 tokens per message

---

## 2. Standard Tier Models

| Model | Provider Cost/1M In | Provider Cost/1M Out | Multiplier | User Pays/1M In | User Pays/1M Out |
|-------|--------------------:|---------------------:|-----------:|----------------:|-----------------:|
| DeepSeek V4 Flash | $0.0983 | $0.1966 | 1x | $0.1966 | $0.3932 |
| Tencent Hy3 | $0.063 | $0.21 | 1x | $0.126 | $0.42 |
| MiMo V2.5 | $0.14 | $0.28 | 1x | $0.28 | $0.56 |
| DeepSeek V3.2 | $0.2288 | $0.3432 | 1x | $0.4576 | $0.6864 |
| Gemini 2.5 Flash Lite | $0.10 | $0.40 | 1x | $0.20 | $0.80 |
| Qwen 3.7 Max | $1.25 | $3.75 | 2x | $5.00 | $15.00 |

### Per-Message Breakdown (Standard Tier)

| Model | Provider Cost/msg | User Pays/msg | Profit/msg | User Pays (IDR) | Profit (IDR) |
|-------|------------------:|--------------:|-----------:|----------------:|-------------:|
| DeepSeek V4 Flash | $0.000374 | $0.000748 | $0.000374 | Rp 13 | Rp 7 |
| Tencent Hy3 | $0.000365 | $0.000731 | $0.000365 | Rp 13 | Rp 7 |
| MiMo V2.5 | $0.000532 | $0.001064 | $0.000532 | Rp 19 | Rp 9 |
| DeepSeek V3.2 | $0.000698 | $0.001396 | $0.000698 | Rp 25 | Rp 12 |
| Gemini 2.5 Flash Lite | $0.000680 | $0.001360 | $0.000680 | Rp 24 | Rp 12 |
| Qwen 3.7 Max | $0.006625 | $0.026500 | $0.019875 | Rp 472 | Rp 354 |

> **Standard tier**: User pays **Rp 13–472 per message**. Cheapest models cost less than a single rupiah in profit but volume makes up for it.

---

## 3. Pro Tier Models

| Model | Provider Cost/1M In | Provider Cost/1M Out | Multiplier | User Pays/1M In | User Pays/1M Out |
|-------|--------------------:|---------------------:|-----------:|----------------:|-----------------:|
| DeepSeek V4 Pro | $0.435 | $0.87 | 3x | $2.61 | $5.22 |
| Gemini 2.5 Flash | $0.30 | $2.50 | 3x | $1.80 | $15.00 |
| Gemini 3 Flash | $0.50 | $3.00 | 4x | $4.00 | $24.00 |
| Gemini 3.5 Flash | $1.50 | $9.00 | 5x | $15.00 | $90.00 |
| xAI Grok 4.3 | $1.25 | $2.50 | 5x | $12.50 | $25.00 |

### Per-Message Breakdown (Pro Tier)

| Model | Provider Cost/msg | User Pays/msg | Profit/msg | User Pays (IDR) | Profit (IDR) |
|-------|------------------:|--------------:|-----------:|----------------:|-------------:|
| DeepSeek V4 Pro | $0.001653 | $0.009918 | $0.008265 | Rp 177 | Rp 147 |
| Gemini 2.5 Flash | $0.003990 | $0.023940 | $0.019950 | Rp 426 | Rp 355 |
| Gemini 3 Flash | $0.004900 | $0.039200 | $0.034300 | Rp 698 | Rp 611 |
| Gemini 3.5 Flash | $0.014700 | $0.147000 | $0.132300 | Rp 2,617 | Rp 2,355 |
| xAI Grok 4.3 | $0.004750 | $0.047500 | $0.042750 | Rp 846 | Rp 761 |

> **Pro tier**: User pays **Rp 177–2,617 per message**. Healthy 83% margin on all Pro models.

---

## 4. Premium Tier Models

| Model | Provider Cost/1M In | Provider Cost/1M Out | Multiplier | User Pays/1M In | User Pays/1M Out |
|-------|--------------------:|---------------------:|-----------:|----------------:|-----------------:|
| Claude Sonnet 4.6 | $3.00 | $15.00 | 10x | $60.00 | $300.00 |
| GPT Chat Latest | $5.00 | $30.00 | 12x | $120.00 | $720.00 |

### Per-Message Breakdown (Premium Tier)

| Model | Provider Cost/msg | User Pays/msg | Profit/msg | User Pays (IDR) | Profit (IDR) |
|-------|------------------:|--------------:|-----------:|----------------:|-------------:|
| Claude Sonnet 4.6 | $0.024900 | $0.498000 | $0.473100 | Rp 8,864 | Rp 8,421 |
| GPT Chat Latest | $0.049000 | $1.128000 | $1.079000 | Rp 20,078 | Rp 19,206 |

> **Premium tier**: User pays **Rp 8,864–20,078 per message**. ~95% margin. These are the big revenue drivers.

---

## 5. Ultra Tier Models

| Model | Provider Cost/1M In | Provider Cost/1M Out | Multiplier | User Pays/1M In | User Pays/1M Out |
|-------|--------------------:|---------------------:|-----------:|----------------:|-----------------:|
| Claude Opus 4.7 | $5.00 | $25.00 | 20x | $200.00 | $1,000.00 |
| Claude Opus 4.8 | $5.00 | $25.00 | 20x | $200.00 | $1,000.00 |
| Claude Opus 4.8 Fast | $10.00 | $50.00 | 25x | $500.00 | $2,500.00 |

### Per-Message Breakdown (Ultra Tier)

| Model | Provider Cost/msg | User Pays/msg | Profit/msg | User Pays (IDR) | Profit (IDR) |
|-------|------------------:|--------------:|-----------:|----------------:|-------------:|
| Claude Opus 4.7 | $0.041500 | $1.660000 | $1.618500 | Rp 29,548 | Rp 28,809 |
| Claude Opus 4.8 | $0.041500 | $1.660000 | $1.618500 | Rp 29,548 | Rp 28,809 |
| Claude Opus 4.8 Fast | $0.083000 | $4.150000 | $4.067000 | Rp 73,870 | Rp 72,393 |

> **Ultra tier**: User pays **Rp 29,548–73,870 per message**. ~97% margin. Enterprise-only, extreme quality.

---

## 6. Monthly Revenue Projections

### Scenario A: 100 Active Users (Early Stage)

Assumptions:
- 70% use Standard (avg 30 msgs/day)
- 20% use Pro (avg 20 msgs/day)
- 8% use Premium (avg 10 msgs/day)
- 2% use Ultra (avg 5 msgs/day)

| Tier | Users | Msgs/day | Avg Revenue/msg | Daily Revenue | Monthly Revenue |
|------|------:|:--------:|----------------:|--------------:|----------------:|
| Standard | 70 | 2,100 | $0.001 | $2.10 | $63 |
| Pro | 20 | 400 | $0.053 | $21.30 | $639 |
| Premium | 8 | 80 | $0.813 | $65.04 | $1,951 |
| Ultra | 2 | 10 | $2.49 | $24.90 | $747 |
| **Total** | **100** | **2,590** | | **$113.34** | **$3,400** |

| Metric | USD | IDR |
|--------|----:|----:|
| Monthly Revenue | $3,400 | Rp 60,520,000 |
| Monthly Provider Cost | ~$340 | Rp 6,052,000 |
| **Monthly Gross Profit** | **$3,060** | **Rp 54,468,000** |
| Gross Margin | 90% | |

### Scenario B: 1,000 Active Users (Growth Stage)

| Tier | Users | Msgs/day | Daily Revenue | Monthly Revenue |
|------|------:|:--------:|--------------:|----------------:|
| Standard | 700 | 21,000 | $21 | $630 |
| Pro | 200 | 4,000 | $213 | $6,390 |
| Premium | 80 | 800 | $650 | $19,510 |
| Ultra | 20 | 100 | $249 | $7,470 |
| **Total** | **1,000** | **25,900** | **$1,133** | **$34,000** |

| Metric | USD | IDR |
|--------|----:|----:|
| Monthly Revenue | $34,000 | Rp 605,200,000 |
| Monthly Provider Cost | ~$3,400 | Rp 60,520,000 |
| **Monthly Gross Profit** | **$30,600** | **Rp 544,680,000** |
| Gross Margin | 90% | |

### Scenario C: 10,000 Active Users (Scale)

| Metric | USD | IDR |
|--------|----:|----:|
| Monthly Revenue | $340,000 | Rp 6,052,000,000 |
| Monthly Provider Cost | ~$34,000 | Rp 605,200,000 |
| **Monthly Gross Profit** | **$306,000** | **Rp 5,446,800,000** |

---

## 7. Top-Up Package Pricing (Chat Portal)

Suggested credit packages for Indonesian market:

| Package | Credits (USD) | Price (IDR) | Bonus | Effective Rate |
|---------|:-------------:|------------:|:-----:|:--------------:|
| Starter | $1 | Rp 19,900 | — | Rp 19,900/$ |
| Basic | $5 | Rp 89,000 | — | Rp 17,800/$ |
| Popular | $10 | Rp 169,000 | +5% | Rp 16,095/$ |
| Pro | $25 | Rp 399,000 | +10% | Rp 14,509/$ |
| Business | $50 | Rp 749,000 | +15% | Rp 13,026/$ |
| Enterprise | $100 | Rp 1,399,000 | +20% | Rp 11,658/$ |

### What Users Get Per Package (Messages)

| Package | Standard msgs | Pro msgs | Premium msgs | Ultra msgs |
|---------|:-------------:|:--------:|:------------:|:----------:|
| $1 | ~1,337 | ~19 | ~2 | ~0.6 |
| $5 | ~6,684 | ~94 | ~10 | ~3 |
| $10 | ~14,034 | ~198 | ~21 | ~6 |
| $25 | ~36,839 | ~519 | ~55 | ~17 |
| $50 | ~77,319 | ~1,090 | ~116 | ~35 |
| $100 | ~162,370 | ~2,288 | ~243 | ~73 |

> Based on average cost: Standard=$0.000748/msg, Pro=$0.053/msg, Premium=$0.498/msg, Ultra=$1.66/msg

---

## 8. AI Agent Subscription Pricing

| Plan | Price (USD/mo) | Price (IDR/mo) | Agent Executions | Est. Provider Cost | Gross Profit |
|------|:--------------:|:--------------:|:----------------:|-------------------:|-------------:|
| Free | $0 | Rp 0 | 50 (Standard only) | $0.02 | -$0.02 |
| Starter | $9 | Rp 159,000 | 500 (Std + Pro) | $2.50 | $6.50 |
| Pro | $29 | Rp 499,000 | 2,000 (All tiers) | $15.00 | $14.00 |
| Enterprise | $99 | Rp 1,699,000 | Unlimited | ~$80.00 | $19.00+ |

### Agent Execution Cost Breakdown

Assuming agent runs use ~5,000 input + ~3,000 output tokens per execution (more context than chat):

| Model Used | Provider Cost/execution | Included in Plan |
|------------|------------------------:|:----------------:|
| DeepSeek V4 Flash | $0.001 | Free, Starter, Pro, Enterprise |
| Gemini 2.5 Flash | $0.009 | Starter, Pro, Enterprise |
| Gemini 3.5 Flash | $0.035 | Starter, Pro, Enterprise |
| Claude Sonnet 4.6 | $0.060 | Pro, Enterprise |
| Claude Opus 4.7 | $0.100 | Enterprise |

---

## 9. Break-Even Analysis

### Chat Portal (Pay-as-you-go)

| Tier | Provider Cost/msg | Revenue/msg | Profit/msg | Break-even on $100 OpenRouter bill |
|------|------------------:|--------------:|-----------:|:-----------------------------------:|
| Standard | $0.000374 | $0.000748 | $0.000374 | Need ~267,380 msgs |
| Pro | $0.004 | $0.053 | $0.049 | Need ~2,041 msgs |
| Premium | $0.025 | $0.498 | $0.473 | Need ~211 msgs |
| Ultra | $0.042 | $1.660 | $1.618 | Need ~62 msgs |

### AI Agents (Subscription)

| Plan | Monthly Revenue | Max Provider Cost (all executions used) | Min Margin |
|------|----------------:|---------------------------------------:|-----------:|
| Starter ($9) | $9 | $4.50 (500 × $0.009 avg) | 50% |
| Pro ($29) | $29 | $20.00 (2000 × $0.01 avg) | 31% |
| Enterprise ($99) | $99 | ~$80 (heavy premium usage) | 19% |

> Enterprise plan has thinnest margin but highest LTV and lowest churn.

---

## 10. Cost Comparison: Together AI vs OpenRouter

### Standard Models (Apples-to-Apples)

| Model | Together AI Cost | OpenRouter Cost | Difference |
|-------|:----------------:|:---------------:|:----------:|
| DeepSeek V3/V4 class | ~$0.14/M in, $0.28/M out | $0.098/M in, $0.197/M out | OpenRouter ~30% cheaper |
| Qwen 3.x 397B | ~$0.60/M in, $3.60/M out | $1.25/M in, $3.75/M out | Together ~50% cheaper |
| Average OSS model | ~$0.20/M blended | ~$0.15/M blended | OpenRouter ~25% cheaper |

### Premium Models (New Revenue — Not Available on Together)

| Model | OpenRouter Cost | Revenue at Multiplier | Net New Profit |
|-------|:--------------:|:---------------------:|:--------------:|
| Claude Sonnet 4.6 | $0.025/msg | $0.498/msg (10x×2x) | **+$0.473/msg** |
| GPT Chat Latest | $0.049/msg | $1.128/msg (12x×2x) | **+$1.079/msg** |
| Claude Opus 4.7 | $0.042/msg | $1.660/msg (20x×2x) | **+$1.618/msg** |

> **Key insight**: Even if only 10% of messages use premium models, they generate **95%+ of profit**. The migration pays for itself with just a few premium users.

---

## 11. Summary

| Metric | Value (USD) | Value (IDR) |
|--------|:-----------:|:-----------:|
| Cheapest message (Standard) | $0.0007 | Rp 13 |
| Most expensive message (Ultra Fast) | $4.15 | Rp 73,870 |
| Average profit margin (Standard) | 50% | — |
| Average profit margin (Pro) | 83% | — |
| Average profit margin (Premium) | 95% | — |
| Average profit margin (Ultra) | 97% | — |
| Monthly revenue @ 100 users | $3,400 | Rp 60.5 juta |
| Monthly revenue @ 1,000 users | $34,000 | Rp 605 juta |
| Monthly revenue @ 10,000 users | $340,000 | Rp 6.05 miliar |
