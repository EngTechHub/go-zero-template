package response

import (
	"context"
	"net/http"

	errsv2 "gitlab.pjlab.org.cn/cloud/common-go/errs/v2"

	"github.com/zeromicro/go-zero/core/trace"
	"github.com/zeromicro/go-zero/rest/httpx"
)

type Body struct {
	Code    int         `json:"code"`
	Msg     string      `json:"msg"`
	TraceID string      `json:"trace_id"`
	Data    interface{} `json:"data,omitempty"`
}

func Response(ctx context.Context, w http.ResponseWriter, resp interface{}, err error) {
	var body Body
	if err != nil {
		errcode := errsv2.GetCode(err)
		body.Code = errcode.Code
		body.Msg = errcode.Message
		body.TraceID = trace.TraceIDFromContext(ctx)
	} else {
		body.Code = 0
		body.Msg = "success"
		body.TraceID = trace.TraceIDFromContext(ctx)
		body.Data = resp
	}
	httpx.OkJsonCtx(ctx, w, body)
}
