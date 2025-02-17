import { Injectable, UnauthorizedException } from '@nestjs/common';

import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { AdopterService } from '../adopter/adopter.service';

export interface UserPayload {
  sub: string;
  adopterName: string;
}

@Injectable()
export class AuthenticationService {
  constructor(
    private adopterService: AdopterService,
    private jwtService: JwtService,
  ) {}

  async login(email: string, inputPass: string) {
    const adopter = await this.adopterService.findByEmail(email);

    const authenticatedAdopter = await bcrypt.compare(
      inputPass,
      adopter.password,
    );

    if (!authenticatedAdopter) {
      throw new UnauthorizedException('O email ou a senha está incorreto.');
    }

    const payload: UserPayload = {
      sub: adopter.id, // subject = sujeito
      adopterName: adopter.nome,
    };

    return {
      token: await this.jwtService.signAsync(payload),
    };
  }
}
