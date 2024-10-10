import { PlayerRepository } from "./player.repository";

export class PlayerService {

  constructor(private playerRepository: PlayerRepository) {
  }
  
  public async getRanking() {
    return this.playerRepository.getRunkingByWindowFunction();
  }
}