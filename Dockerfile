# # Stage 1: Build the Angular application
# FROM node:20.11.1 AS build

# # Set the working directory inside the container
# WORKDIR /app

# # Copy package.json and package-lock.json
# COPY package*.json ./

# # Install dependencies
# RUN npm ci

# # Install Angular CLI globally
# RUN npm install -g @angular/cli@17.1.2

# # Copy application source code
# COPY . .

# # Build the Angular application in production mode
# RUN npm run build

# # Stage 2: Serve the Angular application with Nginx
# FROM nginx:1.24.0

# # Remove the default Nginx configuration
# RUN rm /etc/nginx/conf.d/default.conf

# # Copy the custom Nginx configuration
# COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# # Copy the built Angular application to the Nginx HTML directory
# COPY --from=build /app/dist/ /usr/share/nginx/html/intakePath

# # COPY --from=build /app/dist/browser/index.html /usr/share/nginx/html

# # COPY --from=build /app/dist/intake-poc /usr/share/nginx/html/intakePath
# # Expose port 80
# EXPOSE 80

# # Start Nginx
# CMD ["nginx", "-g", "daemon off;"]


# Stage 1: Build the Angular application
FROM node:20.11.1 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Install Angular CLI globally
RUN npm install -g @angular/cli@17.1.2

# Copy application source code
COPY . .

# Clean previous builds
RUN rm -rf dist/

# Build the Angular application in production mode
RUN ng build --configuration production --base-href="/intakePath/"

# Stage 2: Serve the Angular application with Nginx
FROM nginx:1.24.0

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy the custom Nginx configuration
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built Angular application to the Nginx HTML directory
COPY --from=build /app/dist/intake-poc/browser /usr/share/nginx/html/intakePath

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]