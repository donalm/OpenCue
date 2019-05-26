#!/bin/bash

export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=cuebot_local
export DB_USER=cuebot
export DB_PASS="DATABASE PASSWORD HERE"
export DB_URI="postgresql://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
