FROM node:18-alpine

WORKDIR /app

COPY container/nodejs/package.json .
RUN npm install

COPY container/nodejs/ .

RUN chmod +x start.sh

EXPOSE 8080

CMD ["./start.sh"]
