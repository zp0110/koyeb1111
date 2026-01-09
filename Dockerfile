FROM node:18-alpine AS builder

WORKDIR /app
COPY container/nodejs/package.json .
RUN npm install --production

FROM node:18-alpine

WORKDIR /app

# 设置环境变量，确保应用监听 3000 端口（Koyeb 默认）
ENV PORT=1111
ENV NODE_ENV=production

# 安装必要的运行时依赖
RUN apk add --no-cache curl wget ca-certificates bash

# 预下载内核以加快启动速度 (amd64)
RUN mkdir -p /root/agsbx && \
    curl -L -o /root/agsbx/xray https://github.com/yonggekkk/argosbx/releases/download/argosbx/xray-amd64 && \
    curl -L -o /root/agsbx/sing-box https://github.com/yonggekkk/argosbx/releases/download/argosbx/sing-box-amd64 && \
    chmod +x /root/agsbx/xray /root/agsbx/sing-box

COPY --from=builder /app/node_modules ./node_modules
COPY container/nodejs/ .
COPY argosbx.sh /root/argosbx.sh

# 确保脚本具有执行权限
RUN chmod +x start.sh

# 暴露 3000 端口
EXPOSE 1111

# 启动应用
CMD ["node", "index.js"]
