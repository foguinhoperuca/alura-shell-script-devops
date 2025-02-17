import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Request } from 'express';

import { JwtService } from '@nestjs/jwt';
import { UserPayload } from './authentication.service';

export interface AdopterReq extends Request {
  adopter: UserPayload;
}

@Injectable()
export class AuthenticationGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}
  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest<AdopterReq>();
    const token = this.takeHeaderToken(req);
    if (!token) {
      throw new UnauthorizedException('Erro de autenticação');
    }

    try {
      const payload: UserPayload = await this.jwtService.verifyAsync(token);
      req.adopter = payload;
    } catch (error) {
      console.error(error);
      throw new UnauthorizedException('JWT inválido');
    }
    return true;
  }
  private takeHeaderToken(req: Request): string | undefined {
    //formato do cabeçalho authorizathon: "Bearer <valor_do_jwt>" -> protocolo HTTP
    const [type, token] = req.headers.authorization?.split(' ') ?? [];
    return type === 'Bearer' ? token : undefined;
  }
}
