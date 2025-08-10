# Simple CRUD Go - Makefile

.PHONY: help build run clean test docker-up docker-down install

# Configurações
APP_NAME := simple-crud-go
GO_VERSION := 1.24.5
DOCKER_COMPOSE_FILE := docker-compose.yml

help: ## Mostra esta mensagem de ajuda
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Instala as dependências do projeto
	@echo "Instalando dependências..."
	go mod download
	go mod tidy

build: ## Compila a aplicação
	@echo "Compilando a aplicação..."
	go build -o bin/$(APP_NAME) main.go

run: ## Executa a aplicação
	@echo "Executando a aplicação..."
	go run main.go

docker-up: ## Inicia o banco de dados PostgreSQL
	@echo "Iniciando PostgreSQL com Docker..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

docker-down: ## Para o banco de dados PostgreSQL
	@echo "Parando PostgreSQL..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) down

docker-logs: ## Mostra os logs do PostgreSQL
	@echo "Logs do PostgreSQL:"
	docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f postgres

setup: ## Configura o ambiente de desenvolvimento
	@echo "Configurando ambiente de desenvolvimento..."
	@if [ ! -f .env ]; then \
		echo "Copiando .env.example para .env..."; \
		cp .env.example .env; \
		echo "⚠️  Edite o arquivo .env com suas configurações!"; \
	fi
	make install
	make docker-up

dev: ## Inicia o ambiente de desenvolvimento completo
	@echo "Iniciando ambiente de desenvolvimento..."
	make docker-up
	@echo "Aguardando PostgreSQL inicializar..."
	@sleep 3
	make run

fmt: ## Formata o código Go
	@echo "Formatando código..."
	go fmt ./...

lint: ## Executa o linter (requer golangci-lint)
	@echo "Executando linter..."
	golangci-lint run

mod-update: ## Atualiza as dependências
	@echo "Atualizando dependências..."
	go get -u all
	go mod tidy

status: ## Mostra o status dos containers
	@echo "Status dos containers:"
	docker-compose -f $(DOCKER_COMPOSE_FILE) ps
