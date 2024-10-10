import { Entity, PrimaryColumn, Column, ManyToOne, JoinColumn } from "typeorm";
import { Player, Tournament } from "./index";

@Entity("player_tournaments")
export class PlayerTournament {
  @PrimaryColumn()
  player_id: number;

  @PrimaryColumn()
  tournament_id: number;

  @Column()
  placement: number;

  @ManyToOne(() => Player, (player) => player.playerTournaments, {
    onDelete: "CASCADE",
  })
  @JoinColumn({ name: "player_id" })
  player: Player;

  @ManyToOne(() => Tournament, (tournament) => tournament.playerTournaments, {
    onDelete: "CASCADE",
  })
  @JoinColumn({ name: "tournament_id" })
  tournament: Tournament;
}
