package config

import (
	{{.authImport}}
	//{.redisImport}"github.com/zeromicro/go-zero/core/stores/redis"
	"github.com/zeromicro/go-zero/rest"
	"gitlab.pjlab.org.cn/cloud/common-go/lib/nacos"
)

type BootstrapConfig struct {
	Nacos nacos.NacosConfig
}

type Config struct {
	rest.RestConf
	DBSource   string
	//{.redisConfigCode}
}
