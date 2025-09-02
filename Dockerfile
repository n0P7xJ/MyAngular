# ----------------------
# Stage 1: Build Angular
# ----------------------
FROM node:20 AS build
WORKDIR /app

# копіюємо package.json і ставимо залежності
COPY package*.json ./
RUN npm install

# копіюємо увесь код і збираємо Angular у production
COPY . .
RUN npm run build --configuration production

# ----------------------
# Stage 2: Run with Nginx
# ----------------------
FROM nginx:alpine

# копіюємо зібраний dist/ у Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# (опційно) якщо маєш кастомний nginx.conf
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
