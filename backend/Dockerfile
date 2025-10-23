FROM python:3.11-slim

WORKDIR /app

# Evita pycache y usa logs sin buffer
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 🧩 Instala dependencias del sistema (incluye netcat)
RUN apt-get update && apt-get install -y netcat-traditional && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x /app/entrypoint.sh
CMD ["sh", "/app/entrypoint.sh"]
