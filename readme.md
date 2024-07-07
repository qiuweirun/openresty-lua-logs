## 已废弃 2024-07-07
## 首先需要开启info级别日志输出，并且lua也会打印前缀不能100%模仿nginx的access日志。如要实现access日志收集的格式还需要调整采集规则，意义不大。
## 建议还是使用ELK / SLS etc 的日志清洗模式，该花的成本还是得花的。

## 构建镜像
docker build -t github.com/qiuweirun/openresty-lua-logs:latest .

## 运行，绑定8080端口
docker run -p 8080:8080 -it --name openresty-lua-log -d github.com/qiuweirun/openresty-lua-logs:latest
