# ===================
# Builder Stage
# ===================
FROM python:3.11-buster AS builder

WORKDIR /app

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi

COPY . .

# ===================
# App Stage
# ===================
FROM python:3.11-buster AS app

WORKDIR /app

RUN apt-get update && apt-get install -y netcat

# Copy installed Python packages and binaries from builder
COPY --from=builder /usr/local/lib/python3.11 /usr/local/lib/python3.11
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy app source code
COPY --from=builder /app /app

# Copy entrypoint script
COPY entrypoint.sh .

# Make the script executable
RUN chmod +x ./entrypoint.sh

# Expose FastAPI port
EXPOSE 8000

# Set entrypoint
ENTRYPOINT ["./entrypoint.sh"]

# i put the command to run the fastAPI app in entrypoint.sh script. It wasn't working otherwise
