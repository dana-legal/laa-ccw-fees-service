# Claim for Controlled Work Alpha - Fees Calculator Service

[![repo standards badge](https://img.shields.io/endpoint?labelColor=231f20&color=005ea5&style=for-the-badge&label=MoJ%20Compliant&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fendpoint%2Flaa-ccw-fees-service&logo=data:image/png;base64,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)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-report/laa-ccw-fees-service)

## About this repository
TODO

## Running The App
### Build application
- `mvn clean install`

### Run application
- `java -jar -Dspring.profiles.active=local target/laa-ccw-fees-service-0.0.1-SNAPSHOT.jar`

### Run application (via Docker)
- `docker compose up`

### Actuator Endpoints
- http://localhost:8086/actuator
- http://localhost:8086/actuator/health
- http://localhost:8086/actuator/info
- http://localhost:8086/actuator/metrics

## Database Setup

### Local Development with Docker

The application is configured to use a PostgreSQL database on the `legallinx-network` Docker network.

#### Prerequisites
- Docker and Docker Compose installed
- The `legallinx-network` Docker network must exist
- A PostgreSQL container named `legallinx-postgres-db` running on that network

#### Setup Steps

1. **Create the database:**
   ```bash
   docker exec -it legallinx-postgres-db psql -U postgres -c "CREATE DATABASE ccw_fees;"
   ```

2. **Create the schema:**
   ```bash
   docker exec -i legallinx-postgres-db psql -U postgres -d ccw_fees < src/main/resources/ccw-database-schema.sql
   ```

3. **Seed the database:**
   ```bash
   docker exec -i legallinx-postgres-db psql -U postgres -d ccw_fees < src/main/resources/ccw-database-data.sql
   ```

4. **Start the application:**
   ```bash
   docker compose up
   ```

The application will connect to the PostgreSQL database using these credentials (configured in `docker-compose.yml`):
- Database: `ccw_fees`
- User: `postgres`
- Password: `example`
- Host: `legallinx-postgres-db:5432`

### Production Database Deployment
The production environment uses PostgreSQL (RDS) and requires manual database setup. The application does **not** automatically create or seed the database in production.

#### Prerequisites
- Access to the production PostgreSQL database
- Database credentials (DB_SERVER, DB_NAME, DB_USER, DB_PASSWORD)
- PostgreSQL client (`psql`) installed

#### Initial Setup

1. **Connect to the PostgreSQL database:**
   ```bash
   psql -h <DB_SERVER> -U <DB_USER> -d <DB_NAME>
   ```

2. **Run the schema creation script:**
   ```bash
   psql -h <DB_SERVER> -U <DB_USER> -d <DB_NAME> -f src/main/resources/ccw-database-schema.sql
   ```
   
   This will:
   - Drop and recreate the `CCW` schema
   - Create all tables, views, and constraints
   - Set up the database structure

3. **Run the data seeding script:**
   ```bash
   psql -h <DB_SERVER> -U <DB_USER> -d <DB_NAME> -f src/main/resources/ccw-database-data.sql
   ```
   
   This will populate the database with:
   - VAT rates
   - Law types
   - Matter codes
   - Case stages
   - Provider locations
   - Level codes and fees
   - Reference data

#### Updating Production Data

When schema or data changes are needed:

1. **For schema changes:**
   - Update `ccw-database-schema.sql`
   - **Warning:** Running the schema script will drop the existing schema and all data
   - Consider creating incremental migration scripts for production updates

2. **For data updates:**
   - Update `ccw-database-data.sql`
   - Review the script to ensure it won't conflict with existing data
   - Consider using `UPDATE` or `INSERT ... ON CONFLICT` statements for incremental updates

#### Best Practices

- **Always backup the database** before running schema changes
- Test scripts in a non-production environment first
- Consider implementing a migration tool (e.g., Flyway or Liquibase) for version-controlled database changes
- Use transactions when running manual scripts to allow rollback if needed:
  ```sql
  BEGIN;
  -- Run your script here
  -- Review changes
  COMMIT; -- or ROLLBACK if issues found
  ```

#### Environment Variables

The application requires these environment variables to connect to PostgreSQL:
- `DB_SERVER`: PostgreSQL server endpoint
- `DB_NAME`: Database name
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password

These are configured in the Kubernetes deployment manifests.