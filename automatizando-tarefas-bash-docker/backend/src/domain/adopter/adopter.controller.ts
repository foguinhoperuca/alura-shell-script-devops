import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Put,
  Req,
} from '@nestjs/common';
import { AdopterService } from './adopter.service';
import { CreateAdopterDTO } from './dto/CreateAdopter.dto';
import { AdopterListDTO } from './dto/ListAdopter.dto';
import { PipeHashing } from 'src/resources/pipes/hashing-pass.pipe';
import { UpdateAdopterDTO } from './dto/UpdateAdopter.dto';
import { AdopterReq } from '../authentication/authentication.guard';

@Controller('adotante')
export class AdopterController {
  constructor(private adopterService: AdopterService) {}

  @Post('/register')
  async createAdopter(
    @Body() { password, ...adopterData }: CreateAdopterDTO,
    @Body('password', PipeHashing) hashedPass: string,
  ) {
    const createdAdopter = await this.adopterService.createAdopter({
      ...adopterData,
      password: hashedPass,
    });
    return {
      message: `Adotante criado com sucesso`,
      adopter: new AdopterListDTO(createdAdopter.id, createdAdopter.nome),
    };
  }

  @Get()
  async adoptersList() {
    const savedAdopters = await this.adopterService.adoptersList();
    return {
      message: `Todos os adotantes`,
      adopters: savedAdopters,
    };
  }

  @Get('perfil/:id')
  async findById(@Param('id') id: string) {
    const perfil = await this.adopterService.findById(id);

    return {
      mensagem: 'Perfil carregado.',
      perfil,
    };
  }

  @Patch('perfil/:id')
  async updateAdopter(
    @Param('id') id: string,
    @Body() newData: UpdateAdopterDTO,
  ) {
    const updatedAdopter = await this.adopterService.updateAdopter(id, newData);
    return {
      message: `Atualização realizada com sucesso`,
      updatedAdopter,
    };
  }

  @Delete(':id')
  async removeAdopter(@Param('id') id: string) {
    const removedAdopter = await this.adopterService.deleteAdopter(id);
    return {
      message: `Perfil removido com sucesso`,
      adopter: removedAdopter,
    };
  }
}
