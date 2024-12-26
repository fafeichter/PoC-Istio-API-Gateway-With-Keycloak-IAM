# Step 1: Build the Angular app
FROM node:22.10.0 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

# Step 2: Serve the app with Nginx
FROM nginx:1.27.2-alpine
COPY --from=build /app/dist/api-gateway-angular-spa/browser /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]