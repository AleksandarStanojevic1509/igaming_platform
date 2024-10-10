import * as dotenv from "dotenv";
import { getFromEnv } from "./common/helpers/env-getter";
dotenv.config();

export const CONFIG = {
  db: {
    host: getFromEnv("MYSQL_HOST", "localhost"),
    user: getFromEnv("MYSQL_USER", "igp-user"),
    password: getFromEnv("MYSQL_PASSWORD", "igp-pass"),
    name: getFromEnv("MYSQL_DATABASE", "igaming_platform"),
    port: parseInt(getFromEnv("MYSQL_PORT", "3306"), 10),
  },
  server: {
    port: getFromEnv("PORT", "3000"),
    nodeEnv: getFromEnv("NODE_ENV"),
  },
};
