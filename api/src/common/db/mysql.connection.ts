import { DataSource, DataSourceOptions } from "typeorm";
import { CONFIG } from "../../config";
import { IMySqlConnection } from "./connection-mysql.interface";

export class MySqlConnection implements IMySqlConnection {
  private static instance: MySqlConnection;
  private dataSource: DataSource;

  private constructor() {
    const options: DataSourceOptions = this.getConnectionOptions();
    this.dataSource = new DataSource(options);
  }

  public static getInstance(): MySqlConnection {
    if (!MySqlConnection.instance) {
      MySqlConnection.instance = new MySqlConnection();
    }
    return MySqlConnection.instance;
  }

  public async connect(): Promise<void> {
    try {
      if (!this.dataSource.isInitialized) {
        await this.dataSource.initialize();
        console.log("MySQL connection established.");
      } else {
        console.log("MySQL is already connected.");
      }
    } catch (error) {
      console.error("Error connecting to MySQL:", error);
      throw error;
    }
  }

  public async disconnect(): Promise<void> {
    try {
      if (this.dataSource.isInitialized) {
        await this.dataSource.destroy();
        console.log("MySQL connection closed.");
      } else {
        console.log("MySQL is not connected.");
      }
    } catch (error) {
      console.error("Error disconnecting from MySQL:", error);
      throw error;
    }
  }

  public getDataSource(): DataSource {
    return this.dataSource;
  }

  public getConnectionOptions(): DataSourceOptions {
    return {
      type: "mysql", // Specify the database type
      host: CONFIG.db.host, // Use your config values
      port: CONFIG.db.port || 3306, // Default MySQL port
      username: CONFIG.db.user,
      password: CONFIG.db.password,
      database: CONFIG.db.name,
      synchronize: true, // Set to true only in development
      logging: false, // Enable logging for debugging
      entities: [__dirname + "/../**/*.entity{.ts,.js}"], // Specify the path to your entities
    }
  }
}
