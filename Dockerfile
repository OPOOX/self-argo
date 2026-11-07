FROM node:alpine3.22

WORKDIR /tmp

COPY index.js index.html package.json ./

EXPOSE 3000/tcp

# 安装系统依赖
RUN apk add --no-cache \
    openssl \
    curl \
    ca-certificates \
    gcompat \
    iproute2 \
    coreutils \
    bash

# 安装 Node.js 依赖，输出详细日志
RUN npm install --omit=dev --loglevel=verbose

# 确认两个依赖均已安装，缺少时直接在构建阶段报错
RUN node -e "require('axios'); require('adm-zip'); console.log('Dependencies OK')"

CMD ["node", "index.js"]
