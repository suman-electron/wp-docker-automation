#!/bin/bash

# MAINTAINER: Suman Kumar Bera
# DESCRIPTION: This script simplifies the setup and management of WordPress sites using Docker containers.

# Function to start WordPress containers
function start_site() {
    docker-compose up -d
    echo "WordPress site '$SITE_NAME' is running. Access it at http://$SITE_NAME:8080."
}

# Function to stop WordPress containers
function stop_site() {
    docker-compose down
    echo "WordPress site '$SITE_NAME' is stopped."
}

# Check if Docker and Docker Compose are installed
if ! command -v docker &> /dev/null || ! command -v docker-compose &> /dev/null; then
    echo "Docker and/or Docker Compose are not installed. Installing..."
    # Install Docker and Docker Compose
    sudo apt update
    sudo apt install -y docker.io docker-compose
    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker and Docker Compose installed successfully."
fi

# Check if a subcommand is provided
if [ -z "$1" ]; then
    echo "Usage: ./install_wordpress.sh [create/start/stop] example.com"
    exit 1
fi

# Extract subcommand and site name from arguments
SUBCOMMAND=$1
SITE_NAME=$2

# Perform actions based on the subcommand
case "$SUBCOMMAND" in
    "create")
        # Check if site name is provided
        if [ -z "$SITE_NAME" ]; then
            echo "Please provide a site name as an argument."
            exit 1
        fi
        MYSQL_ROOT_PASSWORD="your_mysql_password"

        # Create a docker-compose.yml file
        cat <<EOL > docker-compose.yml
version: '3'
services:
  db:
    image: mysql:latest
    volumes:
      - db_data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress_password
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"  # Map to port 8080 on host
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress_password
      WORDPRESS_DB_NAME: wordpress
    depends_on:
      - db
volumes:
  db_data: {}
EOL

        # Start WordPress containers
        start_site
        # Add entry to /etc/hosts
        echo "127.0.0.1 $SITE_NAME" | sudo tee -a /etc/hosts > /dev/null
        ;;

    "start")
        # Check if site name is provided
        if [ -z "$SITE_NAME" ]; then
            echo "Please provide a site name as an argument."
            exit 1
        fi
        start_site
        ;;

    "stop")
        # Check if site name is provided
        if [ -z "$SITE_NAME" ]; then
            echo "Please provide a site name as an argument."
            exit 1
        fi
        stop_site
        ;;

    *)
        echo "Invalid subcommand. Usage: ./install_wordpress.sh [create/start/stop] example.com"
        exit 1
        ;;
esac

# Prompt user to open the site in a browser after creation
if [ "$SUBCOMMAND" == "create" ]; then
    read -p "Do you want to open http://$SITE_NAME:8080 in your browser? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        xdg-open "http://$SITE_NAME:8080"  # Open in the default web browser (Linux)
    fi
fi

