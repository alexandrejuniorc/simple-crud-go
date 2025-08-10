package main

import (
	"log"
	"net/http"

	"github.com/alexandrejuniorc/simple-crud-go/config"
	"github.com/alexandrejuniorc/simple-crud-go/handlers"
	"github.com/alexandrejuniorc/simple-crud-go/models"
	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
)

// É a função chamada quando a aplicação é iniciada
// É o ponto de entrada da aplicação
func main() {
	// Chama a função setupDatabase
	dbConnection := config.SetupDatabase()

	// Chama a função Close para fechar a conexão com o banco de dados
	defer dbConnection.Close()

	// Executa a declaração SQL pra criar a tabela
	_, err := dbConnection.Exec(models.CreateTableSQL)
	if err != nil {
		log.Fatal(err)
	}

	router := mux.NewRouter()

	taskHandler := handlers.NewTaskHandler(dbConnection)

	router.HandleFunc("/tasks", taskHandler.ReadTasks).Methods("GET")
	router.HandleFunc("/tasks", taskHandler.CreateTask).Methods("POST")
	// Path parameter
	// PUT /tasks/123213
	router.HandleFunc("/tasks/{id}", taskHandler.UpdateTask).Methods("PUT")
	// Path parameter
	// DELETE /tasks/123213
	router.HandleFunc("/tasks/{id}", taskHandler.DeleteTask).Methods("DELETE")

	log.Fatal(http.ListenAndServe(":8080", router))
}
