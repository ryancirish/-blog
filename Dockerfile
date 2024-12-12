# Build stage
FROM alpine:latest as builder

# Install build dependencies
RUN apk add --no-cache bash pandoc

# Create necessary directories
WORKDIR /build

# Copy source files
COPY public/posts posts/
COPY scripts/build.sh ./build.sh

# Make script executable and run build
RUN chmod +x build.sh && \
    ./build.sh

# Final stage
FROM nginx:alpine

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy all static files first
COPY public /usr/share/nginx/html/

# Copy all built files from builder
COPY --from=builder /build /usr/share/nginx/html/

# Set permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html