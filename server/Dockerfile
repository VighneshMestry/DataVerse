FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs npm \
    build-essential \
    zlib1g-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    tesseract-ocr \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*  

# Above are the setup tools required by alpine before installing the python dependencies

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip setuptools wheel Cython

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app

COPY package*.json .

RUN npm ci

COPY . .

EXPOSE 4000

CMD [ "npm", "start" ]

