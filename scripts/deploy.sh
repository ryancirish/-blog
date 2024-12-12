#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Starting deployment...${NC}"

# Check if flyctl is installed
if ! command -v flyctl &> /dev/null; then
    echo -e "${RED}Error: flyctl is not installed${NC}"
    echo "Install it from https://fly.io/docs/hands-on/install-flyctl/"
    exit 1
fi

# Check if user is logged in to Fly.io
echo -e "${YELLOW}Checking Fly.io authentication...${NC}"
if ! flyctl auth whoami &> /dev/null; then
    echo "Please log in to Fly.io:"
    flyctl auth login
fi

# Get app name from fly.toml
APP_NAME=$(grep '^app\s*=' fly.toml | cut -d'"' -f2 || echo "")
if [ -z "$APP_NAME" ]; then
    echo -e "${RED}Error: Could not find app name in fly.toml${NC}"
    exit 1
fi

echo -e "${YELLOW}Checking deployment status for $APP_NAME...${NC}"

# Try to get app status
if ! flyctl status --app $APP_NAME &> /dev/null; then
    echo -e "${YELLOW}App not found. Running initial launch...${NC}"
    flyctl launch --no-deploy --name $APP_NAME --copy-config
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create app${NC}"
        exit 1
    fi
fi

# Deploy the application
echo -e "${YELLOW}Deploying to Fly.io...${NC}"
flyctl deploy

# Check deployment status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo -e "${GREEN}Your app is live at: https://$APP_NAME.fly.dev${NC}"
else
    echo -e "${RED}❌ Deployment failed${NC}"
    exit 1
fi