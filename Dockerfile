# 使用官方构建好的Vocechat镜像作为基础
FROM privoce/vocechat-server:latest

# 使用apk（Alpine Linux的包管理器）来安装rclone的依赖
# --no-cache 标志可以保持镜像体积小
# 新增了 bash，因为rclone安装脚本内部可能需要它
RUN apk add --no-cache \
        bash \
        curl \
        fuse3 \
        unzip && \
    curl https://rclone.org/install.sh | sh

# 将我们本地的配置文件和启动脚本复制到镜像中
COPY rclone.conf /app/rclone.conf
COPY start.sh /app/start.sh

# 给予我们的启动脚本可执行权限
RUN chmod +x /app/start.sh

# 覆盖原始的启动命令，让容器启动时执行我们的脚本
CMD [ "/app/start.sh" ]
