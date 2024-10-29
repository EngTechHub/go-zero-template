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

	
	//{.ssoCode}SSO struct {
	//{.ssoCode}	Address          string `json:"Address"`
	//{.ssoCode}	GetJwtPath       string `json:"GetJwtPath"`
	//{.ssoCode}	GetUserInfoPath  string `json:"GetUserInfoPath"`
	//{.ssoCode}	GetPublicKeyPath string `json:"GetPublicKeyPath"`
	//{.ssoCode}	LogoutPath       string `json:"LogoutPath"`
	//{.ssoCode}	ClientID         string `json:"ClientId"`
	//{.ssoCode}	ClientSecret     string `json:"ClientSecret"`
	//{.ssoCode}}

	//{.asyncInfer}AsynInferConfig struct {
	//{.asyncInfer}    Endpoint string
	//{.asyncInfer}}
}
