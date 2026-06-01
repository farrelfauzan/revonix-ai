import {
  Controller,
  Post,
  Get,
  Patch,
  Body,
  Param,
  Query,
  Req,
  UseGuards,
  BadRequestException,
} from "@nestjs/common";
import { Throttle } from "@nestjs/throttler";
import { CombinedAuthGuard } from "../guards/combined-auth.guard";
import { CodesService } from "./codes.service";
import {
  RedeemCodeDto,
  CreateCodeDto,
  UpdateCodeDto,
} from "./dto/redeem-code.dto";

@Controller("codes")
export class CodesController {
  constructor(private readonly codesService: CodesService) {}

  @Post("redeem")
  @UseGuards(CombinedAuthGuard)
  @Throttle({ default: { ttl: 60000, limit: 5 } })
  async redeemCode(@Req() req: any, @Body() body: unknown) {
    const parsed = RedeemCodeDto.safeParse(body);
    if (!parsed.success) {
      throw new BadRequestException(parsed.error.flatten().fieldErrors);
    }
    return this.codesService.redeemCode(req.user.userId, parsed.data.code);
  }

  @Get("history")
  @UseGuards(CombinedAuthGuard)
  async getHistory(@Req() req: any) {
    return this.codesService.getHistory(req.user.userId);
  }
}

@Controller("admin/codes")
@UseGuards(CombinedAuthGuard)
export class AdminCodesController {
  constructor(private readonly codesService: CodesService) {}

  @Post()
  async createCode(@Req() req: any, @Body() body: unknown) {
    const parsed = CreateCodeDto.safeParse(body);
    if (!parsed.success) {
      throw new BadRequestException(parsed.error.flatten().fieldErrors);
    }
    return this.codesService.createCode(parsed.data, req.user.userId);
  }

  @Get()
  async listCodes(
    @Query("page") page?: string,
    @Query("limit") limit?: string,
  ) {
    return this.codesService.listCodes(
      page ? parseInt(page, 10) : 1,
      limit ? parseInt(limit, 10) : 50,
    );
  }

  @Patch(":id")
  async updateCode(@Param("id") id: string, @Body() body: unknown) {
    const parsed = UpdateCodeDto.safeParse(body);
    if (!parsed.success) {
      throw new BadRequestException(parsed.error.flatten().fieldErrors);
    }
    return this.codesService.updateCode(id, parsed.data);
  }
}
