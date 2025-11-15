

from pathlib import Path
import os
import dj_database_url  # ✅ si lo agregas en requirements.txt (opcional pero útil)


BASE_DIR = Path(__file__).resolve().parent.parent

# ------------------------------------------------------------------------------------
# 🔐 Seguridad y modo de ejecución
# ------------------------------------------------------------------------------------
SECRET_KEY = os.getenv('SECRET_KEY', 'django-insecure-local-key')
DEBUG = os.getenv('DEBUG', 'False').lower() == 'true'

ALLOWED_HOSTS = ["*"]  # En Render puede cambiar dinámicamente, así no bloquea peticiones

# ------------------------------------------------------------------------------------
# 🧩 Aplicaciones instaladas
# ------------------------------------------------------------------------------------
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "corsheaders",
    "rest_framework",
    "institutions",
]

# ------------------------------------------------------------------------------------
# 🧱 Middleware
# ------------------------------------------------------------------------------------
MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "institution_service.urls"

# ------------------------------------------------------------------------------------
# 🎨 Templates
# ------------------------------------------------------------------------------------
TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "institution_service.wsgi.application"


# ------------------------------------------------------------------------------------
# 🗄️ Base de datos (Render + Supabase)
# ------------------------------------------------------------------------------------

DATABASE_URL = os.getenv("DATABASE_URL")

if DATABASE_URL:
    # 🔹 Modo producción: Render + Supabase
    DATABASES = {
        "default": dj_database_url.config(
            default=DATABASE_URL,
            conn_max_age=600,
            ssl_require=True,
        )
    }

    # 🔹 Render/Supabase → usar esquema institution_service
    DATABASES["default"]["OPTIONS"] = {
        "options": "-c search_path=institution_service,public"
    }

else:
    # 🔹 Modo desarrollo local → Postgres sin schemas personalizados
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.postgresql",
            "NAME": os.getenv("POSTGRES_DB", "institution_service_db"),
            "USER": os.getenv("POSTGRES_USER", "postgres"),
            "PASSWORD": os.getenv("POSTGRES_PASSWORD", "postgres"),
            "HOST": os.getenv("POSTGRES_HOST", "db"),
            "PORT": os.getenv("POSTGRES_PORT", "5432"),
            # Nota: NO agregamos search_path aquí
        }
    }
    
# Si usas esquemas distintos en Supabase (opcional)
# DATABASES["default"]["OPTIONS"] = {"options": "-c search_path=institution"}

# ------------------------------------------------------------------------------------
# 🔑 Validadores de contraseña
# ------------------------------------------------------------------------------------
AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

# ------------------------------------------------------------------------------------
# 🌐 Internacionalización
# ------------------------------------------------------------------------------------
LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True

# ------------------------------------------------------------------------------------
# 📦 Archivos estáticos
# ------------------------------------------------------------------------------------
STATIC_URL = "static/"
STATIC_ROOT = BASE_DIR / "staticfiles"

# ------------------------------------------------------------------------------------
# 🔓 CORS (frontend autorizado)
# ------------------------------------------------------------------------------------
CORS_ALLOWED_ORIGINS = [
    "http://localhost:5173",  # modo dev
    "https://vocational-frontend.vercel.app",  # producción
]

CORS_ALLOW_CREDENTIALS = True
