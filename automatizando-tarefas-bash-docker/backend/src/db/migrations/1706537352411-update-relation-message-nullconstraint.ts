import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateRelationMessageNullconstraint1706537352411 implements MigrationInterface {
    name = 'UpdateRelationMessageNullconstraint1706537352411'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "messages" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "nome" character varying(100) NOT NULL, "telefone" character varying(15) NOT NULL, "email" character varying(70), "nome_animal" character varying(100) NOT NULL, "mensagem" character varying NOT NULL, "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP, "adopterId" uuid, CONSTRAINT "PK_18325f38ae6de43878487eff986" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "messages" ADD CONSTRAINT "FK_690b827826ba61def3710a382b4" FOREIGN KEY ("adopterId") REFERENCES "adopters"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "messages" DROP CONSTRAINT "FK_690b827826ba61def3710a382b4"`);
        await queryRunner.query(`DROP TABLE "messages"`);
    }

}
