import {
    MigrationInterface,
    QueryRunner,
    TableForeignKey,
    TableIndex, // Import TableIndex instead of TableUnique
  } from "typeorm";
  
  export class AddForeignKeyConstraintsToPlayerTournaments1728553297916
    implements MigrationInterface
  {
    public async up(queryRunner: QueryRunner): Promise<void> {
      // Create foreign key constraints
      await queryRunner.createForeignKey(
        "player_tournaments",
        new TableForeignKey({
          columnNames: ["player_id"],
          referencedTableName: "players",
          referencedColumnNames: ["player_id"],
          onDelete: "CASCADE",
        })
      );
  
      await queryRunner.createForeignKey(
        "player_tournaments",
        new TableForeignKey({
          columnNames: ["tournament_id"],
          referencedTableName: "tournaments",
          referencedColumnNames: ["tournament_id"],
          onDelete: "CASCADE",
        })
      );
  
      // Create unique index on tournament_id and placement
      await queryRunner.createIndex("player_tournaments", new TableIndex({
        name: "UQ_tournament_id_placement", // You can adjust this name as needed
        columnNames: ["tournament_id", "placement"],
        isUnique: true,
      }));
    }
  
    public async down(queryRunner: QueryRunner): Promise<void> {
      // Drop foreign key constraints from player_tournaments
      const playerTournamentTable = await queryRunner.getTable("player_tournaments");
      if (playerTournamentTable) {
        const fk1 = playerTournamentTable.foreignKeys.find(
          (fk) => fk.columnNames.indexOf("player_id") !== -1
        );
        const fk2 = playerTournamentTable.foreignKeys.find(
          (fk) => fk.columnNames.indexOf("tournament_id") !== -1
        );
        if (fk1) await queryRunner.dropForeignKey("player_tournaments", fk1);
        if (fk2) await queryRunner.dropForeignKey("player_tournaments", fk2);
      }
  
      // Drop unique index
      await queryRunner.dropIndex("player_tournaments", "UQ_tournament_id_placement");
    }
  }
  