import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { AdopterEntity } from './adopter.entity';
import { AdopterService } from './adopter.service';
import { IsEmailUniqueValidator } from './validation/is-email-unique.validator';
import { AdopterController } from './adopter.controller';

@Module({
  imports: [TypeOrmModule.forFeature([AdopterEntity])],
  controllers: [AdopterController],
  providers: [AdopterService, IsEmailUniqueValidator],
  exports: [AdopterService],
})
export class AdopterModule {}
