#!/bin/bash

# -------------------- Mounting data disk to the VM -----------------------
# Prepare a new empty disk
sudo mkfs -t ext4 /dev/sdc
sudo mkdir /data1
sudo mount /dev/sdc /data1
# -------------------------------------------------------------------------------

# Add PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import PostgreSQL repository key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update package lists
sudo apt-get update
# Install PostgreSQL
sudo apt-get -y install postgresql

# user, database and table and grant privileges to the user.

echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/*/main/postgresql.conf
echo "host    skydb         skyuser       all                     scram-sha-256" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf
sudo systemctl restart postgresql.service
pass=$(cat dbpass)
sudo -u postgres psql -c "ALTER USER postgres with encrypted password '$pass';"
#sudo -u postgres psql -c ALTER DATABASE template1 is_template false;"
#sudo -u postgres psql -c DROP DATABASE template1;"
sudo -u postgres createuser "skyuser"
sudo -u postgres psql -c "ALTER USER skyuser with encrypted password '$pass';"
sudo -u postgres psql -c "CREATE DATABASE skydb;"
sudo -u postgres psql -c "grant all privileges on database skydb to skyuser;"
sudo -u postgres psql -d skydb -c "CREATE TABLE data (id serial PRIMARY KEY, name VARCHAR NOT NULL, value INTEGER NOT NULL, time TIMESTAMP NOT NULL)"
sudo -u postgres psql -d skydb -c "GRANT ALL PRIVILEGES ON TABLE data TO skyuser;"
sudo -u postgres psql -d skydb -c "INSERT INTO data (name, value, time) VALUES ('lins', 16, '2009-01-06 10:30:00')"

