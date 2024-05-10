# Use the official Node.js image as the base
FROM node:20.13.1-alpine AS build

# Set the working directory
WORKDIR /app
#WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install
RUN npx ngcc --properties es2023 browser module main --first-only --create-ivy-entry-points

# Copy the rest of the app
COPY . .

# Build the app
#RUN ng build --prod
RUN npm run-script deploy-prod

# Use Nginx as the web server
FROM nginx:stable-alpine

# Config nginx
COPY default-nginx.conf /etc/nginx/conf.d/default.conf

# Copy the compiled app from the build stage
COPY --from=build /app/dist/my-project-git-hub-actions/ /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
# CMD ["nginx", "-g", "daemon off;"]