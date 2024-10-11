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
    DECLARE is_distributed BOOLEAN;

    -- retrieve prize pool and distribution status in one query
    SELECT prize_pool, prizes_distributed INTO total_prize, is_distributed
    FROM tournaments 
    WHERE tournament_id = tournamentId;

    -- check if the tournament exists and if the prizes are already distributed
    IF total_prize IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tournament does not exist or has no prize pool.';
    ELSEIF is_distributed THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Prizes have already been distributed for this tournament.';
    ELSE
        -- update the account balances based on player placement
        UPDATE players p
        JOIN player_tournaments pt ON p.player_id = pt.player_id
        SET p.account_balance = p.account_balance + 
            CASE pt.placement
                WHEN 1 THEN total_prize * 0.50
                WHEN 2 THEN total_prize * 0.30
                WHEN 3 THEN total_prize * 0.20
                ELSE 0
            END
        WHERE pt.tournament_id = tournamentId;

        -- Mark the tournament as having distributed prizes
        UPDATE tournaments
        SET prizes_distributed = TRUE
        WHERE tournament_id = tournamentId;
    END IF;
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
