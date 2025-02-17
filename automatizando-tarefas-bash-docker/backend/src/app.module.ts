import { ClassSerializerInterceptor, Module } from '@nestjs/common';
import { AdopterModule } from './domain/adopter/adopter.module';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PostgresConfigService } from './config/postgres.config.service';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { AuthenticationModule } from './domain/authentication/authentication.module';
import { MessageModule } from './domain/message/message.module';

@Module({
  imports: [
    AdopterModule,

    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRootAsync({
      useClass: PostgresConfigService,
      inject: [PostgresConfigService],
    }),
    AuthenticationModule,
    MessageModule,
  ],

  // controllers: [AppController],
  providers: [
    { provide: APP_INTERCEPTOR, useClass: ClassSerializerInterceptor },
  ],
})
export class AppModule {}
