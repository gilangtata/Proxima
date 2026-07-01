SHELL := /bin/sh
.DEFAULT_GOAL := help

NPM ?= npm
ARGS ?=

.PHONY: help install run start mcp cli build build-linux build-ubuntu build-win check ubuntu-deps

help:
	@printf '%s\n' 'Proxima Make targets:'
	@printf '%s\n' '  make install       Install Node dependencies'
	@printf '%s\n' '  make run           Start the Electron app'
	@printf '%s\n' '  make start         Alias for make run'
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
