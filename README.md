# Simple CRUD Go 📝

[![Go](https://img.shields.io/badge/Go-1.24.5-blue.svg)](https://golang.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)](https://www.postgresql.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Um projeto de estudo simples em Go que implementa uma API REST para gerenciamento de tarefas (CRUD - Create, Read, Update, Delete) com PostgreSQL.

## 📚 Sobre o Projeto

Este é um repositório de estudo focado em aprender os conceitos fundamentais de desenvolvimento web em Go, incluindo:

- Criação de APIs REST
- Integração com banco de dados PostgreSQL
- Estruturação de projetos em Go
- Manipulação de JSON
- Roteamento HTTP
- Configuração com variáveis de ambiente

## 🏗️ Arquitetura

O projeto segue uma estrutura simples e organizada:

```
simple-crud-go/
├── config/          # Configurações do banco de dados
├── handlers/        # Manipuladores HTTP (controllers)
├── models/          # Modelos de dados
├── main.go          # Ponto de entrada da aplicação
├── docker-compose.yml # Configuração do PostgreSQL
├── client.http      # Exemplos de requisições HTTP
├── go.mod           # Dependências do projeto
└── go.sum           # Checksums das dependências
```

## 🚀 Tecnologias Utilizadas

- **[Go](https://golang.org)** - Linguagem de programação
- **[Gorilla Mux](https://github.com/gorilla/mux)** - Roteador HTTP
- **[PostgreSQL](https://www.postgresql.org)** - Banco de dados
- **[lib/pq](https://github.com/lib/pq)** - Driver PostgreSQL para Go
- **[godotenv](https://github.com/joho/godotenv)** - Carregamento de variáveis de ambiente
- **[Docker](https://www.docker.com)** - Containerização do banco de dados

## 📋 Pré-requisitos

- Go 1.24.5 ou superior
- Docker e Docker Compose
- Git

## ⚙️ Configuração e Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/alexandrejuniorc/simple-crud-go.git
cd simple-crud-go
```

### 2. Configure as variáveis de ambiente

Crie um arquivo `.env` na raiz do projeto:

```env
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_NAME=simple-crud-go
```

### 3. Inicie o banco de dados

```bash
docker-compose up -d
```

### 4. Instale as dependências

```bash
go mod download
```

### 5. Execute a aplicação

```bash
go run main.go
```

A API estará disponível em `http://localhost:8080`

## 📖 API Endpoints

### Listar todas as tarefas

```http
GET /tasks
```

**Resposta:**

```json
[
  {
    "id": 1,
    "title": "Learn Go",
    "description": "Learn Go in 30 minutes",
    "status": false
  }
]
```

### Criar uma nova tarefa

```http
POST /tasks
Content-Type: application/json

{
  "title": "Learn Go",
  "description": "Learn Go in 30 minutes",
  "status": false
}
```

**Resposta:**

```json
{
  "id": 1,
  "title": "Learn Go",
  "description": "Learn Go in 30 minutes",
  "status": false
}
```

### Atualizar uma tarefa

```http
PUT /tasks/{id}
Content-Type: application/json

{
  "title": "Learn Go",
  "description": "Learn Go in 40 minutes",
  "status": true
}
```

**Resposta:**

```json
{
  "id": 1,
  "title": "Learn Go",
  "description": "Learn Go in 40 minutes",
  "status": true
}
```

### Deletar uma tarefa

```http
DELETE /tasks/{id}
```

**Resposta:** `204 No Content`

## 🧪 Testando a API

O projeto inclui um arquivo `client.http` com exemplos de requisições que podem ser executadas diretamente no VS Code com a extensão REST Client.

Exemplos de uso:

1. **Listar tarefas:** Execute a requisição `read_tasks`
2. **Criar tarefa:** Execute a requisição `create_task`
3. **Atualizar tarefa:** Execute a requisição `update_task`
4. **Deletar tarefa:** Execute a requisição `delete_task`

## 📊 Estrutura do Banco de Dados

### Tabela `tasks`

| Campo       | Tipo         | Descrição                        |
| ----------- | ------------ | -------------------------------- |
| id          | SERIAL       | Chave primária (auto-incremento) |
| title       | VARCHAR(100) | Título da tarefa (obrigatório)   |
| description | TEXT         | Descrição da tarefa (opcional)   |
| status      | BOOLEAN      | Status da tarefa (padrão: false) |

## 🔧 Conceitos de Go Demonstrados

### 1. **Estruturação de Projetos**

- Organização em pacotes (`config`, `handlers`, `models`)
- Separação de responsabilidades

### 2. **Manipulação de HTTP**

- Criação de handlers HTTP
- Roteamento com Gorilla Mux
- Manipulação de métodos HTTP (GET, POST, PUT, DELETE)

### 3. **Integração com Banco de Dados**

- Conexão com PostgreSQL
- Execução de queries SQL
- Uso do pacote `database/sql`

### 4. **Serialização JSON**

- Encoding/Decoding de JSON
- Tags de struct (`json:"field"`)

### 5. **Tratamento de Erros**

- Padrão idiomático de Go para tratamento de erros
- Retorno de status HTTP apropriados

### 6. **Configuração**

- Uso de variáveis de ambiente
- Carregamento de configurações com godotenv

## 🚦 Status Codes

| Código | Descrição                |
| ------ | ------------------------ |
| 200    | Sucesso (GET, PUT)       |
| 201    | Criado (POST)            |
| 204    | Sem conteúdo (DELETE)    |
| 400    | Requisição inválida      |
| 404    | Recurso não encontrado   |
| 500    | Erro interno do servidor |

## 🤝 Como Contribuir

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Próximos Passos de Estudo

- [ ] Implementar middleware de logging
- [ ] Adicionar validação de dados
- [ ] Implementar paginação
- [ ] Adicionar testes unitários
- [ ] Implementar autenticação JWT
- [ ] Adicionar documentação Swagger
- [ ] Implementar migrations de banco de dados
- [ ] Adicionar cache com Redis

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👨‍💻 Autor

**Alexandre Junior** - [GitHub](https://github.com/alexandrejuniorc)

---

⭐ Não esqueça de dar uma estrela no projeto se ele foi útil para seus estudos!
