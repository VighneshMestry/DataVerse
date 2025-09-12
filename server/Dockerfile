# Builder stage
FROM node:18-slim AS builder

RUN apt-get update && apt-get install -y \
    python3 python3-pip python3.11-venv build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create virtual env and install Python deps
COPY requirements.txt .
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

# Install Node deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .

# Runtime stage (lightweight)
FROM node:18-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Copy venv from builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy app (no need to copy build deps)
WORKDIR /app
COPY --from=builder /app .

EXPOSE 4000
CMD [ "npm", "start" ]
