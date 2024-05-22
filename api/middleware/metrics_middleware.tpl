package middleware

import (
	"bytes"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
	"time"

	"{.svcName}/internal/response"

	"github.com/prometheus/client_golang/prometheus"
)

// MetricsMiddleware is responsible for recording metrics of HTTP requests.
type MetricsMiddleware struct {
	requestDuration   *prometheus.HistogramVec
	requestSizeBytes  *prometheus.HistogramVec
	responseSizeBytes *prometheus.HistogramVec
	businessErrors    *prometheus.CounterVec
}

func NewMetricsMiddleware() *MetricsMiddleware {
	m := &MetricsMiddleware{
		requestDuration: prometheus.NewHistogramVec(
			prometheus.HistogramOpts{
				Name:    "http_request_duration_milliseconds",
				Help:    "HTTP request duration in milliseconds.",
				Buckets: []float64{10, 50, 100, 500, 1000, 2000, 3000, 4000, 5000, 10000},
			},
			[]string{"method", "endpoint", "status"},
		),
		requestSizeBytes: prometheus.NewHistogramVec(
			prometheus.HistogramOpts{
				Name:    "http_request_size_bytes",
				Help:    "HTTP request size distribution in bytes.",
				Buckets: []float64{100, 200, 500, 1000, 5000, 10000}, // Custom buckets for request size
			},
			[]string{"method", "endpoint"},
		),
		responseSizeBytes: prometheus.NewHistogramVec(
			prometheus.HistogramOpts{
				Name:    "http_response_size_bytes",
				Help:    "HTTP response size distribution in bytes.",
				Buckets: []float64{100, 200, 500, 1000, 5000, 10000}, // Custom buckets for request size
			},
			[]string{"method", "endpoint"},
		),
		businessErrors: prometheus.NewCounterVec(
			prometheus.CounterOpts{
				Name: "http_business_errors_total",
				Help: "Total number of HTTP business errors.",
			},
			[]string{"err_code", "err_msg"},
		),
	}

	prometheus.MustRegister(
		m.requestDuration,
		m.requestSizeBytes,
		m.responseSizeBytes,
		m.businessErrors,
	)

	return m
}

func (m *MetricsMiddleware) Handle(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()

		// Wrap the response writer to capture response size, status code, and body
		rw := &ResponseWriterWithSizeStatusAndBody{
			ResponseWriter: w,
			status:         http.StatusOK, // default status code
			Body:           &bytes.Buffer{},
		}

		// Pass through to the next handler
		next(rw, r)

		// Calculate duration and convert to milliseconds
		duration := time.Since(start).Milliseconds()

		// Get method and endpoint from the request
		method := r.Method
		endpoint := trimIDsFromPath(r.URL.Path)

		// Handle business errors
		responseBody := rw.Body.Bytes()
		var resp response.Body
		_ = json.Unmarshal(responseBody, &resp)
		// Check if Code field is non-zero
		if resp.Code != 0 {
			m.businessErrors.WithLabelValues(strconv.Itoa(resp.Code), resp.Msg).Inc()
		}

		// Record duration to Prometheus metric
		m.requestDuration.WithLabelValues(method, endpoint, strconv.Itoa(rw.status)).Observe(float64(duration))

		// Record request size
		requestSize := r.ContentLength
		m.requestSizeBytes.WithLabelValues(method, endpoint).Observe(float64(requestSize))

		// Record response size
		m.responseSizeBytes.WithLabelValues(method, endpoint).Observe(float64(rw.size))
	}
}

// ResponseWriterWithSizeStatusAndBody is a wrapper around http.ResponseWriter that captures the response size, status code, and body.
type ResponseWriterWithSizeStatusAndBody struct {
	http.ResponseWriter
	status int
	size   int64
	Body   *bytes.Buffer
}

func (rw *ResponseWriterWithSizeStatusAndBody) Write(b []byte) (int, error) {
	size, err := rw.ResponseWriter.Write(b)
	rw.size += int64(size)
	rw.Body.Write(b) // Write the response body to the buffer
	return size, err
}

func (rw *ResponseWriterWithSizeStatusAndBody) WriteHeader(code int) {
	rw.status = code
	rw.ResponseWriter.WriteHeader(code)
}

// trimIDsFromPath removes segments containing only digits from the given path and replaces them with a placeholder ("ID"), then returns the modified path.
func trimIDsFromPath(path string) string {
	const placeholder = "ID"
	segments := strings.Split(path, "/")
	for i, segment := range segments {
		// Check if the segment contains only digits.
		if _, err := strconv.Atoi(segment); err == nil {
			segments[i] = placeholder
		}
	}
	return strings.Join(segments, "/")
}
