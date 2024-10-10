import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Unique,
  OneToMany,
} from "typeorm";
import { PlayerTournament } from "./player_tournament.entity";

@Entity("tournaments")
@Unique(["tournament_name", "year"]) // Unique constraint on tournament_name and year
export class Tournament {
  @PrimaryGeneratedColumn()
  tournament_id: number;

  @Column({ type: "varchar", length: 255 })
  tournament_name: string;

  @Column({ type: "int" })
  year: number;

  @Column({ type: "decimal", precision: 10, scale: 2, default: 0.0 })
  prize_pool: number;

  @Column({ type: "datetime" })
  start_date: Date;

  @Column({ type: "datetime" })
  end_date: Date;

  @Column({ type: "boolean", default: false })
  prizes_distributed: boolean;

  @OneToMany(
    () => PlayerTournament,
    (playerTournament) => playerTournament.player
  )
  playerTournaments: PlayerTournament[];
}
