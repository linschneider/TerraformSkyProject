#!/bin/bash


sudo apt update
sudo apt install -y python3 python3-pip

# Install or update Python dependencie
pip install flask
pip install psycopg2
python3 -m pip install psycopg2-binary
sleep 1

# Set environment variables if required (replace with your own)
#export FLASK_APP=~/TerraformSkyProject/sky_flask_app/sky_flask_app.py
#export FLASK_ENV=production

# Run your Flask application (adjust the command as needed)
flask --app=sky_flask_app.py run --host=0.0.0.0 --port=8080



