FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build -- --configuration production

FROM nginx:alpine
# >>> ВАЖЛИВО: скопіюй саме підпапку browser (або правильну папку з dist)
COPY --from=build /app/dist/MyAngular/browser /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
