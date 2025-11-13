echo "🐘 Esperando a la base de datos..."
python << 'END'
import time, os
import psycopg2
from urllib.parse import urlparse

db_url = os.getenv("DATABASE_URL")

if db_url:
    # Parsear DATABASE_URL
    parsed = urlparse(db_url)
    dsn = db_url
    print(f"🔍 Conectando usando DATABASE_URL...")
else:
    # Variables normales (local)
    db_name = os.getenv("POSTGRES_DB", "postgres")
    db_user = os.getenv("POSTGRES_USER", "postgres")
    db_password = os.getenv("POSTGRES_PASSWORD", "postgres")
    db_host = os.getenv("POSTGRES_HOST", "db")
    db_port = os.getenv("POSTGRES_PORT", "5432")

    dsn = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
    print(f"🔍 Conectando usando POSTGRES_* variables...")

print(f"🔎 DSN usado: {dsn}")

while True:
    try:
        conn = psycopg2.connect(dsn)
        conn.close()
        print("✅ Conexión a la base de datos establecida.")
        break
    except Exception as e:
        print(f"⏳ Esperando conexión a la base de datos... {e}")
        time.sleep(2)
END

