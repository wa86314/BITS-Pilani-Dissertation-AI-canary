FROM python:3.10-slim

# Install system dependencies (for PyTorch)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages directly (no conda)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir fastapi uvicorn transformers

# Download model weights and tokenizer
RUN python -c "from transformers import AutoModel, AutoTokenizer; \
AutoModel.from_pretrained('bert-base-uncased'); \
AutoTokenizer.from_pretrained('bert-base-uncased')"

WORKDIR /app
COPY app.py .

EXPOSE 8888

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8888"]
