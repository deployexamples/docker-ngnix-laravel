# apache-laravel

Setup Laravel with Apache server and MySQL database on your domain.

## Setup Laravel

### Step 1: Clone the Laravel Repository

Clone your Laravel repository:

```bash
git clone --depth 1 <repository_url> <destination_directory>
```

-   <repository_url>: The URL of your Laravel repository.
-   <destination_directory>: Directory where you want to clone the repository.

### Step 2: Install PHP and Required Extensions

Install PHP and necessary extensions:

```bash
sudo apt update
sudo apt install php php-cli php-mysql libapache2-mod-php php-xml php-mbstring
```

## Manual Deployment

### Step 1: Pull the Latest Changes

Navigate to your Laravel project directory and pull the latest changes:

```bash
cd /path/to/your/apache-laravel/
git pull origin main
```

Adjust the branch name (main in this case) as needed.

### Step 2: Run Docker Compose

If you're using Docker Compose, restart the containers:

```bash
docker compose down # Stop the containers if they're running
docker compose build
docker compose up -d
```

### Step 3: Go to Docker Container

If you're using Docker, you might need to go into the container to run commands:

```bash
docker exec -it dockerApp bash
```

### Step 4: Clear Laravel Cache

Clear the Laravel cache to apply any configuration changes:

```bash
composer update
php artisan config:cache
php artisan route:cache
php artisan view:clear
```

### Step 3: Migrate Database

If you've made changes to the database schema, run the migration:

```bash
php artisan migrate
```

### Step 4: Verify Changes

After reloading Apache and clearing the Laravel cache, visit your application’s URL to verify that the changes have been applied correctly.

## CI/CD Pipeline Deployment

```yaml
name: 🚀 Deploy Docker Laravel
on:
    push:
        branches:
            - main

jobs:
    web-deploy:
        name: 🎉 Deploy
        runs-on: ubuntu-latest

        steps:
            - name: Checkout code
              uses: actions/checkout@v2

            - name: Set up PHP
              uses: shivammathur/setup-php@v2
              with:
                  php-version: "8.1.2"

            - name: Install Composer dependencies
              run: composer install --no-interaction --no-suggest

            - name: Set up SSH
              uses: webfactory/ssh-agent@v0.7.0
              with:
                  ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

            - name: Deploy to Azure VM
              run: |
                  ssh -o StrictHostKeyChecking=no azureuser@20.51.207.28 << 'EOF'
                  cd apache/docker-apache-laravel
                  git pull origin main || { echo 'Git pull failed'; exit 1; }
                  docker-compose down
                  docker compose build --no-cache 
                  docker-compose up -d
                  docker exec -it dockerApp bash
                  composer install --no-interaction --no-suggest
                  php artisan config:cache
                  php artisan route:cache
                  php artisan view:clear
                  EOF
```
