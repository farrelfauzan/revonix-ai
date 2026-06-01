function normalizeApiUrl(rawUrl: string | undefined): string {
  const fallback = "http://localhost:3000/api/v1";
  if (!rawUrl) return fallback;

  try {
    const parsed = new URL(rawUrl);
    const pathname = parsed.pathname.replace(/\/+$/, "");

    if (!pathname || pathname === "") {
      parsed.pathname = "/api/v1";
      return parsed.toString().replace(/\/$/, "");
    }

    if (pathname === "/api") {
      parsed.pathname = "/api/v1";
      return parsed.toString().replace(/\/$/, "");
    }

    return parsed.toString().replace(/\/$/, "");
  } catch {
    return rawUrl;
  }
}

export const config = {
  apiUrl: normalizeApiUrl(process.env.NEXT_PUBLIC_API_URL),
  apiKey: process.env.NEXT_PUBLIC_API_KEY || "",
  cdnUrl:
    process.env.NEXT_PUBLIC_S3_CDN_URL ||
    "https://d3s3b8zw1epdnj.cloudfront.net",
};
