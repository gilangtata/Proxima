SHELL := /bin/sh
.DEFAULT_GOAL := help

NPM ?= npm
ARGS ?=
ELECTRON ?= ./node_modules/.bin/electron
ELECTRON_SANDBOX := node_modules/electron/dist/chrome-sandbox

.PHONY: help install run start start-no-sandbox mcp cli build build-linux build-ubuntu build-win check ubuntu-deps sandbox-status fix-sandbox

help:
	@printf '%s\n' 'Proxima Make targets:'
	@printf '%s\n' '  make install       Install Node dependencies'
	@printf '%s\n' '  make run           Start the Electron app'
	@printf '%s\n' '  make start         Alias for make run'
	@printf '%s\n' '  make fix-sandbox   Fix Electron chrome-sandbox permissions on Linux'
	@printf '%s\n' '  make start-no-sandbox  Start Electron with Chromium sandbox disabled'
	@printf '%s\n' '  make mcp           Start the MCP server'
	@printf '%s\n' '  make cli ARGS=...  Run the Proxima CLI'
	@printf '%s\n' '  make build-linux   Build Linux AppImage'
	@printf '%s\n' '  make build-ubuntu  Alias for make build-linux'
	@printf '%s\n' '  make build-win     Build Windows installer'
	@printf '%s\n' '  make check         Run syntax checks'
	@printf '%s\n' '  make ubuntu-deps   Install Ubuntu Electron runtime libraries'

install:
	$(NPM) install

run:
	$(NPM) start

start: run

start-no-sandbox:
	$(ELECTRON) --no-sandbox .

mcp:
	$(NPM) run mcp

cli:
	$(NPM) run cli -- $(ARGS)

build:
	$(NPM) run build

build-linux:
	$(NPM) run build:linux

build-ubuntu: build-linux

build-win:
	$(NPM) run build:win

check:
	node --check electron/main-v2.cjs
	node --check electron/rest-api.cjs
	node --check src/mcp-server-v3.js
	node --check cli/proxima-cli.cjs

ubuntu-deps:
	sudo apt update
	sudo apt install -y libnss3 libatk-bridge2.0-0 libgtk-3-0 libgbm1 libxss1
	sudo apt install -y libasound2 || sudo apt install -y libasound2t64

sandbox-status:
	@test -f "$(ELECTRON_SANDBOX)" || { echo "Missing $(ELECTRON_SANDBOX). Run make install first."; exit 1; }
	@ls -l "$(ELECTRON_SANDBOX)"

fix-sandbox:
	@test -f "$(ELECTRON_SANDBOX)" || { echo "Missing $(ELECTRON_SANDBOX). Run make install first."; exit 1; }
	sudo chown root:root "$(ELECTRON_SANDBOX)"
	sudo chmod 4755 "$(ELECTRON_SANDBOX)"
	@ls -l "$(ELECTRON_SANDBOX)"
