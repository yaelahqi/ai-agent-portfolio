# API Reference

## Overview

This document provides comprehensive API reference for all tools and services in the AI Agent Portfolio.

## Core Tools

### 1. OCR Tool (`ocr_extract`)

Extract text from images using Tesseract OCR.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `image_path` | string | Yes | - | Path to image file |
| `lang` | string | No | `eng+ind` | OCR language |
| `preprocess` | boolean | No | `true` | Apply preprocessing |

**Example:**
```python
result = ocr_extract(
    image_path="/path/to/image.png",
    lang="eng+ind",
    preprocess=True
)
```

**Response:**
```json
{
  "text": "Extracted text content",
  "confidence": 85.2,
  "word_count": 42,
  "language": "eng+ind",
  "image_size": "1920x1080"
}
```

**Supported Formats:**
- PNG, JPG, JPEG, WEBP, BMP, TIFF, GIF

---

### 2. Vision Analysis (`vision_analyze`)

Analyze images using AI vision models.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `image_url` | string | Yes | - | Image URL or path |
| `user_prompt` | string | No | "Describe..." | Analysis prompt |

**Example:**
```python
result = vision_analyze(
    image_url="/path/to/image.png",
    user_prompt="What objects are in this image?"
)
```

**Response:**
```json
{
  "success": true,
  "analysis": "The image shows a desk with a laptop...",
  "model_used": "gpt-4o"
}
```

---

### 3. Text-to-Speech (`text_to_speech`)

Convert text to speech audio.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `text` | string | Yes | - | Text to convert |
| `output_path` | string | No | auto | Output file path |

**Example:**
```python
result = text_to_speech(
    text="Halo, apa kabar?",
    output_path="/tmp/audio.mp3"
)
```

**Response:**
```
MEDIA:/tmp/audio.mp3
```

---

### 4. Terminal Execute (`terminal`)

Execute shell commands.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `command` | string | Yes | - | Command to execute |
| `timeout` | integer | No | 180 | Timeout in seconds |
| `background` | boolean | No | false | Run in background |

**Example:**
```python
result = terminal(command="ls -la", timeout=30)
```

**Response:**
```json
{
  "output": "total 12\ndrwxr-xr-x 2 user user 4096...",
  "exit_code": 0
}
```

---

### 5. Web Search (`web_search`)

Search the web for information.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `query` | string | Yes | - | Search query |
| `max_results` | integer | No | 5 | Max results |

**Example:**
```python
results = web_search(
    query="latest AI news",
    max_results=10
)
```

**Response:**
```json
[
  {
    "title": "AI Breakthrough 2026",
    "url": "https://example.com/ai-news",
    "snippet": "Recent developments in AI..."
  }
]
```

---

## Trading Tools

### 6. Market Data (`get_market_data`)

Get real-time market data from IDX.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `symbol` | string | Yes | - | Stock symbol (e.g., BBCA) |
| `period` | string | No | `1d` | Data period |

**Example:**
```python
data = get_market_data(symbol="BBCA", period="1d")
```

**Response:**
```json
{
  "symbol": "BBCA",
  "price": 9500,
  "change": 150,
  "volume": 12500000,
  "timestamp": "2026-05-22T10:00:00Z"
}
```

---

### 7. Place Order (`place_order`)

Place trading order (simulation).

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `symbol` | string | Yes | - | Stock symbol |
| `side` | string | Yes | - | BUY or SELL |
| `quantity` | integer | Yes | - | Number of shares |
| `price` | number | No | market | Limit price |

**Example:**
```python
result = place_order(
    symbol="BBCA",
    side="BUY",
    quantity=100,
    price=9500
)
```

---

## Automation Tools

### 8. File Operations (`read_file`, `write_file`)

Read and write files.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `path` | string | Yes | - | File path |
| `content` | string | Write only | - | File content |

**Example:**
```python
# Read file
content = read_file(path="/path/to/file.txt")

# Write file
write_file(path="/path/to/file.txt", content="Hello World")
```

---

### 9. Schedule Task (`cronjob`)

Schedule recurring tasks.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `action` | string | Yes | - | create, list, update, remove |
| `prompt` | string | create | - | Task description |
| `schedule` | string | create | - | Cron expression |

**Example:**
```python
cronjob(
    action="create",
    prompt="Check market status every morning",
    schedule="0 9 * * *"
)
```

---

### 10. Memory (`memory`)

Store and retrieve persistent information.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `action` | string | Yes | - | add, replace, remove |
| `target` | string | Yes | - | memory or user |
| `content` | string | add/replace | - | Content to store |

**Example:**
```python
memory(
    action="add",
    target="memory",
    content="User prefers concise responses"
)
```

---

## Model Configuration

### Available Models

| Provider | Model | Context | Best For |
|----------|-------|---------|----------|
| OpenAI | gpt-4o | 128K | Vision, reasoning |
| OpenAI | gpt-4-turbo | 128K | Code, analysis |
| Anthropic | claude-3-5-sonnet | 200K | Code, writing |
| Google | gemini-pro | 32K | General, fast |
| Groq | mixtral-8x7b | 32K | Speed, cost |
| Xiaomi | mimo-v2.5 | 128K | Cost-effective |

### Model Selection

```python
# Automatic selection
response = chat("Explain quantum computing")

# Manual selection
response = chat("Write Python code", model="claude-3-5-sonnet")

# With fallback
response = chat("Analyze image", model="gpt-4o", fallback="gemini-pro")
```

---

## Error Handling

### Common Errors

| Error | Code | Description | Solution |
|-------|------|-------------|----------|
| `API_KEY_MISSING` | 401 | API key not set | Set environment variable |
| `RATE_LIMIT` | 429 | Rate limit exceeded | Wait or use fallback |
| `INVALID_MODEL` | 400 | Model not available | Check model name |
| `TIMEOUT` | 408 | Request timeout | Increase timeout |
| `FILE_NOT_FOUND` | 404 | File doesn't exist | Check file path |

### Error Response Format

```json
{
  "error": {
    "code": "RATE_LIMIT",
    "message": "Rate limit exceeded for OpenAI API",
    "details": {
      "limit": 10000,
      "remaining": 0,
      "reset_at": "2026-05-22T11:00:00Z"
    }
  }
}
```

---

## Rate Limits

### Default Limits

| Provider | Requests/Min | Tokens/Min |
|----------|--------------|------------|
| OpenAI | 60 | 10000 |
| Anthropic | 50 | 8000 |
| Google | 60 | 12000 |
| Groq | 30 | 12000 |

### Best Practices

1. **Cache responses** when possible
2. **Use batch processing** for multiple requests
3. **Implement retry logic** with exponential backoff
4. **Monitor usage** to avoid hitting limits
5. **Use fallback models** when primary is rate-limited

---

## WebSocket API

### Connect

```javascript
const ws = new WebSocket('wss://your-domain.com/ws');

ws.onopen = () => {
  console.log('Connected');
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Received:', data);
};
```

### Send Message

```javascript
ws.send(JSON.stringify({
  type: 'chat',
  content: 'Hello, how are you?',
  session_id: 'session_123'
}));
```

### Receive Response

```javascript
{
  "type": "response",
  "content": "I'm doing well, thank you!",
  "model": "gpt-4o",
  "tokens": {
    "prompt": 15,
    "completion": 12
  }
}
```
