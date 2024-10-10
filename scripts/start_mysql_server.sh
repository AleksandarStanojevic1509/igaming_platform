#!/bin/bash

# start MySQL server using Docker Compose
echo "Starting MySQL with Docker Compose..."
docker compose up -d mysql

# wait for MySQL container to be ready
echo "Waiting for MySQL to be ready..."
MYSQL_CONTAINER_NAME=$(docker compose ps -q mysql)
until docker exec -i $MYSQL_CONTAINER_NAME mysqladmin ping --silent &> /dev/null; do
  echo "MySQL is unavailable - retrying in 5 seconds..."
  sleep 5
done
echo "MySQL is up and running!"
