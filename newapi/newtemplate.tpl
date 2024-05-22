syntax = "v1"

type Request {
  Name string `path:"name,options=you|me"`
}

type Response {
  Message string `json:"message"`
}

@server (
	prefix: /api/v1
	group:  demo
	middleware: Auth, Metrics
)
service {{.name}}-api {
  @handler {{.handler}}Handler
  get /from/:name(Request) returns (Response)
}
