import { Module } from '@nestjs/common';

import { TypeOrmModule } from '@nestjs/typeorm';

import { MessageController } from './message.controller';
import { AdopterEntity } from '../adopter/adopter.entity';
import { MessageEntity } from './message.entity';
import { MessageService } from './message.service';

@Module({
  imports: [TypeOrmModule.forFeature([MessageEntity, AdopterEntity])],
  controllers: [MessageController],
  providers: [MessageService],
})
export class MessageModule {}
