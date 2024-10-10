#!/bin/bash

# default configuration can be aloso taken from local environment variables
DEFAULT_DB_HOST="mysql" # container name || localhost || IP address
DEFAULT_DB_USER="igp-user"
DEFAULT_DB_PASSWORD="igp-pass" 
DEFAULT_DB_NAME="igaming_platform"

# superuser credentials for granting privileges
SUPER_DB_USER="root"
SUPER_DB_PASSWORD="igp-root" 

# prompt for custom configuration or use defaults
echo "Do you want to use the default configuration or enter your own?"
echo "1. Use default configuration"
echo "2. Enter your own configuration"
read -p "Select an option (1/2): " user_choice

if [[ "$user_choice" == "2" ]]; then
  read -p "Enter MySQL host (default: $DEFAULT_DB_HOST): " DB_HOST
  DB_HOST=${DB_HOST:-$DEFAULT_DB_HOST}

  read -p "Enter MySQL username (default: $DEFAULT_DB_USER): " DB_USER
  DB_USER=${DB_USER:-$DEFAULT_DB_USER}

  read -sp "Enter MySQL password (default will be used if left empty): " DB_PASSWORD
  DB_PASSWORD=${DB_PASSWORD:-$DEFAULT_DB_PASSWORD}
  echo

  read -p "Enter database name (default: $DEFAULT_DB_NAME): " DB_NAME
  DB_NAME=${DB_NAME:-$DEFAULT_DB_NAME}
else
  DB_HOST=$DEFAULT_DB_HOST
  DB_USER=$DEFAULT_DB_USER
  DB_PASSWORD=$DEFAULT_DB_PASSWORD
  DB_NAME=$DEFAULT_DB_NAME
fi

cat <<EOL > db_config.conf
DB_HOST=$DB_HOST
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_NAME=$DB_NAME
EOL

echo "Configuration saved!"

# Set log_bin_trust_function_creators to 1 to allow triggers to be created
MYSQL_CONTAINER_NAME=$(docker compose ps -q mysql)
docker exec -i $MYSQL_CONTAINER_NAME mysql -h "$DB_HOST" -u "$SUPER_DB_USER" -p"$SUPER_DB_PASSWORD" -e "SET GLOBAL log_bin_trust_function_creators = 1;"

# SQL commands for database setup and privilege granting
SQL_SCRIPT="
CREATE DATABASE IF NOT EXISTS $DB_NAME;

CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';

GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
GRANT TRIGGER ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
"

# use superuser to execute the SQL script for granting privileges
MYSQL_CONTAINER_NAME=$(docker compose ps -q mysql)
docker exec -i $MYSQL_CONTAINER_NAME mysql -h "$DEFAULT_DB_HOST" -u "$SUPER_DB_USER" -p"$SUPER_DB_PASSWORD" -e "$SQL_SCRIPT"

if [ $? -eq 0 ]; then
    echo "Database created and user setup successfully!"
else
    echo "There was an error setting up the database and user."
fi
