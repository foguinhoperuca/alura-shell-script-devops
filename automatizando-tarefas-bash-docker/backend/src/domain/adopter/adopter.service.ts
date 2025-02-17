import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';

import { AdopterListDTO } from './dto/ListAdopter.dto';
import { AdopterEntity } from './adopter.entity';
import { Repository } from 'typeorm';
import { UpdateAdopterDTO } from './dto/UpdateAdopter.dto';
import { CreateAdopterDTO } from './dto/CreateAdopter.dto';

@Injectable()
export class AdopterService {
  constructor(
    @InjectRepository(AdopterEntity)
    private readonly adopterRepository: Repository<AdopterEntity>,
  ) {}

  async createAdopter(adopterData: CreateAdopterDTO) {
    const adopterEntity = new AdopterEntity();

    Object.assign(adopterEntity, adopterData as AdopterEntity);

    return this.adopterRepository.save(adopterEntity);
  }

  async adoptersList() {
    const adoptersSaved = await this.adopterRepository.find();
    const adoptersList = adoptersSaved.map(
      (usuario) => new AdopterListDTO(usuario.id, usuario.nome),
    );
    return adoptersList;
  }

  async findByEmail(email: string) {
    const checkEmail = await this.adopterRepository.findOne({
      where: { email },
    });

    if (checkEmail === null)
      throw new NotFoundException('O email não foi encontrado.');

    return checkEmail;
  }

  async findById(id: string) {
    const adopterId = await this.adopterRepository.findOneBy({
      id,
    });

    if (adopterId === null)
      throw new NotFoundException('O id não foi encontrado.');

    return adopterId;
  }

  async updateAdopter(id: string, newData: UpdateAdopterDTO) {
    const adopter = await this.adopterRepository.findOneBy({ id });

    if (adopter === null)
      throw new NotFoundException('O usuário não foi encontrado.');

    Object.assign(adopter, newData as AdopterEntity);

    return this.adopterRepository.save(adopter);
  }

  async deleteAdopter(id: string) {
    const adopter = await this.adopterRepository.findOneBy({ id });

    if (!adopter) {
      throw new NotFoundException('O usuário não foi encontrado');
    }

    await this.adopterRepository.delete(adopter.id);

    return adopter;
  }
}
