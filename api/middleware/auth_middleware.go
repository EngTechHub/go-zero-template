package middleware

import (
	"encoding/json"
	"net/http"
	"strings"

	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/rest/httpx"
	errsv2 "gitlab.pjlab.org.cn/cloud/common-go/errs/v2"
)

type AuthMiddleware struct {
}

func NewAuthMiddleware() *AuthMiddleware {
	return &AuthMiddleware{}
}

func (m *AuthMiddleware) Handle(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var err error
		defer func() {
			if err != nil {
				logx.WithContext(r.Context()).Errorf("middleware check error, err: %+v", err)
				httpx.Error(w, err)
			}
		}()

		if strings.Contains(r.RequestURI, "/users/auth") ||
			strings.Contains(r.RequestURI, "/users/info") ||
			strings.Contains(r.RequestURI, "/users/logout") {
			next(w, r)
			return
		}

		userID := r.Header.Get("id")
		if userID == "" {
			logx.WithContext(r.Context()).Infof("request dont have id wrt [%s]", r.RequestURI)
			returnErr := errsv2.NewParamInvalid("参数错误，请求未认证")

			w.WriteHeader(http.StatusUnauthorized)
			resp := map[string]interface{}{
				"code": returnErr.Code,
				"msg":  returnErr.Message,
			}
			bytes, _ := json.Marshal(resp)
			w.Write(bytes)

			return
		}
		next(w, r)
	}
}
