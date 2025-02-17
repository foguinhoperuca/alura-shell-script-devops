import { Type } from 'class-transformer';
import {
  ArrayMinSize,
  IsArray,
  IsEmail,
  IsInt,
  IsNotEmpty,
  IsUUID,
  Min,
  ValidateNested,
} from 'class-validator';

export class CreateMessageDTO {
  @IsNotEmpty({ message: 'O nome não pode ser vazio' })
  name: string;

  @IsNotEmpty({ message: 'O telefone não pode ser vazio' })
  phone: string;

  @IsNotEmpty({ message: 'Informe o nome do Pet' })
  petName: string;

  @IsNotEmpty({ message: 'A mensagem não pode estar vazia' })
  msg: string;
}
