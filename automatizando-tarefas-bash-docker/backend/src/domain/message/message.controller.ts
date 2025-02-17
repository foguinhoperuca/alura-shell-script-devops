import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Req,
} from '@nestjs/common';

import {
  AuthenticationGuard,
  AdopterReq,
} from '../authentication/authentication.guard';
import { CreateMessageDTO } from './dto/CreateMessage.dto';
import { MessageService } from './message.service';

@UseGuards(AuthenticationGuard)
@Controller('mensagem')
export class MessageController {
  constructor(private readonly messageService: MessageService) {}

  @Post()
  async createMessage(
    @Req() req: AdopterReq,
    @Body() messageData: CreateMessageDTO,
  ) {
    const adopterId = req.adopter.sub;
    const mensagemCriada = await this.messageService.postMessage(
      adopterId,
      messageData,
    );

    return {
      mensagem: 'Mensagem enviada com sucesso',
      mensagemCriada,
    };
  }

  @Get('/:id')
  async GetAdoptersMessages(@Req() req: AdopterReq) {
    const adopterId = req.adopter.sub;
    const msg = await this.messageService.getAdoptersMessage(adopterId);

    return {
      mensagem: 'Mensagens resgatadas com sucesso.',
      msg,
    };
  }
}
