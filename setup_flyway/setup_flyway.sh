#!/bin/bash

# Define variables
FLYWAY_VERSION="8.5.13"  # Change to the desired version
FLYWAY_URL="https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz"
FLYWAY_DIR="/opt/flyway"
PROJECT_DIR="$HOME/my_project"
SQL_DIR="$PROJECT_DIR/sql"
CONFIG_FILE="$PROJECT_DIR/flyway.conf"
DB_URL="jdbc:postgresql://localhost:5432/your_database"
DB_USER="your_username"
DB_PASSWORD="your_password"

# Create necessary directories
mkdir -p $FLYWAY_DIR
mkdir -p $SQL_DIR

# Download and extract Flyway
echo "Downloading Flyway..."
wget -qO- $FLYWAY_URL | tar -xz -C $FLYWAY_DIR --strip-components=1

# Add Flyway to PATH
export PATH=$PATH:$FLYWAY_DIR

# Verify Flyway installation
flyway -v

# Create Flyway configuration file
cat <<EOL > $CONFIG_FILE
flyway.url=$DB_URL
flyway.user=$DB_USER
flyway.password=$DB_PASSWORD
flyway.schemas=public
flyway.locations=filesystem:$SQL_DIR
EOL

echo "Flyway configuration file created at $CONFIG_FILE"

# Create example migration scripts
cat <<EOL > $SQL_DIR/V1__Initial_setup.sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL
);
EOL

cat <<EOL > $SQL_DIR/V2__Add_new_table.sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    order_date TIMESTAMP NOT NULL
);
EOL

echo "Example migration scripts created in $SQL_DIR"

# Run Flyway migrations
flyway -configFiles=$CONFIG_FILE migrate

# Check migration status
flyway -configFiles=$CONFIG_FILE info

echo "Flyway migrations completed."

