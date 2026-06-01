import { Suspense } from "react";
import AgentsPageClient from "@/components/agents/agents-page-client";

export default function AgentsPage() {
  return (
    <Suspense>
      <AgentsPageClient />
    </Suspense>
  );
}
