# --- 阶段一：从官方镜像中提取程序 ---
# 我们给这个阶段起个名字叫 extractor
FROM privoce/vocechat-server:latest AS extractor


# --- 阶段二：构建我们自己的最终镜像 ---
# 我们选择一个功能齐全的 Debian 系统作为基础
FROM debian:bullseye-slim

# 在我们自己的系统里，使用 apt-get 安装所有需要的依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        curl \
        fuse3 \
        unzip && \
    curl https://rclone.org/install.sh | sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 【关键步骤】从第一阶段(extractor)中，将Vocechat的程序文件复制到我们当前的系统中
# 源镜像中的正确路径是 /vocechat-server
COPY --from=extractor /vocechat-server /usr/local/bin/vocechat-server

# 将我们本地的配置文件和启动脚本复制到镜像中
COPY rclone.conf /app/rclone.conf
COPY start.sh /app/start.sh

# 给予我们的启动脚本可执行权限
RUN chmod +x /app/start.sh

# 设置启动命令，执行我们的脚本
CMD [ "/app/start.sh" ]
