package middleware

import (
	"net/http"

	cm "gitlab.pjlab.org.cn/cloud/common-go/middleware"
)

type AuthMiddleware struct {
}

func NewAuthMiddleware() *AuthMiddleware {
	return &AuthMiddleware{}
}

func (m *AuthMiddleware) Handle(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		cm.AuthHandler(next, w, r)
	}
}
