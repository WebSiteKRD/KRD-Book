# Deployment Guide - کتێبخانەی سۆمای ناحوکومی

## 🚀 Deployment Options

### 1. Local Development
```bash
# Setup
npm install
npm start

# یان
python -m http.server 8000
```

### 2. Cloud Hosting

#### **Firebase Hosting**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init

# Deploy
firebase deploy --only hosting

# Access
https://your-project.web.app
```

#### **Vercel**
```bash
# Install
npm i -g vercel

# Deploy
vercel --prod

# Access
https://your-library.vercel.app
```

#### **Netlify**
```bash
# Install
npm i -g netlify-cli

# Deploy
netlify deploy --prod --dir=dist

# Access
https://your-library.netlify.app
```

#### **GitHub Pages**
```bash
# Deploy to gh-pages branch
git subtree push --prefix dist origin gh-pages

# Access
https://username.github.io/repository-name
```

### 3. VPS Hosting

#### **Nginx + Node.js**
```bash
# Build
npm run build

# Server setup
sudo apt update
sudo apt install nginx
sudo ufw allow 'Nginx Full'

# Configure nginx
sudo nano /etc/nginx/sites-available/library
```

#### **Docker**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

```bash
# Build
docker build -t library-system .

# Run
docker run -p 3000:3000 library-system
```

### 4. Database Setup

#### **MongoDB Atlas**
```bash
# Connect to cluster
mongosh "mongodb+srv://username:password@cluster.mongodb.net/library"

# Create indexes
db.books.createIndex({title: "text", author: "text"})
```

#### **PostgreSQL**
```sql
-- Create database
CREATE DATABASE library_system;

-- Create tables
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5. Environment Variables
```bash
# Production
NODE_ENV=production
DATABASE_URL=mongodb+srv://...
JWT_SECRET=your-secret-key
PORT=8000

# Development
NODE_ENV=development
DATABASE_URL=localhost:27017/library
JWT_SECRET=dev-secret
PORT=3000
```

### 6. CI/CD Pipeline

#### **GitHub Actions**
```yaml
name: Deploy to Production
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '18'
      - name: Deploy to Firebase
        run: |
          npm ci
          npm run build
          firebase deploy --only hosting --token ${{ secrets.FIREBASE_TOKEN }}
```

### 7. Monitoring

#### **Application Monitoring**
```javascript
// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Error tracking
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  process.exit(1);
});
```

### 8. Security Headers
```nginx
# Security configuration
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
add_header Strict-Transport-Security "max-age=31531562001; includeSubDomains";
```

### 9. Backup Strategy
```bash
# Automated backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
mongodump --uri="$DATABASE_URL" --archive --gzip --out="backup_$DATE"
aws s3 cp backup_$DATE.gz s3://library-backups/
```

### 10. SSL Certificate
```bash
# Let's Encrypt
sudo apt install certbot
sudo certbot --nginx -d yourdomain.com
sudo systemctl reload nginx

# Auto-renewal
0 12 * * * * /usr/bin/certbot renew --quiet
```

---

**Deployment Guide تەواوە!** 🚀

**بۆ فرمان پێشکەشکردن، پەیوەست بکە بە documentation!** 📚
