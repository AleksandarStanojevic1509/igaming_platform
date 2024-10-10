import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Unique,
  Check,
  OneToMany,
} from "typeorm";
import { PlayerTournament } from "./player_tournament.entity";

@Entity("players")
@Unique(["player_email"])
@Check('"account_balance" >= 0')
export class Player {
  @PrimaryGeneratedColumn()
  player_id: number;

  @Column({ type: "varchar", length: 255 })
  player_name: string;

  @Column({ type: "varchar", length: 255 })
  player_email: string;

  @Column({ type: "decimal", precision: 10, scale: 2, default: 0.0 })
  account_balance: number;

  @OneToMany(
    () => PlayerTournament,
    (playerTournament) => playerTournament.player
  )
  playerTournaments: PlayerTournament[];
}
