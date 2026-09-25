FROM python:3.12-slim

# Security Scanning (Task 10.2D): Docker Scout flagged outdated Debian
# OS packages (CVEs unrelated to our own code) on the base image.
# Pulling latest security patches for the base image's OS packages
# addresses that class of finding without changing the Python layer.
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install \
    --no-cache-dir \
    --root-user-action=ignore \
    -r requirements.txt

COPY . .

RUN useradd -m appuser
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]