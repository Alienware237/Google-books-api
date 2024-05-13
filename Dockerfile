FROM node:18.20.2-alpine as build

RUN mkdir -p /usr/src/app/books-api


COPY package*.json /usr/src/app/books-api

WORKDIR /usr/src/app/books-api

RUN npm ci

RUN npm install -g @angular/cli @angular-devkit/build-angular
RUN npm install bootstrap

COPY . /usr/src/app/books-api

RUN npm run build --prod

FROM nginx:1.15.8-alpine

# copying a custom NGINX configuration file because Kimpa application has custom routing
COPY .docker/nginx.conf /etc/nginx/nginx.conf

COPY --from=build /usr/src/app/books-api/dist /usr/share/nginx/html
