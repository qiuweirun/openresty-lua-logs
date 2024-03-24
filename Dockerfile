FROM bitnami/openresty:1.25.3-1

# nginx配置文件拷贝
COPY conf/ /opt/bitnami/openresty/nginx/conf/
COPY html/ /app/
COPY lua/ /opt/bitnami/openresty/nginx/lua/