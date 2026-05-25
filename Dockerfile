# -------------------------
# Stage 1: Builder Stage
# -------------------------
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# -------------------------
# Stage 2: Production Stage
# -------------------------
FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /install /usr/local

# Copy entire project correctly
COPY . .

# Expose Flask port
EXPOSE 80

# Run app
CMD ["python", "run.py"]
