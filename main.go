package main

import (
	"log"
	"net/http"

	"github.com/alexandrejuniorc/simple-crud-go/config"
	_ "github.com/lib/pq"
)

// É a função chamada quando a aplicação é iniciada
// É o ponto de entrada da aplicação
func main() {
	// Chama a função setupDatabase
	dbConnection := config.SetupDatabase()

	// Chama a função Close para fechar a conexão com o banco de dados
	defer dbConnection.Close()

	log.Fatal(http.ListenAndServe(":8080", nil))
}
