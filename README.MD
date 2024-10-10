## Installation

### Requirements:

- **Operating System:** Linux-based Operating System (Ubuntu or Debian-like preferred)
- **Git:** [How to install](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- **Docker Engine:** [How to install](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script)
  [Configure rootless support](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)
- **Docker Compose V2:** [How to install](https://docs.docker.com/compose/install/linux/#install-using-the-repository) - if you use Docker Compose V1 maybe you will need to use/change `docker compose ...` to `docker-compose ...` in scripts and whe you run docker on local.
- **Node.js:** >21.x [How to install](https://nodejs.org/en/learn/getting-started/how-to-install-nodejs)

## Running aplication:

- **Clone Repository:** `git clone git@github.com:AleksandarStanojevic1509/igaming_platform.git -b main igaming_platform`

### Sripting layer:

Setting up the database is possible through bash scripts. Follow the steps below:

#### Steps:

1. Navigate from root to the script folder:
   ```bash
   cd scripts/
   ```
2. Make the following scripts executable:

- **igaming_platform_db_init.sh**

  ```bash
  chmod +x igaming_platform_db_init.sh
  ```

  This script will spin up a MySQL server, set up the database, and create the required tables and procedures.

- **mock_data.sh**

  ```bash
  chmod +x mock_data.sh
  ```

  This script will populate the tables with mock data to avoid empty tables.

  - **get_players_rank.sh**

  ```bash
  chmod +x get_players_rank.sh
  ```

  This script returns a table with the players' rankings. Note that initially, this will return a table where all players are ranked equally because the mock data includes players with empty/zero balances. To distribute prizes, use the corresponding API endpoint.

#### Application layer:

#### Steps:

1. When you are in root folder run docker to spin mysql sever
   ```bash
   docker compose up --build
   ```
2. Navigate from root to the api folder:
   ```bash
   cd api/
   ```
3. Install dependecies and run server:
   ```bash
   npm install
   npm run dev
   ```
4. Migration tables and creating procedures and triggers:
   If yuor data base is initializeed with bash scripts, you can avoid this step. Othervise you need to:

- Run migrations with `npm run migration:run`
- Procedures and trigers due the issue with typeOrm (DELIMITER) need to add manually with queries. [REF:](./scripts/setup_db.sh) (lines 40-85)
- You can use `mock_data.sh` to populate data. Make notice that this will terminate mysql conatainer and you need to up it again.

5. Curently application layer have two enpoints:

- GET `http://localhost:3000/api/v1/player/ranking` - will return json with rankigs
- GET `http://localhost:3000/api/v1/tournament/distribute/:id` - send id of tournament via params to trigger prize distributions

## Reflections:

During the completion of this task, I learned a lot and refreshed my existing knowledge. I realized how valuable stored procedures can be for performing calculations at the database layer rather than at the application layer. The biggest challenge I faced was implementing features like migrations for stored procedures and triggers on the application side.

When optimizing the queries, I focused on applying indexes to each table and ensuring proper data sanitization at the database level. For example, I added a year column to the tournaments table, and I used a combination of tournament_name and year as a unique key. This approach prevents duplicates, allows better tracking of tournaments over the years, reduces the risk of data entry errors, improves queries, and helps maintain data integrity.

I also added a player_tournaments table with a UNIQUE (tournament_id, placement) constraint, which links the two primary tables and ensures that the same placement cannot be assigned more than once for the same tournament. Regarding data protection, I implemented several CHECK constraints within the tables. However, I encountered an issue with enforcing a CHECK (end_date > start_date) across two columns in one table, which led me to implement triggers to validate this condition at the time of data entry.

Additionally, I added a safeguard in the stored procedure to prevent prize distribution from being processed more than once for the same tournament by introducing a boolean field in the tournaments table.
