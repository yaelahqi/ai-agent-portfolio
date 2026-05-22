# Telegram Bot Example

## Overview

This example demonstrates how to integrate the AI Agent with Telegram.

## Setup

### 1. Create Telegram Bot

1. Open Telegram and search for `@BotFather`
2. Send `/newbot` command
3. Follow instructions:
   - Choose a name for your bot
   - Choose a username (must end with `bot`)
4. Copy the bot token

### 2. Configure Environment

Add to your `.env` file:

```env
TELEGRAM_BOT_TOKEN=your_bot_token_here
```

### 3. Configure Hermes

Edit `~/.hermes/config.yaml`:

```yaml
platforms:
  telegram:
    enabled: true
    bot_token: ${TELEGRAM_BOT_TOKEN}
    allowed_users:
      - your_telegram_user_id
```

### 4. Start Gateway

```bash
# Start with PM2
pm2 start ecosystem.config.js --env telegram

# Or start manually
hermes gateway start --platform telegram
```

## Features

### Basic Chat

Send any text message to the bot:

```
User: Hello, how are you?
Bot: I'm doing well! How can I help you today?
```

### Image Analysis

Send an image with optional caption:

```
User: [sends image] What's in this image?
Bot: I can see a beautiful landscape with mountains...
```

### Code Generation

Ask for code:

```
User: Write a Python function to sort a list
Bot: Here's a Python function to sort a list:

def sort_list(lst):
    return sorted(lst)

You can also use the list.sort() method for in-place sorting...
```

### File Operations

Request file operations:

```
User: Create a file called hello.txt with "Hello World"
Bot: I've created the file hello.txt with the content "Hello World"

User: Read the file hello.txt
Bot: The content of hello.txt is: "Hello World"
```

## Commands

### Built-in Commands

| Command | Description |
|---------|-------------|
| `/start` | Start the bot |
| `/help` | Show help message |
| `/model` | Switch AI model |
| `/clear` | Clear conversation history |
| `/status` | Show bot status |

### Custom Commands

You can add custom commands by creating skills:

```python
# ~/.hermes/skills/custom/hello.py
def handle_hello(params):
    return f"Hello {params.get('name', 'World')}!"
```

## Advanced Features

### Inline Queries

Enable inline queries for quick access:

```yaml
platforms:
  telegram:
    inline_queries: true
```

Usage:
```
@yourbot query text here
```

### Webhooks

For production, use webhooks instead of polling:

```yaml
platforms:
  telegram:
    webhook:
      enabled: true
      url: https://your-domain.com/webhook/telegram
      certificate: /path/to/cert.pem
```

### Group Chats

Add bot to group chats:

1. Add bot to group
2. Disable privacy mode: `/setprivacy` with BotFather
3. Configure allowed groups in config:

```yaml
platforms:
  telegram:
    allowed_groups:
      - group_id_1
      - group_id_2
```

## Error Handling

### Common Issues

1. **Bot not responding**
   - Check bot token
   - Verify bot is running: `pm2 status`
   - Check logs: `hermes logs`

2. **Rate limiting**
   - Telegram limits: 30 messages/second
   - Implement retry logic
   - Use message queuing

3. **Webhook issues**
   - Verify SSL certificate
   - Check webhook URL
   - Test with: `curl https://api.telegram.org/bot<token>/getWebhookInfo`

## Example Code

### Python Telegram Bot

```python
import asyncio
from telegram import Update
from telegram.ext import Application, CommandHandler, MessageHandler, filters

async def start(update: Update, context):
    await update.message.reply_text('Hello! I am your AI assistant.')

async def handle_message(update: Update, context):
    user_message = update.message.text
    
    # Process with Hermes
    response = await process_with_hermes(user_message)
    
    await update.message.reply_text(response)

def main():
    application = Application.builder().token("YOUR_TOKEN").build()
    
    application.add_handler(CommandHandler("start", start))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    
    application.run_polling()

if __name__ == '__main__':
    main()
```

### JavaScript Telegram Bot

```javascript
const TelegramBot = require('node-telegram-bot-api');

const token = 'YOUR_TOKEN';
const bot = new TelegramBot(token, { polling: true });

bot.onText(/\/start/, (msg) => {
  const chatId = msg.chat.id;
  bot.sendMessage(chatId, 'Hello! I am your AI assistant.');
});

bot.on('message', async (msg) => {
  const chatId = msg.chat.id;
  const userMessage = msg.text;
  
  // Process with Hermes
  const response = await processWithHermes(userMessage);
  
  bot.sendMessage(chatId, response);
});
```

## Monitoring

### Health Check

```bash
# Check bot status
curl https://api.telegram.org/bot<token>/getMe

# Check webhook info
curl https://api.telegram.org/bot<token>/getWebhookInfo
```

### Logs

```bash
# View real-time logs
hermes logs --follow --platform telegram

# Filter by user
hermes logs --user telegram:123456789
```

## Security

### Best Practices

1. **Never commit tokens** to version control
2. **Use environment variables** for sensitive data
3. **Limit access** with allowed_users/allowed_groups
4. **Enable encryption** for webhook communication
5. **Regular rotation** of bot tokens

### User Authentication

```yaml
platforms:
  telegram:
    auth:
      enabled: true
      method: whitelist
      allowed_users:
        - 123456789
        - 987654321
```

## Deployment

### Using PM2

```javascript
// ecosystem.config.js
module.exports = {
  apps: [{
    name: 'telegram-bot',
    script: 'python',
    args: '-m hermes gateway start --platform telegram',
    env: {
      TELEGRAM_BOT_TOKEN: 'your_token'
    }
  }]
};
```

### Using Docker

```dockerfile
FROM python:3.12-slim

WORKDIR /app
COPY . .
RUN pip install -r requirements.txt

CMD ["python", "-m", "hermes", "gateway", "start", "--platform", "telegram"]
```

### Using Systemd

```ini
[Unit]
Description=Hermes Telegram Bot
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/hermes-agent
ExecStart=/home/ubuntu/hermes-agent/.venv/bin/python -m hermes gateway start --platform telegram
Restart=always

[Install]
WantedBy=multi-user.target
```

## Support

- **Documentation:** [Hermes Docs](https://docs.hermes-agent.com)
- **GitHub:** [Hermes Repository](https://github.com/hermes-agent)
- **Telegram:** [@hermes_support](https://t.me/hermes_support)
