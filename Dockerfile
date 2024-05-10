# Use the official Node.js image as the base
FROM node:14 AS build

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Build the app
#RUN ng build --prod
RUN npm run-script deploy-prod

# Use Nginx as the web server
FROM nginx:alpine

# Copy the compiled app from the build stage
COPY --from=build /usr/src/app/dist/my-angular-app /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]