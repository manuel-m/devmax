#!/bin/bash

# Development Environment Setup Script

echo "Development Environment Setup"
echo "============================="

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "ERROR: .env file not found!"
    echo ""
    echo "Please create a .env file with your credentials:"
    echo "1. Copy the example file: cp .env.example .env"
    echo "2. Edit .env and set your own secure passwords"
    echo "3. Run this setup script again"
    echo ""
    exit 1
fi

# Source the .env file
set -a
source .env
set +a

# Validate required environment variables
if [ -z "$DEV_USERNAME" ] || [ -z "$DEV_PASSWORD" ]; then
    echo "ERROR: Required environment variables not set!"
    echo ""
    echo "Please ensure your .env file contains:"
    echo "DEV_USERNAME=your_username"
    echo "DEV_PASSWORD=your_secure_password"
    echo ""
    exit 1
fi

# Check for default/weak passwords
if [ "$DEV_PASSWORD" = "your_secure_password_here" ] || [ "$DEV_PASSWORD" = "dev" ] || [ "$DEV_PASSWORD" = "password" ] || [ "$DEV_PASSWORD" = "123456" ]; then
    echo "ERROR: Please set a secure password!"
    echo ""
    echo "Your password cannot be one of the common/default values."
    echo "Please update DEV_PASSWORD in your .env file with a secure password."
    echo ""
    exit 1
fi

# Validate username length (optional but recommended)
if [ ${#DEV_USERNAME} -gt 8 ]; then
    echo "WARNING: Username is longer than 8 characters. Consider using a shorter username for convenience."
fi

echo "Environment validation passed!"
echo ""
echo "Configuration:"
echo "  Username: $DEV_USERNAME"
echo "  Password: [HIDDEN]"
echo ""
echo "Starting Docker Compose..."
docker compose up --build -d

if [ $? -eq 0 ]; then
    echo ""
    echo "Development environment started successfully!"
    echo ""
    echo "Access points:"
    echo "  SSH: ssh $DEV_USERNAME@localhost -p 2222"
    echo "  Web Server: http://localhost:8888"
    echo "  Container: docker exec -it devmax bash"
    echo ""
    echo "Development ports:"
    echo "  3000 - React/Next.js dev server"
    echo "  4200 - Angular dev server" 
    echo "  5000 - Express.js default"
    echo "  8080 - Spring Boot default"
    echo "  8081 - Alternative Java app port"
    echo "  9000 - Additional development port"
else
    echo "Failed to start development environment"
    exit 1
fi