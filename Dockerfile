# --- 阶段一：从官方镜像中提取程序 ---
FROM privoce/vocechat-server:latest AS extractor


# --- 阶段二：构建我们自己的最终镜像 ---
FROM debian:bullseye-slim

# 安装所有需要的依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        curl \
        fuse3 \
        unzip && \
    curl https://rclone.org/install.sh | sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 【关键步骤】从第一阶段中，复制Vocechat的程序文件
# 根据我们的探查，源文件路径很可能是 /app
COPY --from=extractor /app /usr/local/bin/vocechat-server

# 将我们本地的配置文件和启动脚本复制到镜像中
COPY rclone.conf /app/rclone.conf
COPY start.sh /app/start.sh

# 给予我们的启动脚本可执行权限
RUN chmod +x /app/start.sh

# 设置启动命令，执行我们的脚本
CMD [ "/app/start.sh" ]
