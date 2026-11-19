# Minimal base image
FROM python:3.13-slim

# Don't write .pyc files, and print logs immediately (helps CloudWatch logging)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create a non-root user with a fixed ID
RUN groupadd --system --gid 10001 appgroup && \
    useradd --system --uid 10001 --gid appgroup \
      --no-create-home --shell /usr/sbin/nologin appuser

WORKDIR /app

# Install dependencies first (Docker caches this layer)
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy only the application code
COPY app/app.py .

# Drop privileges: everything after this runs as non-root
USER 10001:10001

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--worker-tmp-dir", "/dev/shm", "app:app"]