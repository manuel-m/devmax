#!/usr/bin/env pwsh

# Development Environment Setup Script for Windows

Write-Host "Development Environment Setup" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan

# Check if .env file exists
if (!(Test-Path ".env")) {
    Write-Host "ERROR: .env file not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please create a .env file with your credentials:"
    Write-Host "1. Copy the example file: copy .env.example .env"
    Write-Host "2. Edit .env and set your own secure passwords"
    Write-Host "3. Run this setup script again"
    Write-Host ""
    exit 1
}

# Load environment variables from .env file
Get-Content ".env" | ForEach-Object {
    if ($_ -match "^\s*([^#][^=]*?)\s*=\s*(.*?)\s*$") {
        $name = $matches[1]
        $value = $matches[2]
        [Environment]::SetEnvironmentVariable($name, $value, "Process")
    }
}

# Get environment variables
$DEV_USERNAME = $env:DEV_USERNAME
$DEV_PASSWORD = $env:DEV_PASSWORD

# Validate required environment variables
if ([string]::IsNullOrEmpty($DEV_USERNAME) -or [string]::IsNullOrEmpty($DEV_PASSWORD)) {
    Write-Host "ERROR: Required environment variables not set!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please ensure your .env file contains:"
    Write-Host "DEV_USERNAME=your_username"
    Write-Host "DEV_PASSWORD=your_secure_password"
    Write-Host ""
    exit 1
}

# Check for default/weak passwords
$weakPasswords = @("your_secure_password_here", "dev", "password", "123456")
if ($weakPasswords -contains $DEV_PASSWORD) {
    Write-Host "ERROR: Please set a secure password!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Your password cannot be one of the common/default values."
    Write-Host "Please update DEV_PASSWORD in your .env file with a secure password."
    Write-Host ""
    exit 1
}

# Validate username length (optional but recommended)
if ($DEV_USERNAME.Length -gt 8) {
    Write-Host "WARNING: Username is longer than 8 characters. Consider using a shorter username for convenience." -ForegroundColor Yellow
}

Write-Host "Environment validation passed!" -ForegroundColor Green
Write-Host ""
Write-Host "Configuration:"
Write-Host "  Username: $DEV_USERNAME"
Write-Host "  Password: [HIDDEN]"
Write-Host ""
Write-Host "Starting Docker Compose..."

# Start Docker Compose
docker compose up --build -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Development environment started successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Access points:"
    Write-Host "  SSH: ssh $DEV_USERNAME@localhost -p 2222"
    Write-Host "  Web Server: http://localhost:8888"
    Write-Host "  Container: docker exec -it devmax bash"
    Write-Host ""
    Write-Host "Development ports:"
    Write-Host "  3000 - React/Next.js dev server"
    Write-Host "  4200 - Angular dev server"
    Write-Host "  5000 - Express.js default"
    Write-Host "  8080 - Spring Boot default"
    Write-Host "  8081 - Alternative Java app port"
    Write-Host "  9000 - Additional development port"
} else {
    Write-Host "Failed to start development environment" -ForegroundColor Red
    exit 1
}