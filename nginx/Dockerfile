# Use the official lightweight Nginx image
FROM nginx:alpine

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy our custom Nginx configuration file to the container
# This will be used by Nginx to proxy requests to the app service
COPY nginx.conf /etc/nginx/conf.d/default.conf