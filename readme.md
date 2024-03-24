## 构建镜像
docker build -t github.com/qiuweirun/openresty-lua-logs:latest .

## 运行，绑定8080端口
docker run -p 8080:8080 -it --name openresty-lua-log -d github.com/qiuweirun/openresty-lua-logs:latest