import { Suspense } from "react";
import NewAgentPageClient from "@/components/agents/new-agent-page-client";

export default function NewAgentPage() {
  return (
    <Suspense>
      <NewAgentPageClient />
    </Suspense>
  );
}
