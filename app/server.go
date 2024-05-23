package main

import (
    "fmt"
    "log"
    "net/http"
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
    requestCounter = prometheus.NewCounter(
        prometheus.CounterOpts{
            Name: "http_requests_total",
            Help: "Total number of HTTP requests",
        },
    )
)

func init() {
    prometheus.MustRegister(requestCounter)
}

func requestHandler(w http.ResponseWriter, r *http.Request) {
    requestCounter.Inc()
    fmt.Fprintf(w, "Hello, World!")
}

func main() {
    http.HandleFunc("/", requestHandler)
    http.Handle("/metrics", promhttp.Handler())

    log.Println("Starting server on :8080")
    if err := http.ListenAndServe(":8080", nil); err != nil {
        log.Fatalf("Could not start server: %s\n", err)
    }
}
