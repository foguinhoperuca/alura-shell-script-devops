import { Injectable, NotFoundException } from '@nestjs/common';
import {
  registerDecorator,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';
import { AdopterService } from '../adopter.service';

@Injectable()
@ValidatorConstraint({ async: true })
export class IsEmailUniqueValidator implements ValidatorConstraintInterface {
  constructor(private adopterService: AdopterService) {}

  async validate(value: any): Promise<boolean> {
    try {
      const adopterEmailExists = await this.adopterService.findByEmail(value);

      return !adopterEmailExists;
    } catch (erro) {
      if (erro instanceof NotFoundException) {
        return true;
      }

      throw erro;
    }
  }
}

export const UniqueEmail = (validationOptions: ValidationOptions) => {
  return (objc: object, property: string) => {
    registerDecorator({
      target: objc.constructor,
      propertyName: property,
      options: validationOptions,
      constraints: [],
      validator: IsEmailUniqueValidator,
    });
  };
};
