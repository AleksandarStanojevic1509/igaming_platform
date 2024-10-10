#!/bin/bash

echo "Please first run the igaming_platform_db_init.sh script which will make executable all the scripts used here."

# Step 1: Start MySQL server with Docker Compose
echo "__________STEP_1__________"
./start_mysql_server.sh

# Step 2: add somo mock data
echo "__________STEP_2__________"
if [ ! -f db_config.conf ]; then
  echo "Database configuration not found in script folder. Make sure db is init, or db_config.conf exists in scripts folder."
  exit 1
fi
source db_config.conf

MOCK_DATA_QUERY="

-- Insert mock data into the players table
INSERT INTO players (player_name, player_email, account_balance) VALUES
('John Doe', 'john.doe@example.com', 0.00),
('Jane Smith', 'jane.smith@example.com', 0.00),
('Mike Johnson', 'mike.johnson@example.com', 0.00),
('Emily Davis', 'emily.davis@example.com', 0.00),
('Chris Brown', 'chris.brown@example.com', 0.00),
('Katie Wilson', 'katie.wilson@example.com', 0.00),
('David Lee', 'david.lee@example.com', 0.00),
('Sarah White', 'sarah.white@example.com', 0.00),
('Jessica Green', 'jessica.green@example.com', 0.00),
('Daniel Clark', 'daniel.clark@example.com', 0.00),
('Laura Harris', 'laura.harris@example.com', 0.00),
('Kevin Hall', 'kevin.hall@example.com', 0.00),
('Nina Young', 'nina.young@example.com', 0.00),
('Adam King', 'adam.king@example.com', 0.00),
('Sophia Lewis', 'sophia.lewis@example.com', 0.00),
('Ryan Walker', 'ryan.walker@example.com', 0.00),
('Olivia Robinson', 'olivia.robinson@example.com', 0.00),
('Ella Lee', 'ella.lee@example.com', 0.00),
('Lucas Allen', 'lucas.allen@example.com', 0.00),
('Grace Martinez', 'grace.martinez@example.com', 0.00);

-- Insert mock data into the tournaments table (with year)
INSERT INTO tournaments (tournament_name, year, prize_pool, start_date, end_date) VALUES
('Spring Championship', 2023, 1000.00, '2023-03-01 10:00:00', '2023-03-03 18:00:00'), -- 2023 Spring Championship
('Spring Championship', 2024, 1000.00, '2024-03-01 10:00:00', '2024-03-03 18:00:00'), -- 2024 Spring Championship
('Summer Open', 2024, 1500.00, '2024-06-01 12:00:00', '2024-06-05 17:00:00'),
('Fall Classic', 2024, 2000.00, '2024-09-01 14:00:00', '2024-09-04 20:00:00'),
('Winter Cup', 2024, 2500.00, '2024-12-01 11:00:00', '2024-12-05 19:00:00');

-- Insert mock data into the player_tournaments table
INSERT INTO player_tournaments (player_id, tournament_id, placement) VALUES
-- Player participation in 2023 Spring Championship
(1, 1, 1),  -- John Doe - 1st place in 2023 Spring Championship
(2, 1, 2),  -- Jane Smith - 2nd place in 2023 Spring Championship
(3, 1, 3),  -- Mike Johnson - 3rd place in 2023 Spring Championship
(4, 1, 4),  -- Emily Davis - 4th place in 2023 Spring Championship

-- Player participation in 2024 Spring Championship
(1, 2, 1),  -- John Doe - 1st place in 2024 Spring Championship
(2, 2, 2),  -- Jane Smith - 2nd place in 2024 Spring Championship
(3, 2, 3),  -- Mike Johnson - 3rd place in 2024 Spring Championship
(4, 2, 4),  -- Emily Davis - 4th place in 2024 Spring Championship

-- Player participation in Summer Open
(6, 3, 1),  -- Katie Wilson - 1st place in Summer Open
(7, 3, 2),  -- David Lee - 2nd place in Summer Open
(8, 3, 3),  -- Sarah White - 3rd place in Summer Open

-- Player participation in Fall Classic
(2, 4, 1), -- Daniel Clark - 2nd place in Fall Classic
(10, 4, 2), -- Daniel Clark - 2nd place in Fall Classic
(11, 4, 3), -- Laura Harris - 3rd place in Fall Classic
(12, 4, 4), -- Kevin Hall - 4th place in Fall Classic

-- Player participation in Winter Cup
(13, 5, 1), -- Nina Young - 1st place in Winter Cup
(14, 5, 2), -- Adam King - 2nd place in Winter Cup
(15, 5, 3); -- Sophia Lewis - 3rd place in Winter Cup

"

echo "Mocking data..."
MYSQL_CONTAINER_NAME=$(docker compose ps -q mysql)
docker exec -i $MYSQL_CONTAINER_NAME mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "$MOCK_DATA_QUERY"
echo "Mock data added successfully!"

# step_3: after init db, close mysql server
echo "__________STEP_3__________"
./close_mysql_server.sh
