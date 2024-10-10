import { Router, Request, Response } from "express";
import { PlayerService } from "./player.service";

export class PlayerController {
  public router: Router;

  constructor(private playerService: PlayerService) {
    this.router = Router();
    this.setRoutes();
  }

  private setRoutes() {
    this.router.get("/ranking", this.getRanking.bind(this));
  }

  private async getRanking(req: Request, res: Response) {
    try {
      const ranking = await this.playerService.getRanking();
      res.json({ ranking, success: true });
    } catch (error) {
      res
        .status(400)
        .json({ message: (error as Error).message, success: false });
    }
  }
}
