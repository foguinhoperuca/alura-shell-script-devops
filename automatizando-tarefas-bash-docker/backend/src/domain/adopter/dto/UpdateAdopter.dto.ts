import {
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  MinLength,
  isString,
} from 'class-validator';

export class UpdateAdopterDTO {
  @IsOptional()
  @IsString()
  nome?: string;

  @IsOptional()
  telefone: string;

  @IsOptional()
  cidade: string;

  @IsOptional()
  sobre: string;

  @IsOptional()
  fotoPerfil: string;
}
