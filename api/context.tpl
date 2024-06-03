package svc

import (
	"context"
	"fmt"
	"os"
	"time"

	{{.configImport}}

	"github.com/redis/go-redis/v9"
	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/logx"
	zero_redis "github.com/zeromicro/go-zero/core/stores/redis"
	"github.com/zeromicro/go-zero/rest"
	"gitlab.pjlab.org.cn/cloud/common-go/lib/nacos"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

type ServiceContext struct {
	Config {{.config}}
	DB         *gorm.DB
	//{.ctxRedisDef}
	{{.middleware}}
}

func NewServiceContext(configFile string) *ServiceContext {
	ctx := &ServiceContext{}

	var bootstrapCfg config.BootstrapConfig
	conf.MustLoad(configFile, &bootstrapCfg)

	// load nacos config
	err := nacos.LoadNacosConfig(context.Background(), ctx, bootstrapCfg.Nacos)
	if err != nil {
		panic(err)
	}
	c := ctx.Config

	// init db
	db, err := gorm.Open(mysql.Open(c.DBSource), &gorm.Config{
		TranslateError: true,
	})
	if err != nil {
		panic(err)
	}
	ctx.DB = db

	//{.initRedisCode}

	// init middlewares
	ctx.Auth = middleware.NewAuthMiddleware().Handle
	ctx.Metrics = middleware.NewMetricsMiddleware().Handle

	return ctx
}

// SetConfig implemented to dynamic setup nacos config
func (c *ServiceContext) SetConfig(content string) error {
	newConf := config.Config{}
	err := conf.LoadFromYamlBytes([]byte(content), &newConf)
	if err != nil {
		fmt.Printf("Failed to parse nacos config: %v", err)
		return err
	}
	c.Config = newConf

	return nil
}
