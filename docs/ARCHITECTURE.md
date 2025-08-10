# Documentação da Arquitetura

## Visão Geral

Este documento descreve a arquitetura e estrutura do projeto Simple CRUD Go, explicando como cada componente funciona e interage com os outros.

## Estrutura de Diretórios

```
simple-crud-go/
├── config/              # Configurações da aplicação
│   └── db.go           # Configuração do banco de dados
├── handlers/           # Manipuladores HTTP (Controllers)
│   └── task_handler.go # Lógica dos endpoints da API
├── models/             # Modelos de dados
│   └── task.go         # Estrutura e SQL da entidade Task
├── bin/                # Executáveis compilados (ignorado pelo git)
├── main.go             # Ponto de entrada da aplicação
├── go.mod              # Dependências do Go
├── go.sum              # Checksums das dependências
├── docker-compose.yml  # Configuração do PostgreSQL
├── client.http         # Exemplos de requisições HTTP
├── Makefile           # Comandos de automação
├── .env.example       # Exemplo de variáveis de ambiente
├── .gitignore         # Arquivos ignorados pelo Git
├── LICENSE            # Licença MIT
└── README.md          # Documentação principal
```

## Fluxo de Dados

```
HTTP Request → Router (Gorilla Mux) → Handler → Database → Response
```

### 1. **main.go**

- Ponto de entrada da aplicação
- Inicializa a conexão com o banco de dados
- Configura as rotas HTTP
- Inicia o servidor na porta 8080

### 2. **config/db.go**

- Carrega variáveis de ambiente do arquivo `.env`
- Estabelece conexão com PostgreSQL
- Valida a conexão com `Ping()`
- Retorna a instância `*sql.DB`

### 3. **models/task.go**

- Define a struct `Task` com tags JSON
- Contém o SQL para criação da tabela
- Define constantes relacionadas à entidade

### 4. **handlers/task_handler.go**

- Implementa os métodos CRUD:
  - `ReadTasks()` - Lista todas as tarefas
  - `CreateTask()` - Cria uma nova tarefa
  - `UpdateTask()` - Atualiza uma tarefa existente
  - `DeleteTask()` - Remove uma tarefa

## Padrões de Design Utilizados

### 1. **Dependency Injection**

```go
type TaskHandler struct {
    DB *sql.DB
}

func NewTaskHandler(db *sql.DB) *TaskHandler {
    return &TaskHandler{DB: db}
}
```

### 2. **Repository Pattern (Simplificado)**

- Os handlers atuam como repositories
- Encapsulam a lógica de acesso a dados
- Separação entre lógica de negócio e persistência

### 3. **MVC (Model-View-Controller)**

- **Model**: `models/task.go`
- **View**: Respostas JSON
- **Controller**: `handlers/task_handler.go`

## Tratamento de Erros

O projeto segue o padrão idiomático do Go para tratamento de erros:

```go
if err != nil {
    http.Error(writer, err.Error(), http.StatusInternalServerError)
    return
}
```

### Status Codes Utilizados

- `200 OK` - Operações de leitura e atualização bem-sucedidas
- `201 Created` - Recurso criado com sucesso
- `204 No Content` - Recurso deletado com sucesso
- `400 Bad Request` - Dados inválidos na requisição
- `404 Not Found` - Recurso não encontrado
- `500 Internal Server Error` - Erro interno do servidor

## Configuração

### Variáveis de Ambiente

```env
DB_HOST=localhost      # Host do banco de dados
DB_PORT=5432          # Porta do PostgreSQL
DB_USERNAME=postgres  # Usuário do banco
DB_PASSWORD=postgres  # Senha do banco
DB_NAME=simple-crud-go # Nome do banco de dados
```

### Dependências

- **gorilla/mux**: Roteador HTTP robusto
- **lib/pq**: Driver PostgreSQL nativo
- **joho/godotenv**: Carregamento de variáveis de ambiente

## Schema do Banco de Dados

### Tabela `tasks`

```sql
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    status BOOLEAN NOT NULL DEFAULT FALSE
);
```

**Campos:**

- `id`: Chave primária auto-incremento
- `title`: Título da tarefa (obrigatório, máximo 100 caracteres)
- `description`: Descrição detalhada (opcional)
- `status`: Status de conclusão (padrão: false)

## Endpoints da API

| Método | Endpoint      | Descrição              | Corpo da Requisição                 |
| ------ | ------------- | ---------------------- | ----------------------------------- |
| GET    | `/tasks`      | Lista todas as tarefas | -                                   |
| POST   | `/tasks`      | Cria uma nova tarefa   | JSON com title, description, status |
| PUT    | `/tasks/{id}` | Atualiza uma tarefa    | JSON com title, description, status |
| DELETE | `/tasks/{id}` | Remove uma tarefa      | -                                   |

## Exemplo de Uso

### 1. Criar uma tarefa

```bash
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Estudar Go",
    "description": "Aprender conceitos básicos de Go",
    "status": false
  }'
```

### 2. Listar tarefas

```bash
curl http://localhost:8080/tasks
```

### 3. Atualizar uma tarefa

```bash
curl -X PUT http://localhost:8080/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Estudar Go - Completo",
    "description": "Conceitos básicos e avançados de Go",
    "status": true
  }'
```

### 4. Deletar uma tarefa

```bash
curl -X DELETE http://localhost:8080/tasks/1
```

## Melhorias Futuras

### 1. **Validação de Dados**

```go
type Task struct {
    ID          int    `json:"id" validate:"min=1"`
    Title       string `json:"title" validate:"required,min=1,max=100"`
    Description string `json:"description" validate:"max=500"`
    Status      bool   `json:"status"`
}
```

### 2. **Middleware de Logging**

```go
func LoggingMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Printf("%s %s", r.Method, r.URL.Path)
        next.ServeHTTP(w, r)
    })
}
```

### 3. **Tratamento de CORS**

```go
func CORSMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")
        w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
        next.ServeHTTP(w, r)
    })
}
```

### 4. **Paginação**

```go
func (h *TaskHandler) ReadTasksPaginated(w http.ResponseWriter, r *http.Request) {
    page := r.URL.Query().Get("page")
    limit := r.URL.Query().Get("limit")

    // Implementar lógica de paginação
}
```

### 5. **Testes Unitários**

```go
func TestCreateTask(t *testing.T) {
    // Implementar testes
}
```

## Recursos de Aprendizado

### Conceitos de Go Demonstrados

1. **Structs e Tags JSON**
2. **Interfaces HTTP**
3. **Manipulação de Banco de Dados**
4. **Gestão de Dependências com Go Modules**
5. **Tratamento de Erros Idiomático**
6. **Organização de Pacotes**

### Padrões Web

1. **REST APIs**
2. **JSON Serialization/Deserialization**
3. **HTTP Status Codes**
4. **Content-Type Headers**
5. **Path Parameters**
