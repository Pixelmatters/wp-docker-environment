# Wordpress Docker Environment

- Debian Jessie (8.4)
- MySQL 5.6
- PHP 5.6
- NPM (latest available on Debian official repository)

## Install

    https://www.docker.com/products/docker

## Usage

** First run **

Build 'web' container

    docker-compose build

** Start services **

MySQL on port 3306 and

    docker-compose up -d

** MySQL client **

    docker-compose run --rm db mysql -h db -p

** Logs **

    docker-compose logs -f <web/db>
