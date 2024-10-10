#!/bin/bash

# load the configuration
if [ ! -f db_config.conf ]; then
  echo "Database configuration not found. Please run the configuration script first."
  exit 1
fi
source db_config.conf

# SQL script containing the initial database setup create tables and stored procedure
SQL_SCRIPT="
CREATE TABLE IF NOT EXISTS players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(255) NOT NULL,
    player_email VARCHAR(255) UNIQUE NOT NULL,
    account_balance DECIMAL(10, 2) DEFAULT 0.00 CHECK (account_balance >= 0)
);

CREATE TABLE IF NOT EXISTS tournaments (
    tournament_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_name VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    prize_pool DECIMAL(10, 2) NOT NULL CHECK (prize_pool >= 0),
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    prizes_distributed BOOLEAN DEFAULT FALSE,
    UNIQUE (tournament_name, year)
);

CREATE TABLE IF NOT EXISTS player_tournaments (
    player_id INT,
    tournament_id INT,
    placement INT,
    PRIMARY KEY (player_id, tournament_id),
    UNIQUE (tournament_id, placement),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (tournament_id) REFERENCES tournaments(tournament_id)
);

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_distribute_prizes$$
CREATE PROCEDURE sp_distribute_prizes(IN tournamentId INT)
BEGIN
    DECLARE total_prize DECIMAL(10, 2);

    -- don't allow prize distribution if it is already distributed for tournament
    IF (SELECT prizes_distributed FROM tournaments WHERE tournament_id = tournamentId) = TRUE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Prizes have already been distributed for this tournament.';
    END IF;

    -- Get the prize pool for the tournament
    SELECT prize_pool INTO total_prize FROM tournaments WHERE tournament_id = tournamentId;

    -- Distribute prizes based on placement
    UPDATE players
    SET account_balance = account_balance + 
        CASE 
            WHEN (SELECT placement FROM player_tournaments WHERE tournament_id = tournamentId AND player_id = players.player_id) = 1 THEN total_prize * 0.50
            WHEN (SELECT placement FROM player_tournaments WHERE tournament_id = tournamentId AND player_id = players.player_id) = 2 THEN total_prize * 0.30
            WHEN (SELECT placement FROM player_tournaments WHERE tournament_id = tournamentId AND player_id = players.player_id) = 3 THEN total_prize * 0.20
            ELSE 0
        END
    WHERE player_id IN (SELECT player_id FROM player_tournaments WHERE tournament_id = tournamentId);

    -- add flag to indicate that prizes have been distributed
    UPDATE tournaments SET prizes_distributed = TRUE WHERE tournament_id = tournamentId;
END$$

DELIMITER ;

-- trigger to check that the end date is after the start date (my mysql version does not support CHECK constraints for columns)
DELIMITER $$
DROP TRIGGER IF EXISTS check_end_date_before_insert$$
CREATE TRIGGER check_end_date_before_insert
BEFORE INSERT ON tournaments
FOR EACH ROW
BEGIN
  IF NEW.end_date <= NEW.start_date THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'End date must be greater than start date';
  END IF;
END$$

DELIMITER ;

"

# execute the initial SQL script to set up the database and tables
MYSQL_CONTAINER_NAME=$(docker compose ps -q mysql)
docker exec -i $MYSQL_CONTAINER_NAME mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "$SQL_SCRIPT"


if [ $? -eq 0 ]; then
    echo "Database and tables were set up successfully!"
else
    echo "There was an error setting up the database."
fi
