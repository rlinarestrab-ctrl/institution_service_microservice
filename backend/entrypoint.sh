#!/bin/sh

echo "Esperando a la base de datos..."
until nc -z db 5432; do
  sleep 1
done

echo "Base de datos lista. Ejecutando migraciones..."
python manage.py makemigrations
python manage.py migrate

echo "Iniciando servidor Django..."
exec python manage.py runserver 0.0.0.0:8000
