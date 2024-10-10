import { DataSource } from "typeorm";
import * as dotenv from "dotenv";
import { getFromEnv } from "./src/common/helpers/env-getter";

dotenv.config();

export default new DataSource({
  type: "mysql",
  host: getFromEnv("MYSQL_HOST", "localhost"),
  port: parseInt(getFromEnv("MYSQL_PORT", "3306"), 10),
  username: getFromEnv("MYSQL_USER", "igp-user"),
  password: getFromEnv("MYSQL_PASSWORD", "igp-pass"),
  database: getFromEnv("MYSQL_DATABASE", "igaming_platform"),
  entities: [__dirname + "/src/common/db/entities/index.ts"],
  migrations: [__dirname + "/src/common/db/migrations/*.{js,ts}"],
  synchronize: false,
  migrationsTableName: "migrations",
});
