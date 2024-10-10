#!/bin/bash

# echo "Removing config from local..."
# rm db_config.conf

# stop and remove mysql container
echo "Stopping the MySQL container..."
docker compose stop mysql

echo "Removing the MySQL container..."
docker compose rm -f mysql

echo "MySQL container has been stopped and removed!"
