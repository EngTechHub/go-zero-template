Nacos:
  Endpoint: "{{.nacosHost}}"
  Namespace: "{{.svcName}}"
  DataId: "{{.svcName}}-local"
  Group: "cloud-dev"

## TODO: 替换为具体对应的服务名，按目前的命名规则

## uncomment following lines to put config in nacos
#Name: {yourAppName}
#Host: 0.0.0.0
#Port: 8888
#DBSource: "user:password@tcp(host:3306)/db?charset=utf8mb4&parseTime=true&loc=Local"
#MaxBytes: 10485760
#Timeout: 30000
#Prometheus:
#  Host: 0.0.0.0
#  Port: 9091
#  Path: /metrics