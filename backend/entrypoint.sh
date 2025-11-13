#!/usr/bin/env bash
set -e

echo "🐘 Esperando a la base de datos..."

python << 'END'
import os
import time
from urllib.parse import urlparse
import psycopg2

db_url = os.getenv("DATABASE_URL")

if db_url:
    print("🔍 Conectando usando DATABASE_URL...")
    print("🔎 DSN usado: ")
    print(db_url)

    # Parsear la URL para sacar los campos por separado
    url = urlparse(db_url)

    db_name = (url.path or "").lstrip("/") or "postgres"
    db_user = url.username or "postgres"
    db_password = url.password or ""
    db_host = url.hostname or "localhost"
    db_port = url.port or 5432
    use_ssl = True
else:
    print("🔍 Conectando usando variables POSTGRES_*...")

    db_name = os.getenv("POSTGRES_DB", "postgres")
    db_user = os.getenv("POSTGRES_USER", "postgres")
    db_password = os.getenv("POSTGRES_PASSWORD", "postgres")
    db_host = os.getenv("POSTGRES_HOST", "db")
    db_port = int(os.getenv("POSTGRES_PORT", "5432"))
    use_ssl = False

print(f"➡ host={db_host} port={db_port} db={db_name} user={db_user}")

while True:
    try:
        conn_kwargs = dict(
            dbname=db_name,
            user=db_user,
            password=db_password,
            host=db_host,
            port=db_port,
        )

        # Supabase casi siempre requiere SSL
        if use_ssl:
            conn_kwargs["sslmode"] = "require"

        conn = psycopg2.connect(**conn_kwargs)
        conn.close()
        print("✅ Conexión a la base de datos establecida.")
        break
    except Exception as e:
        print(f"⏳ Esperando conexión a la base de datos... {e}")
        time.sleep(2)
END

echo "🚀 Ejecutando migraciones..."
python manage.py migrate --noinput || echo "⚠️ Migraciones fallaron, revisa logs."

echo "🚀 Iniciando servidor Django..."
python manage.py runserver 0.0.0.0:${PORT:-8000}
