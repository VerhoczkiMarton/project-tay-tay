FROM node:20 as base

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm ci --silent

COPY . .

FROM base as development

EXPOSE 5173

FROM base as production-builder

RUN npm run build

FROM nginx:latest as production

COPY --from=production-builder /usr/src/app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 5173
