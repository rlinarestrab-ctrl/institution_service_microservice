echo "🐘 Esperando a la base de datos..."
python << END
import time, psycopg2, os
while True:
    try:
        conn = psycopg2.connect(
            dbname=os.getenv("POSTGRES_DB"),
            user=os.getenv("POSTGRES_USER"),
            password=os.getenv("POSTGRES_PASSWORD"),
            host=os.getenv("POSTGRES_HOST"),
            port=os.getenv("POSTGRES_PORT"),
        )
        conn.close()
        break
    except Exception:
        print("⏳ Esperando conexión a la base de datos...")
        time.sleep(2)
END
