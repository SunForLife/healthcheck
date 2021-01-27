package lib

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"gorm.io/gorm"
)

// Handler for HTTP requests.
type Handler struct {
	Db *gorm.DB
}

// HandlerHealthcheck handels /healthcheck requests.
func (h *Handler) HandlerHealthcheck(w http.ResponseWriter, r *http.Request) {
	log.Println("Got healthcheck request", os.Getenv("APP_ID"))

	statuses := []ServiceStatus{}
	h.Db.Limit(20).Find(&statuses)
	for _, status := range statuses {
		fmt.Println(status.IP, status.Status)
	}

	json, err := json.Marshal(statuses)
	if err != nil {
		errorRequest(w, err)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintln(w, string(json))
}

func errorRequest(w http.ResponseWriter, err error) {
	w.WriteHeader(http.StatusInternalServerError)
	writeErrorBody(w, err)
}

func writeErrorBody(w http.ResponseWriter, err interface{}) {
	var sErr string
	if err != nil {
		sErr = fmt.Sprint("error: ", err)
	} else {
		sErr = fmt.Sprint("Error while handling request.")
	}
	log.Println(sErr)
	w.Write([]byte(sErr))
}
