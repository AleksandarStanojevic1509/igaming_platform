import { Router, Request, Response } from "express";
import { TournamentService } from "./tournament.service";

export class TournamentController {
  public router: Router;

  constructor(private tournamentService: TournamentService) {
    this.router = Router();
    this.setRoutes();
  }

  private setRoutes() {
    this.router.get("/distribute/:id", this.distributePrizes.bind(this));
  }

  private async distributePrizes(req: Request, res: Response) {
    try {
      const tournamentId = req.params.id;
      if (!tournamentId) {
        throw new Error("Tournament ID is required");
      }
      const distributedPrize = await this.tournamentService.distributePrizes(
        tournamentId
      );

      const message = `${
        distributedPrize.affectedRows > 0
          ? "Prize distributed."
          : `Fail to distribute prize. Possible reason tournament with id: ${tournamentId}`
      }`;
      res.json({ message, success: true });
    } catch (error) {
      res
        .status(400)
        .json({ message: (error as Error).message, success: false });
    }
  }
}
