import { Suspense } from "react";
import AcceptInviteClient from "@/components/workspace/accept-invite-client";

export default function AcceptInvitePage() {
  return (
    <Suspense>
      <AcceptInviteClient />
    </Suspense>
  );
}
