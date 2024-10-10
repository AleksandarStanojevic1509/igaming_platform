#!/bin/bash

# load the configuration
if [ ! -f db_config.conf ]; then
  echo "Database configuration not found. Please run the configuration script first."
  exit 1
fi
source db_config.conf

# SQL script containing locical to create the migrations table and mark migrations as executed
MIGRATION_SCRIPT="
CREATE TABLE IF NOT EXISTS migrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL
);

INSERT INTO migrations (timestamp, name) VALUES
(1728549404259, 'CreatePlayersTable1728549404259'),
(1728551156858, 'CreateTournamentsTable1728551156858'),
(1728551874608, 'CreatePlayerTournamentsTable1728551874608'),
(1728553297916, 'AddForeignKeyConstraintsToPlayerTournaments1728553297916');

"

# execute the initial SQL script to set up the database and tables
MYSQL_CONTAINER_NAME=$(docker compose ps -q mysql)
docker exec -i $MYSQL_CONTAINER_NAME mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "$MIGRATION_SCRIPT"


if [ $? -eq 0 ]; then
    echo "Migrations table and etries were set up successfully!"
else
    echo "There was an error setting up the database."
fi
