# 使用官方构建好的Vocechat镜像作为基础，最简单稳定
FROM privoce/vocechat-server:latest

# 安装rclone及其依赖（fuse3用于挂载, curl用于下载安装脚本）
# `apt-get clean && rm -rf /var/lib/apt/lists/*` 用于减小镜像体积
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        fuse3 \
        curl && \
    curl https://rclone.org/install.sh | bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 将我们本地的配置文件和启动脚本复制到镜像中的/app目录
COPY rclone.conf /app/rclone.conf
COPY start.sh /app/start.sh

# 【Windows用户的关键】在Linux构建环境中，赋予启动脚本可执行权限
RUN chmod +x /app/start.sh

# 覆盖原始的启动命令，让容器启动时执行我们的脚本
CMD [ "/app/start.sh" ]