# Setup Guide

## Prerequisites

### System Requirements
- **OS:** Ubuntu 22.04 LTS (recommended) or any Linux distribution
- **Python:** 3.10 or higher
- **Node.js:** 18 or higher
- **RAM:** 2GB minimum, 4GB recommended
- **Storage:** 10GB minimum
- **Network:** Stable internet connection

### Required API Keys
At least one of the following:
- OpenAI API key
- Anthropic API key
- Google Gemini API key
- Groq API key (free tier available)
- Xiaomi MiMo API key

### Optional API Keys
- Telegram Bot Token
- Discord Bot Token
- ElevenLabs API key (for TTS)
- FAL API key (for image generation)

## Installation

### Step 1: Clone Repository
```bash
git clone https://github.com/yourusername/ai-agent-portfolio.git
cd ai-agent-portfolio
```

### Step 2: Install Python Dependencies
```bash
# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### Step 3: Install Node.js Dependencies
```bash
npm install
```

### Step 4: Configure Environment
```bash
# Copy example environment file
cp .env.example .env

# Edit with your API keys
nano .env
```

### Step 5: Configure Hermes Agent
```bash
# Initialize Hermes configuration
hermes setup

# Or manually configure
nano ~/.hermes/config.yaml
```

## Configuration

### Environment Variables (.env)
```env
# AI Model API Keys
OPENAI_API_KEY=sk-your-openai-key
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key
GOOGLE_API_KEY=your-google-api-key
GROQ_API_KEY=gsk_your-groq-key
XIAOMI_MIMO_API_KEY=your-mimo-key

# Platform Tokens
TELEGRAM_BOT_TOKEN=your-telegram-bot-token
DISCORD_BOT_TOKEN=your-discord-bot-token

# Optional Services
ELEVENLABS_API_KEY=your-elevenlabs-key
FAL_API_KEY=your-fal-key
```

### Hermes Config (~/.hermes/config.yaml)
```yaml
# Model Configuration
model:
  primary: gpt-4o
  fallback: claude-3-5-sonnet-20241022
  
# Provider Configuration
providers:
  openai:
    api_key: ${OPENAI_API_KEY}
  anthropic:
    api_key: ${ANTHROPIC_API_KEY}
  google:
    api_key: ${GOOGLE_API_KEY}
  groq:
    api_key: ${GROQ_API_KEY}

# Platform Configuration
platforms:
  telegram:
    enabled: true
    bot_token: ${TELEGRAM_BOT_TOKEN}
  discord:
    enabled: true
    bot_token: ${DISCORD_BOT_TOKEN}

# Tool Configuration
tools:
  ocr:
    enabled: true
    language: eng+ind
  tts:
    enabled: true
    provider: edge-tts
  vision:
    enabled: true
    fallback: true
```

## Running the System

### Start Gateway
```bash
# Start with PM2 (recommended)
pm2 start ecosystem.config.js

# Or start manually
hermes gateway start

# Or start with specific platform
hermes gateway start --platform telegram
```

### Verify Installation
```bash
# Check status
hermes status

# Check logs
hermes logs --follow

# Test basic functionality
hermes test
```

### Stop Gateway
```bash
# Stop PM2 process
pm2 stop hermes-gateway

# Or stop manually
hermes gateway stop
```

## Platform Setup

### Telegram Bot
1. Open Telegram and search for @BotFather
2. Send `/newbot` command
3. Follow instructions to create bot
4. Copy the bot token
5. Add to `.env` file
6. Start gateway with `hermes gateway start --platform telegram`

### Discord Bot
1. Go to Discord Developer Portal
2. Create new application
3. Go to Bot section
4. Create bot and copy token
5. Add to `.env` file
6. Invite bot to server with proper permissions
7. Start gateway with `hermes gateway start --platform discord`

## Tool Setup

### OCR (Tesseract)
```bash
# Install Tesseract
sudo apt update
sudo apt install tesseract-ocr tesseract-ocr-ind tesseract-ocr-eng

# Install Python wrapper
pip install pytesseract Pillow

# Test OCR
python3 tools/ocr_tool.py test_image.png
```

### Text-to-Speech (Edge-TTS)
```bash
# Install Edge-TTS
pip install edge-tts

# Test TTS
edge-tts --voice id-ID-ArdiNeural --text "Halo, apa kabar?" --write-media test.mp3
```

### Vision Analysis
```bash
# Vision is built-in with Hermes
# Test with CLI
hermes vision analyze test_image.png
```

## Troubleshooting

### Common Issues

#### 1. API Key Not Working
```bash
# Check if key is set
echo $OPENAI_API_KEY

# Test API connection
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"
```

#### 2. Gateway Won't Start
```bash
# Check logs
hermes logs --level error

# Check port availability
ss -tuln | grep :8080

# Restart PM2
pm2 restart hermes-gateway
```

#### 3. OCR Not Working
```bash
# Check Tesseract installation
tesseract --version

# Check language data
tesseract --list-langs

# Reinstall if needed
sudo apt install --reinstall tesseract-ocr
```

#### 4. Memory Issues
```bash
# Check memory usage
free -h

# Clear cache
sudo sync
sudo sysctl -w vm.drop_caches=3

# Restart services
pm2 restart all
```

### Getting Help
- Check logs: `hermes logs --follow`
- Run diagnostics: `hermes doctor`
- Join community: [GitHub Discussions]
- Open issue: [GitHub Issues]

## Production Deployment

### Using PM2
```bash
# Install PM2
npm install -g pm2

# Start with ecosystem file
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

# Setup startup script
pm2 startup
```

### Using Systemd
```bash
# Create service file
sudo nano /etc/systemd/system/hermes-gateway.service

# Enable and start
sudo systemctl enable hermes-gateway
sudo systemctl start hermes-gateway

# Check status
sudo systemctl status hermes-gateway
```

### Nginx Reverse Proxy
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## Monitoring

### Health Check
```bash
# Check API endpoint
curl http://localhost:8080/health

# Check WebSocket
wscat -c ws://localhost:8080/ws
```

### Logs
```bash
# View real-time logs
hermes logs --follow

# Filter by level
hermes logs --level error

# Filter by session
hermes logs --session SESSION_ID
```

### Metrics
```bash
# Check system resources
htop

# Check disk usage
df -h

# Check network connections
ss -tuln
```

## Backup & Recovery

### Backup
```bash
# Backup Hermes data
tar -czf hermes-backup-$(date +%Y%m%d).tar.gz ~/.hermes/

# Backup to cloud
aws s3 cp hermes-backup-*.tar.gz s3://your-bucket/
```

### Recovery
```bash
# Restore from backup
tar -xzf hermes-backup-20260522.tar.gz -C ~/

# Restart services
pm2 restart all
```

## Security Best Practices

1. **API Keys**
   - Never commit to version control
   - Use environment variables
   - Rotate keys regularly

2. **Network**
   - Use HTTPS only
   - Enable firewall
   - Limit SSH access

3. **Updates**
   - Keep system updated
   - Update dependencies regularly
   - Monitor security advisories

4. **Monitoring**
   - Enable logging
   - Set up alerts
   - Monitor resource usage
