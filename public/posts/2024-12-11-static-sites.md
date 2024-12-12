# Static Sites on Fly.io

Static sites are a perfect entry point into the world of Fly.io deployments. They're fast, secure, and incredibly cost-effective. Let's explore why Fly.io is an excellent choice for hosting your static content.

## Why Host Static Sites on Fly.io?

1. **Global CDN**
   - Your content is automatically distributed worldwide
   - Users access your site from the nearest edge location
   - Incredibly fast load times for all visitors

2. **Simple Deployment**
   - Push updates with a single command
   - Zero-downtime deployments
   - Easy rollbacks if needed

3. **Cost-Effective**
   - Free tier available for small sites
   - Pay only for what you use
   - Scale automatically based on demand

## Setting Up Your Static Site

The basic setup is straightforward:

1. Create a `Dockerfile` for your static content:
   ```dockerfile
   FROM nginx:alpine
   COPY . /usr/share/nginx/html
   ```

2. Configure your `fly.toml`:
   ```toml
   app = "my-static-site"
   
   [http_service]
     internal_port = 80
     force_https = true
   ```

## Optimization Tips

- Enable gzip compression in Nginx
- Set appropriate cache headers
- Optimize images and assets

## Real-World Examples

Many developers use Fly.io for:
- Personal blogs
- Documentation sites
- Portfolio websites
- Landing pages

The combination of performance and simplicity makes it an excellent choice for any static content!
