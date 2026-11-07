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

RUN npm install --omit=dev --loglevel=verbose \
      --logs-dir=/tmp/npm-build-logs \
    || { \
      status=$?; \
      echo "===== npm debug logs ====="; \
      cat /tmp/npm-build-logs/* 2>/dev/null || true; \
      exit "$status"; \
    }

# 确认两个依赖均已安装，缺少时直接在构建阶段报错
RUN node -e "require('axios'); require('adm-zip'); console.log('Dependencies OK')"

CMD ["node", "index.js"]
