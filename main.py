import os
import telebot
from openai import OpenAI
from dotenv import load_dotenv

# ENV faýlyny ýükleýäris
load_dotenv()

# Tokenleri alyp gelýäris
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# Telegram bot
bot = telebot.TeleBot(TELEGRAM_BOT_TOKEN)

# OpenAI client
client = OpenAI(api_key=OPENAI_API_KEY)

# Handler — islendik mesaj gelende jogap berýär
@bot.message_handler(func=lambda m: True)
def reply(message):
    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "user", "content": message.text}
            ]
        )

        answer = response.choices[0].message["content"]
        bot.send_message(message.chat.id, answer)

    except Exception as e:
        bot.send_message(message.chat.id, f"Hata: {e}")

# Boty işledýäris
bot.polling()
