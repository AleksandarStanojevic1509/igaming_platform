import { MigrationInterface, QueryRunner, Table } from "typeorm";

export class CreatePlayersTable1728549404259 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: "players",
        columns: [
          {
            name: "player_id",
            type: "int",
            isPrimary: true,
            isGenerated: true,
            generationStrategy: "increment",
          },
          {
            name: "player_name",
            type: "varchar",
            length: "255",
            isNullable: false,
          },
          {
            name: "player_email",
            type: "varchar",
            length: "255",
            isUnique: true,
            isNullable: false,
          },
          {
            name: "account_balance",
            type: "decimal",
            precision: 10,
            scale: 2,
            default: "0.00",
            isNullable: false,
          },
        ],
      })
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable("players");
  }
}
