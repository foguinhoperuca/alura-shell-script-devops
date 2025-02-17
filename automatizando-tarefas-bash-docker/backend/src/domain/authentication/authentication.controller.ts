import { Controller, Post, Body } from '@nestjs/common';
import { AuthenticationService } from './authentication.service';

import { AuthenticDTO } from './dto/authentic.dto';

@Controller('/adotante')
export class AuthenticationController {
  constructor(private readonly authenticationService: AuthenticationService) {}

  @Post('/login')
  login(@Body() { email, password }: AuthenticDTO) {
    return this.authenticationService.login(email, password);
  }
}
