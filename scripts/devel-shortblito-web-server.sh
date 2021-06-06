#!/usr/bin/env bash

export DEVELOPMENT=True

stack install shortblito-web-server \
  --file-watch --watch-all \
  --no-nix-pure \
  --exec='./scripts/restart-shortblito-web-server.sh'

