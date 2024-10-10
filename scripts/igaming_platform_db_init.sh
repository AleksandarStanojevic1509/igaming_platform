#!/bin/bash

# this will make scripts executable and run them
ensure_executable_and_run() {
  SCRIPT=$1
  if [[ -x "$SCRIPT" ]]; then
    echo ">> $SCRIPT << is already executable."
  else
    echo ">> $SCRIPT << is not executable. Making it executable..."
    chmod +x "$SCRIPT"
    echo ">> $SCRIPT << is now executable."
  fi

  echo "Running $SCRIPT..."
  ./$SCRIPT
}

echo "Make sure that you have docker and docker compose installed on your machine."

# step_1: start mysql server with docker compose
echo "__________STEP_1__________"
ensure_executable_and_run "start_mysql_server.sh"

# step_2: prepare db configuration
echo "__________STEP_2__________"
ensure_executable_and_run "configure_db.sh"

#step_3: set up the database. this will create db, tables and store procedure
echo "__________STEP_3__________"
ensure_executable_and_run "setup_db.sh"

# step_4: create_migrations table to be sure that we can run proprey migrations in the future from api layer
echo "__________STEP_4__________"
ensure_executable_and_run "add_migrations_table.sh"

# step_5: after init db, close mysql server
echo "__________STEP_5__________"
ensure_executable_and_run "close_mysql_server.sh"

