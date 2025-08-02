#!/bin/bash

# 打印日志，方便调试
echo "--- Vocechat startup script initiated ---"

# 创建Vocechat需要的数据目录作为挂载点
mkdir -p /home/vocechat-server/data
echo "Mount point created."

# 以后台进程方式启动rclone，将R2存储桶挂载到数据目录
# --daemon: 后台运行
# --allow-other: 允许容器内的vocechat程序访问挂载点
# --vfs-cache-mode full: 开启缓存以提升性能
rclone mount s3:vocechat /home/vocechat-server/data \
    --config /app/rclone.conf \
    --daemon \
    --allow-other \
    --vfs-cache-mode full &

echo "Rclone mount command issued. Waiting for mount..."
# 等待几秒钟，确保挂载操作有足够时间完成
sleep 5
echo "Waited 5 seconds."

# 检查挂载是否成功（可选，但有助于调试）
if mount | grep -q "/home/vocechat-server/data"; then
  echo "--- Mount successful. Starting Vocechat server. ---"
else
  echo "--- Mount FAILED! Check rclone logs or configurations. ---"
fi

# 最后，执行Vocechat服务器的原始启动命令
exec /usr/local/bin/vocechat-server