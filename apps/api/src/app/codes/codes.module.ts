import { Module } from "@nestjs/common";
import { CodesService } from "./codes.service";
import { CombinedAuthGuard } from "../guards/combined-auth.guard";
import { CodesController, AdminCodesController } from "./codes.controller";

@Module({
  controllers: [CodesController, AdminCodesController],
  providers: [CodesService, CombinedAuthGuard],
  exports: [CodesService],
})
export class CodesModule {}
