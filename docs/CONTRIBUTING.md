# Guia de Contribuição

## Como Contribuir

Obrigado por seu interesse em contribuir com o projeto Simple CRUD Go! Este guia irá ajudá-lo a configurar seu ambiente de desenvolvimento e fazer suas primeiras contribuições.

## 🚀 Configuração do Ambiente

### Pré-requisitos

- Go 1.24.5+
- Docker e Docker Compose
- Git
- Editor de código (VS Code recomendado)

### Setup Inicial

1. **Fork e Clone**

```bash
# Fork o repositório no GitHub
# Clone seu fork
git clone https://github.com/SEU_USUARIO/simple-crud-go.git
cd simple-crud-go

# Adicione o repositório original como upstream
git remote add upstream https://github.com/alexandrejuniorc/simple-crud-go.git
```

2. **Configuração Automática**

```bash
# Use o Makefile para configurar tudo automaticamente
make setup
```

3. **Configuração Manual** (alternativa)

```bash
# Copie as variáveis de ambiente
cp .env.example .env

# Instale dependências
go mod download

# Inicie o PostgreSQL
docker-compose up -d

# Execute a aplicação
go run main.go
```

## 📁 Estrutura de Desenvolvimento

### Comandos Úteis (Makefile)

```bash
make help          # Lista todos os comandos disponíveis
make dev           # Inicia ambiente completo de desenvolvimento
make build         # Compila a aplicação
make test          # Executa testes
make clean         # Limpa arquivos compilados
make docker-up     # Inicia PostgreSQL
make docker-down   # Para PostgreSQL
make fmt           # Formata código Go
make lint          # Executa linter (requer golangci-lint)
```

### Workflow de Desenvolvimento

1. **Crie uma branch para sua feature**

```bash
git checkout -b feature/nome-da-feature
```

2. **Faça suas alterações**

- Siga as convenções de código Go
- Adicione comentários em português (projeto de estudo)
- Mantenha funções pequenas e bem definidas

3. **Teste suas alterações**

```bash
make test
make fmt
make build
```

4. **Commit suas mudanças**

```bash
git add .
git commit -m "feat: adiciona nova funcionalidade X"
```

5. **Push e Pull Request**

```bash
git push origin feature/nome-da-feature
# Abra um Pull Request no GitHub
```

## 🧪 Testando

### Executando Testes

```bash
# Testes básicos
go test ./...

# Testes com verbosidade
go test -v ./...

# Testes com cobertura
make test-coverage
```

### Testando a API

Use o arquivo `client.http` para testar os endpoints:

1. Instale a extensão "REST Client" no VS Code
2. Abra o arquivo `client.http`
3. Clique em "Send Request" acima de cada requisição

## 📝 Convenções de Código

### Nomenclatura

- **Funções**: PascalCase para funções exportadas, camelCase para internas
- **Variáveis**: camelCase
- **Constantes**: UPPER_CASE ou PascalCase
- **Arquivos**: snake_case.go

### Comentários

```go
// Função que configura a conexão com o banco de dados
// Retorna uma instância *sql.DB configurada
func SetupDatabase() *sql.DB {
    // implementação...
}
```

### Tratamento de Erros

```go
// Sempre verifique erros
result, err := db.Exec(query)
if err != nil {
    http.Error(w, err.Error(), http.StatusInternalServerError)
    return
}

// Use mensagens de erro descritivas
if rowsAffected == 0 {
    http.Error(w, "Nenhuma tarefa encontrada com este ID", http.StatusNotFound)
    return
}
```

## 🎯 Tipos de Contribuições

### 1. **Correções de Bugs**

- Identifique o problema
- Crie testes que reproduzam o bug
- Implemente a correção
- Verifique se todos os testes passam

### 2. **Novas Funcionalidades**

Ideias de features para implementar:

#### 🟢 Iniciante

- [ ] Adicionar validação de campos obrigatórios
- [ ] Implementar logging de requisições
- [ ] Adicionar endpoint de health check (`/health`)
- [ ] Implementar middleware de CORS

#### 🟡 Intermediário

- [ ] Adicionar paginação na listagem de tarefas
- [ ] Implementar filtros (por status, título)
- [ ] Adicionar timestamps (created_at, updated_at)
- [ ] Implementar soft delete

#### 🔴 Avançado

- [ ] Autenticação JWT
- [ ] Rate limiting
- [ ] Cache com Redis
- [ ] Documentação Swagger/OpenAPI
- [ ] Migrations de banco de dados
- [ ] Dockerização da aplicação

### 3. **Melhorias de Documentação**

- Correções de typos
- Exemplos adicionais
- Traduções
- Diagramas e imagens explicativas

### 4. **Testes**

- Testes unitários para handlers
- Testes de integração
- Testes de performance
- Mocks para banco de dados

## 📊 Exemplo de Implementação: Validação

### Antes (atual)

```go
func (h *TaskHandler) CreateTask(w http.ResponseWriter, r *http.Request) {
    var task models.Task

    err := json.NewDecoder(r.Body).Decode(&task)
    if err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }

    // Salva direto no banco...
}
```

### Depois (com validação)

```go
func (h *TaskHandler) CreateTask(w http.ResponseWriter, r *http.Request) {
    var task models.Task

    err := json.NewDecoder(r.Body).Decode(&task)
    if err != nil {
        http.Error(w, "JSON inválido", http.StatusBadRequest)
        return
    }

    // Validação
    if task.Title == "" {
        http.Error(w, "Título é obrigatório", http.StatusBadRequest)
        return
    }

    if len(task.Title) > 100 {
        http.Error(w, "Título não pode ter mais de 100 caracteres", http.StatusBadRequest)
        return
    }

    // Salva no banco...
}
```

## 🐛 Reportando Bugs

### Template de Issue

```markdown
**Descrição do Bug**
Descrição clara e concisa do problema.

**Como Reproduzir**

1. Execute o comando X
2. Faça a requisição Y
3. Observe o erro Z

**Comportamento Esperado**
O que deveria acontecer.

**Comportamento Atual**
O que está acontecendo.

**Ambiente**

- OS: [Linux/macOS/Windows]
- Go version: [1.24.5]
- Docker version: [20.10.x]

**Logs**
```

Cole aqui os logs relevantes

```

```

## 💡 Sugestões de Features

### Template de Feature Request

```markdown
**Problema/Necessidade**
Qual problema esta feature resolve?

**Solução Proposta**
Descrição da funcionalidade.

**Alternativas Consideradas**
Outras formas de resolver o problema.

**Contexto Adicional**
Screenshots, links, etc.
```

## 🔄 Processo de Review

### O que verificamos:

1. **Funcionalidade**: O código faz o que deveria fazer?
2. **Qualidade**: Segue as convenções de Go?
3. **Testes**: Inclui testes adequados?
4. **Documentação**: Está bem documentado?
5. **Performance**: Não introduz gargalos?

### Como acelerar o review:

- Faça commits pequenos e focados
- Escreva mensagens de commit descritivas
- Adicione testes para suas mudanças
- Atualize a documentação se necessário

## 📚 Recursos de Aprendizado

### Go

- [Tour of Go](https://tour.golang.org/)
- [Effective Go](https://golang.org/doc/effective_go.html)
- [Go by Example](https://gobyexample.com/)

### APIs REST

- [REST API Tutorial](https://restfulapi.net/)
- [HTTP Status Codes](https://httpstatuses.com/)

### PostgreSQL

- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)

### Docker

- [Docker Tutorial](https://docker-curriculum.com/)

## 🤝 Código de Conduta

- Seja respeitoso e inclusivo
- Aceite críticas construtivas
- Foque no que é melhor para o projeto
- Seja paciente com iniciantes
- Mantenha discussões técnicas focadas

## 📞 Contato

- **Issues**: Para bugs e feature requests
- **Discussions**: Para perguntas gerais
- **Email**: [seu-email@exemplo.com]

---

Obrigado por contribuir com o projeto! 🎉
