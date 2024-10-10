import { MySqlConnection } from "./db/mysql.connection";
import { PlayerController } from "../modules/player/player.controller";
import { PlayerService } from "../modules/player/player.service";
import { PlayerRepository } from "../modules/player/player.repository";
import { TournamentController } from "../modules/tournament/tournament.controller";
import { TournamentService } from "../modules/tournament/tournament.service";
import { TournamentRepository } from "../modules/tournament/tournament.repository";

const mysqlConnection = MySqlConnection.getInstance();

const playerRepository = new PlayerRepository();
const playerService = new PlayerService(playerRepository);
const playerController = new PlayerController(playerService);

const tournamentRepository = new TournamentRepository();
const tournamentService = new TournamentService(tournamentRepository);
const tournamentController = new TournamentController(tournamentService);

export { mysqlConnection, playerController, tournamentController };
