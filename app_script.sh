#!/bin/bash

# Clone the repository
git clone https://github.com/linschneider/TerraformSkyProject.git

# Navigate to the Flask app directory
cd TerraformSkyProject
sudo apt update
sudo apt install -y python3 python3-pip

# Install or update Python dependencie
pip install flask
pip install psycopg2
python3 -m pip install psycopg2-binary
sleep 1

# Run your Flask application (adjust the command as needed)
flask --app=sky_flask_app.py run --host=0.0.0.0 --port=8080



