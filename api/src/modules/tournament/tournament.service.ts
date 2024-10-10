import { TournamentRepository } from "./tournament.repository";

export class TournamentService {
    constructor(private tournamentRepository: TournamentRepository) {
    }
    async distributePrizes(tournamentId: string): Promise<any> {
        return this.tournamentRepository.distributePrizesWithStoredProcedure(tournamentId);
    }
}