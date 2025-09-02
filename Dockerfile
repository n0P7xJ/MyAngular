# Stage 1: build
FROM node:20 AS build
WORKDIR /app

# ставимо залежності
COPY package*.json ./
RUN npm ci

# копіюємо код і збираємо
COPY . .
# ПЕРЕДАЄМО параметр після --
RUN npm run build -- --configuration production

# Stage 2: serve
FROM nginx:alpine
# скопіюємо все, що в dist (покриє і dist/<app>/ або dist/<app>/browser)
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
