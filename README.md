# Nginx + PHP + PostgreSQL Server

This project sets up a server environment using Docker, including Nginx, PHP-FPM, and PostgreSQL. The project is structured to support multiple projects, each with its own configuration.

## Project Structure

```
project-root/
├── nginx/
│   ├── Dockerfile
│   ├── conf.d/
│   │   ├── test.conf
│   │   └── ...
├── php/
│   ├── Dockerfile
│   ├── php.ini
├── src/
│   ├── test/
│   │   ├── index.php
│   │   └── ...
├── docker-compose.yml
├── Makefile
└── README.md
```

### nginx/

- **Dockerfile**: File to create the Docker image for Nginx. It defines how to configure Nginx inside the container.
- **conf.d/**: Directory for Nginx configuration files.
    - **test.conf**: Example Nginx configuration file for the "test" project. Defines settings for handling web requests to this project.

### php/

- **Dockerfile**: File to create the Docker image for PHP-FPM. It defines how to configure PHP inside the container.
- **php.ini**: Configuration file for setting PHP parameters. Contains settings such as error display, error reporting level, etc.

### src/

- **test/**: Example directory for the "test" project.
    - **index.php**: Main PHP file for the "test" project. It can contain the initial code of your application.

### docker-compose.yml

This file defines the Docker services needed for your project, their build contexts, volumes, and dependencies. It includes services for Nginx, PHP-FPM, and PostgreSQL.

### Makefile

File with commands for convenient management of Docker containers.

### README.md

This file contains the documentation for the project. It describes the project structure, configuration of each service, and commands for managing Docker containers.

## Services

- **nginx**: Acts as a web server.
- **php-fpm**: Processes PHP files.
- **db**: PostgreSQL database.

## Configuration

### Nginx Configuration

Nginx configuration files are located in the `nginx/conf.d/` directory. Each project has its own configuration file.

Example configuration for the `test` project (`nginx/conf.d/test.conf`):

```nginx
server {
    listen 80;
    server_name test.localhost;

    root /var/www/test;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass php-fpm:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

PHP Configuration
The PHP configuration file is located at `php/php.ini.` You can configure PHP parameters according to your needs.

Example configuration (`php/php.ini`):

```ini
; PHP Settings
display_errors = On
display_startup_errors = On
error_reporting = E_ALL
```

### Docker Compose

The `docker-compose.yml`  file defines the services, their build contexts, and volumes.

```yaml
version: '3.8'

services:
  nginx:
    build:
      context: .
      dockerfile: nginx/Dockerfile
    ports:
      - "80:80"
    depends_on:
      - php-fpm
    volumes:
      - ./src:/var/www
      - ./nginx/conf.d:/etc/nginx/conf.d

  php-fpm:
    build:
      context: ./php
      dockerfile: Dockerfile
    volumes:
      - ./src:/var/www
    depends_on:
      - db

  db:
    image: postgres:13
    ports:
      - '5434:5432'
    environment:
      POSTGRES_DB: db
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - db-data:/var/lib/postgresql/data
volumes:
  db-data:
```

## Makefile

The `Makefile` includes convenient commands for managing Docker containers.

```makefile
start: # start server
	docker-compose up --build

stop: # stop server
	docker-compose down

ps: # show containers
	docker-compose ps
```

## Usage

### Start the Server

To start the server, run:

```sh
make start
```

### Stop the Server

To stop the server, run:

```sh
make stop
```

### Show Running Containers

To show the list of running containers, run:

```sh
make ps
```

## Hosts Configuration

To access the projects via domain names such as `test.localhost`, add the following lines to the `hosts` file on your local machine:

```
127.0.0.1 test.localhost
```

## Accessing the Projects

- `http://test.localhost` for the first project.

This setup ensures consistent and easy management of your development environment using Docker.
