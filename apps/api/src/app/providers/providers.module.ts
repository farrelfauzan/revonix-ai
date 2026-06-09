import { Module } from "@nestjs/common";
import { OpenRouterAdapter } from "./openrouter.adapter";
import { ProviderRouter } from "./provider-router";

@Module({
  providers: [OpenRouterAdapter, ProviderRouter],
  exports: [ProviderRouter],
})
export class ProvidersModule {}
