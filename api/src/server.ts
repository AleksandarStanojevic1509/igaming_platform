import { App } from "./app";
import { mysqlConnection } from "./common/dic";
import { InitAppType } from "./common/types";
import { CONFIG } from "./config";
import 'reflect-metadata';

const bootstrap = async () => {
  const initOptions: InitAppType = {
    dbInit: false,
  };

  try {
    const appInstance = new App();

    if (!initOptions.dbInit) {
      await mysqlConnection.connect();
      initOptions.dbInit = true;
    }

    for (const [key, value] of Object.entries(initOptions)) {
      if (!value) {
        console.error(
          `Error bootstrapping application: ${key} initialization failed.`
        );
        process.exit(1);
      }
    }

    const server = appInstance.app.listen(CONFIG.server.port, () => {
      console.log(`Server is running on ${CONFIG.server.port}.`);
    });

    const gracefulShutdown = async () => {
      console.log("Received shutdown signal, closing server gracefully...");
      server.close(async (err) => {
        if (err) {
          console.error("Error closing server:", err);
          return process.exit(1);
        }

        await mysqlConnection.disconnect();

        console.log("Server closed successfully.");
        process.exit(0);
      });
    };

    process.on("SIGINT", gracefulShutdown);
    process.on("SIGTERM", gracefulShutdown);
  } catch (error) {
    console.log("Error bootstrapping application:", error);
    process.exit(1);
  }
};

bootstrap();
