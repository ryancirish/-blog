# Optimizing Nginx for Static Content

When hosting static sites on Fly.io with Nginx, proper configuration can significantly improve performance. Here's your guide to optimizing Nginx for static content delivery.

## Key Configuration Areas

### 1. Compression

Enable gzip compression to reduce bandwidth usage:

```nginx
gzip on;
gzip_types text/plain text/css application/javascript application/json;
gzip_min_length 1000;
gzip_comp_level 6;
```

### 2. Caching Headers

Implement proper caching for static assets:

```nginx
location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg)$ {
    expires 30d;
    add_header Cache-Control "public, no-transform";
}
```

### 3. Security Headers

Add security headers to protect your site:

```nginx
add_header X-Frame-Options "SAMEORIGIN";
add_header X-XSS-Protection "1; mode=block";
add_header X-Content-Type-Options "nosniff";
```

## Performance Tips

1. **Keep Connections Alive**
   - Enable keepalive connections
   - Set appropriate timeouts
   - Monitor connection counts

2. **Worker Processes**
   - Configure worker_processes based on CPU cores
   - Adjust worker_connections for your traffic

## Monitoring

Remember to monitor your Nginx performance using:
- Access logs
- Error logs
- Metrics collection

These optimizations will help ensure your static content is served as efficiently as possible!