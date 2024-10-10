import { DataSource, DataSourceOptions } from "typeorm";

export interface IMySqlConnection {
  connect(): Promise<void>;
  disconnect(): Promise<void>;
  getDataSource(): DataSource;
  getConnectionOptions(): DataSourceOptions;
}
