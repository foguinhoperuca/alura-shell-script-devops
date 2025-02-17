import { Injectable, PipeTransform } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';

@Injectable()
export class PipeHashing implements PipeTransform {
  constructor(private configService: ConfigService) {}

  async transform(password: string) {
    const salt = this.configService.get<string>('SAL_SENHA');

    const hashedPass = await bcrypt.hash(password, salt!);

    return hashedPass;
  }
}
