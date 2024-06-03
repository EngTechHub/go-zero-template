package config

import (
	{{.authImport}}
	//{.redisCode}"github.com/zeromicro/go-zero/core/stores/redis"
	"gitlab.pjlab.org.cn/cloud/common-go/lib/nacos"
)

type BootstrapConfig struct {
	Nacos nacos.NacosConfig
}

type Config struct {
	rest.RestConf
	DBSource   string
	//{.redisCode}Redis    redis.RedisConf

	//{.asyncInfer}AsynInferConfig struct {
	//{.asyncInfer}    Endpoint string
	//{.asyncInfer}}
}
