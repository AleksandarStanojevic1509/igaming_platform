import { DataSource } from "typeorm";
import { mysqlConnection } from "../../common/dic";

export class PlayerRepository {
  private dataSource: DataSource;
  constructor() {
    this.dataSource = mysqlConnection.getDataSource();
  }

  public async getRunkingByWindowFunction() {
    try {
      const result = await this.dataSource.query(
        `SELECT 
            player_id, 
            player_name, 
            account_balance,
            RANK() OVER (ORDER BY account_balance DESC) AS player_rank,
            ROW_NUMBER() OVER (ORDER BY account_balance DESC) AS player_row_number,
            DENSE_RANK() OVER (ORDER BY account_balance DESC) AS player_dense_rank
        FROM players;`
      );
      return result;
    } catch (error) {
      console.error("Error fetching ranking by window function:", error);
      throw new Error("Could not fetch player rankings.");
    }
  }
}
