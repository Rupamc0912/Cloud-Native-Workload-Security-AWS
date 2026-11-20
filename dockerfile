# Minimal base image
FROM python:3.13-slim

# Don't write .pyc files, and print logs immediately (helps CloudWatch logging)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Apply available OS security patches at build time
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user with a fixed ID
RUN groupadd --system --gid 10001 appgroup && \
    useradd --system --uid 10001 --gid appgroup \
      --no-create-home --shell /usr/sbin/nologin appuser

WORKDIR /app

# Install dependencies, then remove packaging tools the app doesn't need at runtime
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    pip uninstall -y pip setuptools wheel

# Copy only the application code
COPY app/app.py .

# Drop privileges: everything after this runs as non-root
USER 10001:10001

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--worker-tmp-dir", "/dev/shm", "app:app"]