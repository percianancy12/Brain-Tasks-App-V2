FROM nginx:alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom config (must be in repo root)
COPY nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html
COPY dist/ .

EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]