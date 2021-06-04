#!/usr/bin/env bash


killall shortblito-web-server || true

shortblito-web-server &
