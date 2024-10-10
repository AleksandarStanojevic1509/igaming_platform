import { DataSource } from "typeorm";
import { mysqlConnection } from "../../common/dic";

export class TournamentRepository {
  private dataSource: DataSource;
  constructor() {
    this.dataSource = mysqlConnection.getDataSource();
  }

  public async distributePrizesWithStoredProcedure(
    tournamentId: string
  ): Promise<any> {
    try {
      const result = await this.dataSource.query("CALL sp_distribute_prizes(?)", [
        tournamentId,
      ]);
      return result;
    } catch (error) {
      console.error("Error in prize distribution:", error);
      throw new Error(`Error in prize distribution: ${(error as Error).message} `);
    }
  }
}
