package middleware

import (
	"net/http"

	cm "gitlab.pjlab.org.cn/cloud/common-go/middleware"
)

// MetricsMiddleware is responsible for recording metrics of HTTP requests.
type MetricsMiddleware struct {
	baseMetricsMiddleware *cm.MetricsMiddleware
}

func NewMetricsMiddleware() *MetricsMiddleware {
	m := cm.NewMetricsMiddleware()
	return &MetricsMiddleware{baseMetricsMiddleware: m}
}

func (m *MetricsMiddleware) Handle(next http.HandlerFunc) http.HandlerFunc {
	return m.baseMetricsMiddleware.Handle(next)
}
