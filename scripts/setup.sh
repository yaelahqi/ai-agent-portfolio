#!/bin/bash

# AI Agent Portfolio Setup Script
# This script sets up the development environment

set -e

echo "🚀 Setting up AI Agent Portfolio..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Python version
echo "📦 Checking Python version..."
python_version=$(python3 --version 2>&1 | awk '{print $2}')
if [[ "$(printf '%s\n' "3.10" "$python_version" | sort -V | head -n1)" != "3.10" ]]; then
    echo -e "${RED}❌ Python 3.10 or higher is required${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python $python_version${NC}"

# Check Node.js version
echo "📦 Checking Node.js version..."
node_version=$(node --version 2>&1 | cut -d'v' -f2)
if [[ "$(printf '%s\n' "18.0" "$node_version" | sort -V | head -n1)" != "18.0" ]]; then
    echo -e "${RED}❌ Node.js 18 or higher is required${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Node.js $node_version${NC}"

# Create virtual environment
echo "🐍 Creating Python virtual environment..."
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    echo -e "${GREEN}✅ Virtual environment created${NC}"
else
    echo -e "${YELLOW}⚠️  Virtual environment already exists${NC}"
fi

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source .venv/bin/activate

# Install Python dependencies
echo "📚 Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
echo -e "${GREEN}✅ Python dependencies installed${NC}"

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install
echo -e "${GREEN}✅ Node.js dependencies installed${NC}"

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p ~/.hermes
mkdir -p ~/.hermes/skills
mkdir -p ~/.hermes/tools
mkdir -p ~/.hermes/logs
mkdir -p ~/.hermes/cache
echo -e "${GREEN}✅ Directories created${NC}"

# Copy example environment file
echo "⚙️  Setting up environment..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${YELLOW}⚠️  Please edit .env with your API keys${NC}"
else
    echo -e "${GREEN}✅ .env already exists${NC}"
fi

# Install Tesseract OCR
echo "🔍 Installing Tesseract OCR..."
if command -v tesseract &> /dev/null; then
    echo -e "${GREEN}✅ Tesseract already installed${NC}"
else
    sudo apt-get update
    sudo apt-get install -y tesseract-ocr tesseract-ocr-ind tesseract-ocr-eng
    echo -e "${GREEN}✅ Tesseract installed${NC}"
fi

# Install PM2
echo "📊 Installing PM2..."
if command -v pm2 &> /dev/null; then
    echo -e "${GREEN}✅ PM2 already installed${NC}"
else
    npm install -g pm2
    echo -e "${GREEN}✅ PM2 installed${NC}"
fi

# Setup complete
echo ""
echo -e "${GREEN}🎉 Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Edit .env with your API keys"
echo "2. Configure ~/.hermes/config.yaml"
echo "3. Start the gateway: hermes gateway start"
echo ""
echo "For more information, see docs/setup-guide.md"
