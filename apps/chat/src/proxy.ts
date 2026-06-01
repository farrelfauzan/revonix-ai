import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

/**
 * Middleware to protect authenticated routes.
 * Checks for Better Auth session cookie or JWT cookie.
 * Redirects to /login if neither is present.
 */
export function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Check for authentication tokens
  const sessionToken = request.cookies.get("better-auth.session_token")?.value;
  console.log("Session token:", sessionToken);
  const jwt = request.cookies.get("jwt")?.value;

  const isAuthenticated = !!sessionToken || !!jwt;
  console.log("Is authenticated:", isAuthenticated);

  if (!isAuthenticated) {
    const loginUrl = new URL("/login", request.url);
    loginUrl.searchParams.set("redirect", pathname);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/agents/:path*", "/top-up/:path*"],
};
