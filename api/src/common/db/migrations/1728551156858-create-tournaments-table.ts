import { MigrationInterface, QueryRunner, Table } from "typeorm";

export class CreateTournamentsTable1728551156858 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: "tournaments",
        columns: [
          {
            name: "tournament_id",
            type: "int",
            isPrimary: true,
            isGenerated: true,
            generationStrategy: "increment",
          },
          {
            name: "tournament_name",
            type: "varchar",
            length: "255",
            isNullable: false,
          },
          {
            name: "year",
            type: "int",
            isNullable: false,
          },
          {
            name: "prize_pool",
            type: "decimal",
            precision: 10,
            scale: 2,
            default: 0.0,
          },
          {
            name: "start_date",
            type: "datetime",
            isNullable: false,
          },
          {
            name: "end_date",
            type: "datetime",
            isNullable: false,
          },
          {
            name: "prizes_distributed",
            type: "boolean",
            default: false,
          },
        ],
        uniques: [
          {
            name: "UNIQUE_tournament_name_year",
            columnNames: ["tournament_name", "year"],
          },
        ],
      }),
      true
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable("tournaments");
  }
}
