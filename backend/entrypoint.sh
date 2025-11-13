#!/usr/bin/env bash
set -e

echo "🐘 Esperando a la base de datos..."

python << 'END'
import time, os
import psycopg2

# Leer variables de entorno con valores por defecto (para entorno local)
db_name = os.getenv("POSTGRES_DB") or os.getenv("DB_NAME") or "postgres"
db_user = os.getenv("POSTGRES_USER") or os.getenv("DB_USER") or "postgres"
db_password = os.getenv("POSTGRES_PASSWORD") or os.getenv("DB_PASSWORD") or "postgres"
db_host = os.getenv("POSTGRES_HOST") or os.getenv("DB_HOST") or "db"
db_port = os.getenv("POSTGRES_PORT") or os.getenv("DB_PORT") or "5432"

print(f"🔍 Intentando conectar a PostgreSQL en {db_host}:{db_port} db={db_name} user={db_user}")

while True:
    try:
        conn = psycopg2.connect(
            dbname=db_name,
            user=db_user,
            password=db_password,
            host=db_host,
            port=db_port,
        )
        conn.close()
        print("✅ Conexión a la base de datos establecida.")
        break
    except Exception as e:
        print(f"⏳ Esperando conexión a la base de datos... {e}")
        time.sleep(2)
END

echo "🚀 Iniciando servidor Django..."
python manage.py runserver 0.0.0.0:8000
