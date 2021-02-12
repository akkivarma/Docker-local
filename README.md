# Docker-local

Repository for Docker setup files to run projects locally in containers.

## Overview

This project provides a boilerplate structure and dockerfiles for essential services such as `apache`, `php` and `redis` for running projects locally.

To run any project in Docker, just add that project in `www` directory and add vhost for same in `apache/httpd-vhosts.conf` file.

## Pre-requisites

Make sure you have Docker installed. Follow the steps mentioned on the official [site](https://docs.docker.com/docker-for-windows/install/) if you don't already have it.

## Development Setup

1. Pull the repo
2. Open terminal (Git Bash / CMD) in the project directory
3. Run `docker-compose up -d --build apache` (`--build` flag would be needed only when one of the dockerfiles in `docker-compose.yml` have been updated).
4. Once that is completed run `docker ps`. It should show you the apache, fpm & redis containers running.
5. (Optional) Run any one-off command to build/install project dependencies if required. Refer [this](#running-one-off-tasks) section for more details.
6. Access the project in browser based on vhost setup in apache.
7. Once done with development, you can run `docker-compose down` which will stop the running containers of your project

Note that in one of the above steps you might get a notification asking for permission whether your project directory can be shared with docker environment which you should allow. Since we are sharing the code directory to the docker container as a volume to prevent rebuilding of image everytime a change happens.

Also note that all the specified docker commands are to be run from the project directory where the docker-compose.yml file is present, since it has all the configuration logic.

## Running one-off tasks

1. To use composer for any purpose (installation, removal etc), instead of running the usual `composer` command we will run `docker-compose run --rm composer`. Example: `docker-compose run --rm composer install` to install project's dependencies.
2. To use npm for any purpose, instead of running the usual `npm` command we will run `docker-compose run --rm npm`. Example: `docker-compose run --rm npm run build` where `build` command is defined in project's `package.json` file.
3. To use `php artisan` commands use the following `docker-compose run --rm artisan`. Example: To put the app in maintenance mode in laravel, we will run `docker-compose run --rm artisan down`.

Since our project is containerized, the above commands will spawn a container for npm / composer / php artisan, execute the required command on your codebase/working-directory and then remove that container, so we do not need any of the above dependencies to be installed on our system.

## Some gotchas on WSL2 (windows Subsystem for Linux)

### Issue #1

There might be some file permission error in php on WSL2/linux for file writes. Follow below steps to fix.

1. Find the user id of php-fpm. Run `docker exec -it fpm id -u www-data` where fpm is the php-fpm container name.
2. Change the user ownership. Run `sudo chown -R 82 <dir_path>` where `82` is the user id of `www-data` obtained in step 1 & `dir_path` would be the path of the folder where php needs to write files.
3. Set read/write/execute permissions for group. Run `sudo chmod g+rwx <dir_path>` where `dir_path` would be the path used in step 2. This step is needed if you want to edit/delete files in `dir_path`, because we changed the user ownership to another user `www-data` in step 2.

### Issue #2

Cannot use any IDE/Editor for coding unless it has support for WSL2. Try below Editors/IDEs.

- Use VSCode with [Remote-WSL extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) (free)
- Use PhpStorm v2020.1.2 which has support for WSL2 (paid)

## Some helpful links

- [Overview of Docker Compose](https://docs.docker.com/compose/)
- [Compose file specification](https://github.com/compose-spec/compose-spec/blob/master/spec.md)
- [Docker Desktop WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/)
- [Install Windows Subsystem for Linux (WSL) on Windows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [Using WSL 2 with Visual Studio Code](https://code.visualstudio.com/blogs/2019/09/03/wsl2)
