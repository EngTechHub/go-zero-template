package main

import (
	"flag"
	"fmt"
	"os"

	{{.importPackages}}
)


func main() {
	flag.Parse()

	// load local config
	env := os.Getenv("env")
	if env == "" {
		// 环境变量为空则用local替代
		env = "local"
	}
	configFile := fmt.Sprintf("etc/{{.serviceName}}-%s.yaml", env)
	fmt.Printf("config file path: %s\n", configFile)

	ctx := svc.NewServiceContext(configFile)
	server := rest.MustNewServer(ctx.Config.RestConf)
	defer server.Stop()

	handler.RegisterHandlers(server, ctx)

	fmt.Printf("Starting server at %s:%d...\n", ctx.Config.Host, ctx.Config.Port)
	server.Start()
}
