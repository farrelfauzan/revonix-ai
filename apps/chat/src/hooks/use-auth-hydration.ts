"use client";

import { useEffect, useRef } from "react";
import { useQueryClient } from "@tanstack/react-query";
import { useAuthStore } from "@/lib/stores";
import { apiClient } from "@/lib/api-client";
import { authClient } from "@/lib/auth-client";

/**
 * On mount, verify auth state:
 * 1. If JWT exists, validate via /auth/me (legacy flow)
 * 2. Otherwise, check for a Better Auth session (cookie-based SSO)
 * If valid, refresh email + balance. If invalid, clear auth state.
 * Also invalidates portal queries so tier is re-evaluated.
 */
export function useAuthHydration() {
  const { jwt, sessionAuth, setAuth, setSessionAuth, logout } = useAuthStore();
  const queryClient = useQueryClient();
  const hasRun = useRef(false);

  useEffect(() => {
    if (hasRun.current) return;
    hasRun.current = true;

    const invalidatePortal = () => {
      queryClient.invalidateQueries({ queryKey: ["portal-usage"] });
      queryClient.invalidateQueries({ queryKey: ["portal-models"] });
    };

    // If we have a JWT, validate it (legacy email/password flow)
    if (jwt) {
      apiClient
        .get<{ id: string; email: string; balance: number }>("/auth/me")
        .then((user) => {
          setAuth(jwt, user.email, Number(user.balance));
          invalidatePortal();
        })
        .catch(() => {
          logout();
          invalidatePortal();
        });
      return;
    }

    // No JWT — check for Better Auth session (social login / SSO)
    authClient
      .getSession()
      .then((res) => {
        if (res.data?.user) {
          const user = res.data.user as any;
          setSessionAuth(
            user.email,
            Number(user.balance ?? 0),
            user.name ?? null,
            user.image ?? user.avatar ?? null,
          );
          invalidatePortal();
        }
      })
      .catch(() => {
        // No active session — stay logged out
      });
  }, [jwt, sessionAuth, setAuth, setSessionAuth, logout, queryClient]);
}
