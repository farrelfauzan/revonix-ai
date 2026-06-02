import { createAuthClient } from "better-auth/react";

// Better Auth lives at /api/auth/better/* (version-neutral, outside /api/v1/).
// Strip any /api/v1 suffix from the API URL to get the base origin.
const rawUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000";
const baseURL = rawUrl.replace(/\/api\/v1\/?$/, "");

export const authClient = createAuthClient({
  baseURL,
  basePath: "/api/auth/better",
  fetchOptions: {
    credentials: "include",
  },
});

export const { signIn, signUp, signOut, useSession } = authClient;
