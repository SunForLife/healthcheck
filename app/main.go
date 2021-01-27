package main

import (
	"flag"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/SunForLife/healthcheck/app/lib"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	port := flag.Int("port", 7171, "port")
	flag.Parse()

	// Db initialization part.
	dsn := os.Getenv("DSN")
	time.Sleep(5 * time.Second)
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect database", err)
	}
	dbSQL, ok := db.DB()
	if ok != nil {
		defer dbSQL.Close()
	}
	db.AutoMigrate(&lib.ServiceStatus{})

	db.Delete(&lib.ServiceStatus{}, "Ip = ?", os.Getenv("APP_IP"))
	db.Create(&lib.ServiceStatus{os.Getenv("APP_IP"), lib.StatusAvailable})
	// for {
	// 	var status lib.ServiceStatus
	// 	if err := db.Where("Ip = ?", "kek").First(&status).Error; err != nil {
	// 		break
	// 	}

	// 	db.Delete(&status, "Ip = ?", "kek")
	// }

	handler := lib.Handler{Db: db}

	// Http server initialization part.
	http.HandleFunc("/healthcheck", handler.HandlerHealthcheck)

	log.Printf("App started on port: %d\n", *port)
	log.Fatal(http.ListenAndServe("0.0.0.0:"+strconv.Itoa(*port), nil))
}
