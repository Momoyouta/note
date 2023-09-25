# 基础镜像
FROM jdk20:latest
# 设定时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# 拷贝jar包
COPY sky-service-1.0-SNAPSHOT.jar /app.jar
# 入口
ENTRYPOINT ["java", "-jar", "/app.jar"]

# server {
#         listen       18081;
#         # 指定前端项目所在的位置
#         location / {
#             root html/hmall-admin;
#         }

#         error_page   500 502 503 504  /50x.html;
#         location = /50x.html {
#             root   html;
#         }
#         location /api {
#             rewrite /api/(.*)  /$1 break;
#             proxy_pass http://hmall:8080;
#         }
#     }