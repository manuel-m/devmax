# DevMax

A containerized development environment with multi-language support.

## Overview

DevMax provides a comprehensive development container with tools for JavaScript/Node.js, Java, Python, Go, and Rust development. It includes a web server (Nginx) and optional PostgreSQL database support.

## Features

- **Multi-language support**: Node.js 20, Java 8/11/17, Python 3, Go 1.21, Rust
- **Development tools**: npm, yarn, pnpm, Maven, pip, poetry, pipenv, comby
- **Web server**: Nginx for serving static files
- **Database**: PostgreSQL (optional, currently commented out)
- **SSH access**: Remote development support on port 2222
- **Code quality tools**: ESLint, Prettier, Black, Flake8, MyPy

## Quick Start

1. Set required environment variables:
   ```bash
   export DEV_PASSWORD="your-password"
   export DEV_USERNAME="dev"  # optional, defaults to 'dev'
   export ROOT_PASSWORD="root-password"  # optional
   ```

2. Start the development environment:
   ```bash
   docker-compose up -d
   ```

3. Access your workspace:
   - SSH: `ssh dev@localhost -p 2222`
   - Web: `http://localhost:8888`
   - Development servers: ports 3000, 4200, 5000, 8080, 8081, 9000

## Project Structure

```
devmax/
├── docker-compose.yml          # Main orchestration file
├── devmax/
│   └── Dockerfile             # Development container definition
├── workspace/                 # Your development workspace
│   ├── front/                # Frontend projects
│   └── back/                 # Backend projects
├── nginx/
│   └── nginx.conf            # Nginx configuration
├── postgres-custom/
│   └── Dockerfile            # Custom PostgreSQL image
└── docker-entrypoint-initdb.d/
    └── init.sql              # Database initialization
```

## Usage

The workspace directory is mounted into the container at `/workspace`, allowing you to develop with your local tools while running in the containerized environment.

### Available Ports

- **3000**: React/Next.js development server
- **4200**: Angular development server  
- **5000**: Express.js default port
- **8080**: Spring Boot default port
- **8081**: Alternative Java application port
- **8888**: Nginx web server
- **9000**: Additional development port
- **2222**: SSH access

### Environment Configuration

The container uses environment variables for configuration:
- `DEV_USERNAME`: Development user name (default: dev)
- `DEV_PASSWORD`: Development user password (required)
- `ROOT_PASSWORD`: Root password (optional)

## Optional Services

To enable PostgreSQL and Adminer (database admin UI), uncomment the relevant sections in `docker-compose.yml`.