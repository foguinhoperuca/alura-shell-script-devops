import { MigrationInterface, QueryRunner } from "typeorm";

export class CriaTabelas1705990820691 implements MigrationInterface {
    name = 'CriaTabelas1705990820691'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "adopters" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "nome" character varying(100) NOT NULL, "email" character varying(70) NOT NULL, "senha" character varying(255) NOT NULL, "telefone" character varying(15), "cidade" character varying(50), "sobre" character varying, "fotoPerfil" character varying, "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP, CONSTRAINT "PK_a61836ed298b9de340bdd0e294a" PRIMARY KEY ("id"))`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP TABLE "adopters"`);
    }

}
