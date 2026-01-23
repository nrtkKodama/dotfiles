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
	@echo "  make logs    Show container logs"
	@echo "  make clean   Stop container and remove volumes (clears cache)"
	@echo ""
	@echo "Singularity:"
	@echo "  make singularity-build  Build the Singularity image (.sif)"
	@echo "  make singularity-shell  Enter the Singularity container"


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

.PHONY: logs
logs:
	docker compose logs -f

.PHONY: clean
clean:
	docker compose down -v
	rm -f *.sif

#
# Singularity
#

SIF_IMAGE_NAME=python-dev.sif

.PHONY: singularity-build
singularity-build:
	singularity build --fakeroot $(SIF_IMAGE_NAME) Singularity.def

.PHONY: singularity-shell
singularity-shell:
	singularity shell $(SIF_IMAGE_NAME)

