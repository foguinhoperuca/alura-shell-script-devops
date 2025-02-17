/* eslint-disable @typescript-eslint/no-non-null-assertion */
import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';

import { InjectRepository } from '@nestjs/typeorm';

import { Repository } from 'typeorm';

import { MessageEntity } from './message.entity';
import { AdopterEntity } from '../adopter/adopter.entity';
import { CreateMessageDTO } from './dto/CreateMessage.dto';

@Injectable()
export class MessageService {
  constructor(
    @InjectRepository(MessageEntity)
    private readonly messageRepository: Repository<MessageEntity>,
    @InjectRepository(AdopterEntity)
    private readonly adopterRepository: Repository<AdopterEntity>,
  ) {}

  private async findAdopter(id: string) {
    const adopter = await this.adopterRepository.findOneBy({ id });

    if (adopter === null) {
      throw new NotFoundException('O perfil não foi encontrado');
    }

    return adopter;
  }

  async postMessage(adopterId: string, messageData: CreateMessageDTO) {
    const adopter = await this.findAdopter(adopterId);

    const messageEntity = new MessageEntity();
    messageEntity.adopter = adopter;
    messageEntity.name = messageData.name;
    messageEntity.phone = messageData.phone;
    messageEntity.petName = messageData.name;
    messageEntity.msg = messageData.msg;

    const postedMessage = await this.messageRepository.save(messageEntity);
    return postedMessage;
  }

  async getAdoptersMessage(adopterId: string) {
    await this.findAdopter(adopterId);

    return this.messageRepository.find({
      where: {
        adopter: { id: adopterId },
      },
      relations: {
        adopter: true,
      },
    });
  }
}
