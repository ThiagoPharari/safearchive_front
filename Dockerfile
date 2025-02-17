# Etapa de construcción
FROM node:20 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install --frozen-lockfile --production

COPY . .
RUN NODE_OPTIONS="--max-old-space-size=1536" npm run build

# Etapa final: una imagen más ligera para servir la app
FROM node:20-alpine

RUN npm install -g serve

WORKDIR /app

COPY --from=build /app/build ./build

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
