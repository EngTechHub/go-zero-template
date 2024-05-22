package {{.pkgName}}

import (
	{{.imports}}

	errsv2 "gitlab.pjlab.org.cn/cloud/common-go/errs/v2"
)

type {{.logic}} struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func New{{.logic}}(ctx context.Context, svcCtx *svc.ServiceContext) *{{.logic}} {
	return &{{.logic}}{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *{{.logic}}) {{.function}}({{.request}}) {{.responseType}} {
	// todo: add your logic here and delete this line

	// 正确的响应示例：无须手动填写code, msg, trace_id，仅填写data内部字段即可
	resp = &types.Response{
		Message: "hello world",
	}

	// 出现错误的响应示例：使用errsv2库，返回通用的错误码（可自定义message），或者自定义错误码
	// !!无须手动把err置为nil!!
	err = errsv2.NewParamInvalid("demo")

	{{.returnString}}
}
