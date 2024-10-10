#!/bin/bash

echo "Please first run the igaming_platform_db_init.sh script which will make executable all the scripts used here."

# step_1: start mysql server with docker compose
echo "__________STEP_1__________"
./start_mysql_server.sh

# step_2: get players ranking
echo "__________STEP_2__________"
if [ ! -f db_config.conf ]; then
  echo "Database configuration not found in script folder. Make sure db is init, or db_config.conf exists in scripts folder."
  exit 1
fi
source db_config.conf

# ranking query
RANKING_QUERY="
-- Ranking players based on account balance
SELECT 
    player_id, 
    player_name, 
    account_balance,
    RANK() OVER (ORDER BY account_balance DESC) AS player_rank,
    ROW_NUMBER() OVER (ORDER BY account_balance DESC) AS player_row_number,
    DENSE_RANK() OVER (ORDER BY account_balance DESC) AS player_dense_rank
FROM players;
"

MYSQL_CONTAINER_NAME=$(docker compose ps -q mysql)
echo "Executing ranking query..."
docker exec -i $MYSQL_CONTAINER_NAME mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D $DB_NAME -e "$RANKING_QUERY " --table

# step_3: after init db, close mysql server
echo "__________STEP_3__________"
./close_mysql_server.sh
