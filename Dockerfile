FROM node:18-alpine AS builder

WORKDIR /app
COPY container/nodejs/package.json .
RUN npm install --production

FROM node:18-alpine

WORKDIR /app

# 安装必要的运行时依赖
RUN apk add --no-cache curl wget ca-certificates

# 预下载内核以加快启动速度 (amd64)
RUN mkdir -p /root/agsbx && \
    curl -L -o /root/agsbx/xray https://github.com/yonggekkk/argosbx/releases/download/argosbx/xray-amd64 && \
    curl -L -o /root/agsbx/sing-box https://github.com/yonggekkk/argosbx/releases/download/argosbx/sing-box-amd64 && \
    chmod +x /root/agsbx/xray /root/agsbx/sing-box

COPY --from=builder /app/node_modules ./node_modules
COPY container/nodejs/ .
COPY argosbx.sh /root/argosbx.sh

RUN chmod +x start.sh

EXPOSE 8080

CMD ["./start.sh"]
