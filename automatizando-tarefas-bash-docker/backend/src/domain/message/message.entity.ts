import {
  Entity,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  PrimaryGeneratedColumn,
  ManyToOne,
} from 'typeorm';
import { Exclude } from 'class-transformer';
import { AdopterEntity } from '../adopter/adopter.entity';

@Entity({ name: 'messages' })
export class MessageEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'nome', length: 100, nullable: false })
  name: string;

  @Column({ name: 'telefone', length: 15, nullable: false })
  phone: string;

  @Column({ name: 'email', length: 70, nullable: true })
  email: string;

  @Column({ name: 'nome_animal', length: 100, nullable: false })
  petName: string;

  @Column({ name: 'mensagem', nullable: false })
  msg: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: string;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: string;

  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: string;

  @ManyToOne(() => AdopterEntity, (adopter) => adopter.msg)
  adopter: AdopterEntity;
}
