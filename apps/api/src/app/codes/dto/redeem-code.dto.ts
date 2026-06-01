import { z } from "zod";

export const RedeemCodeDto = z.object({
  code: z
    .string()
    .min(1)
    .max(50)
    .transform((v) => v.trim().toUpperCase()),
});
export type RedeemCodeDto = z.infer<typeof RedeemCodeDto>;

export const CreateCodeDto = z.object({
  code: z
    .string()
    .min(4)
    .max(50)
    .transform((v) => v.trim().toUpperCase())
    .optional(),
  type: z.enum(["topup", "subscription", "both"]),
  creditAmount: z.number().positive().optional(),
  planId: z.string().uuid().optional(),
  durationDays: z.number().int().positive().optional(),
  maxRedemptions: z.number().int().positive().default(1),
});
export type CreateCodeDto = z.infer<typeof CreateCodeDto>;

export const UpdateCodeDto = z.object({
  isActive: z.boolean().optional(),
  maxRedemptions: z.number().int().positive().optional(),
});
export type UpdateCodeDto = z.infer<typeof UpdateCodeDto>;
