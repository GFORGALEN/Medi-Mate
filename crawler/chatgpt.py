import os
from openai import OpenAI

# 从环境变量中读取 API 密钥
api_key = "sk-DuJOH2rtknk0hpO7jQraaLtCV8wbc0DZRnEybrbJVyT3BlbkFJrjZn8xHGjA_JaXDrQoy4utfLtfrroRxJftxaZJQGkA"

# 初始化 OpenAI 客户端
client = OpenAI(api_key=api_key)

response = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "What’s in this image?"},
                {
                    "type": "image_url",
                    "image_url": {
                        "url": "https://ocr-temp-s3.s3.ap-southeast-2.amazonaws.com/F2D_800.jpg",
                    },
                },
            ],
        }
    ],
    max_tokens=3000,
)

print(response.choices[0])
