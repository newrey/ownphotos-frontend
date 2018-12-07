FROM node:8-alpine

EXPOSE 3000

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk add git
RUN apk add git

COPY . /code/ownphotos-frontend
RUN mv /code/ownphotos-frontend/src/api_client/apiClientDeploy.js /code/ownphotos-frontend/src/api_client/apiClient.js

RUN npm config set registry https://registry.npm.taobao.org

WORKDIR /code/ownphotos-frontend

RUN npm install && npm install -g serve && npm cache clean --force
ENV _DEAFULT_BACKEND_URL=http://192.168.99.100:8000
RUN sed -i -e "s|changeme|$_DEAFULT_BACKEND_URL|g" /code/ownphotos-frontend/src/api_client/apiClient.js
RUN npm run build

CMD [ "serve","-s","build" ]
# ENTRYPOINT ./code/ownphotos-frontend/entrypoint.sh
# CMD ["tail","-f","/dev/null"]