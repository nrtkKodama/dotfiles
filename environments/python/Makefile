# Makefile for Python Development Environment

# Default values
USERNAME ?= $(shell whoami)
USER_UID ?= $(shell id -u)
USER_GID ?= $(shell id -g)

export USERNAME
export USER_UID
export USER_GID

.PHONY: help
help:
	@echo "Python Environment Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make up      Start the container (build if necessary)"
	@echo "  make down    Stop and remove the container"
	@echo "  make build   Rebuild the container image"
	@echo "  make exec    Enter the running container shell"
	@echo "  make root    Enter the running container shell as root"
	@echo "  make logs    Show container logs"
	@echo "  make clean   Stop container and remove volumes (clears cache)"

.PHONY: up
up:
	docker compose up -d

.PHONY: down
down:
	docker compose down

.PHONY: build
build:
	docker compose build

.PHONY: exec
exec:
	docker compose exec python-dev bash

.PHONY: root
root:
	docker compose exec --user root python-dev bash

.PHONY: logs
logs:
	docker compose logs -f

.PHONY: clean
clean:
	docker compose down -v
