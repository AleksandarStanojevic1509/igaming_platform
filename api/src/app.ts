import express, { Application, NextFunction, Request, Response } from "express";
import { playerController, tournamentController } from "./common/dic";

export class App {
  public app: Application;

  constructor() {
    this.app = express();
    this.registerMiddlewares();
    this.registerRoutes();
    this.registerErrorHandling(); // Error handling middleware should be registered last
  }

  private registerMiddlewares(): void {
    this.app.use(express.json());
    this.app.use(express.urlencoded({ extended: true }));
  }

  private registerRoutes(): void {
    const routerPrefix = "/api/v1";

    this.app.use(`${routerPrefix}/player`, playerController.router);
    this.app.use(`${routerPrefix}/tournament`, tournamentController.router);

    // health check route
    this.app.get("/health", (req: Request, res: Response) => {
      res.json({ status: "Ok" });
    });

    // 404 route
    this.app.use("/", (req: Request, res: Response) => {
      res.statusCode = 404;
      res.json({ status: "Error", message: "Not Found" });
    });
  }

  private registerErrorHandling(): void {
    this.app.use(
      (err: any, req: Request, res: Response, next: NextFunction): void => {
        console.error("Unhandled error:", err.message);

        if (err.statusCode) {
          res.status(err.statusCode).json({ message: err.message });
        }

        res.status(500).json({
          message: "Internal Server Error",
        });
      }
    );
  }
}
