import {
    MigrationInterface,
    QueryRunner,
    Table,
  } from "typeorm";
  
  export class CreatePlayerTournamentsTable1728551874608
    implements MigrationInterface
  {
    public async up(queryRunner: QueryRunner): Promise<void> {
      await queryRunner.createTable(
        new Table({
          name: "player_tournaments",
          columns: [
            {
              name: "player_id",
              type: "int",
              isPrimary: true,
            },
            {
              name: "tournament_id",
              type: "int",
              isPrimary: true,
            },
            {
              name: "placement",
              type: "int",
            },
          ],
        })
      );
    }
  
    public async down(queryRunner: QueryRunner): Promise<void> {
      // Drop the player_tournaments table
      await queryRunner.dropTable("player_tournaments");
    }
  }
  