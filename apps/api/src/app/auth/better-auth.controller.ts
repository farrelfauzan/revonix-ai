import { Controller, All, Req, Res, VERSION_NEUTRAL } from "@nestjs/common";
import { auth } from "../../lib/auth";

/**
 * Forwards all /api/auth/better/* requests to Better Auth handler.
 * Version-neutral so it lives outside the /api/v1/ prefix.
 */
@Controller({ path: "auth/better", version: VERSION_NEUTRAL })
export class BetterAuthController {
  @All("*")
  async handleAuth(@Req() req: any, @Res() res: any) {
    // Convert Fastify request to a Web Request for Better Auth
    const url = `${req.protocol}://${req.hostname}${req.url}`;
    const headers = new Headers();
    for (const [key, value] of Object.entries(req.headers)) {
      if (value) {
        headers.set(
          key,
          Array.isArray(value) ? value.join(", ") : String(value),
        );
      }
    }

    const webRequest = new Request(url, {
      method: req.method,
      headers,
      body:
        req.method !== "GET" && req.method !== "HEAD"
          ? JSON.stringify(req.body)
          : undefined,
    });

    const response = await auth.handler(webRequest);

    // Convert Web Response back to Fastify response
    res.status(response.status);
    response.headers.forEach((value: string, key: string) => {
      res.header(key, value);
    });

    const body = await response.text();
    res.send(body);
  }
}
