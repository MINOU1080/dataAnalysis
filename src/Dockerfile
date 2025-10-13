FROM python:3.11-slim

# Dépendances système utiles si tu utilises psycopg2 (connexion Postgres)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev curl && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Dépendances Python (si tu as requirements.txt dans src/)
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Code
COPY . /app

# Expose si c'est une API (FastAPI/Flask). Inoffensif sinon.
EXPOSE 8000

# Commande par défaut (surchargée par compose au besoin)
CMD ["python", "main.py"]
