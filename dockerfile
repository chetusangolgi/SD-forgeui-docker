# Use a base image with CUDA support
FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    FORCE_CUDA="1" \
    TORCH_CUDA_ARCH_LIST="8.0 8.6 9.0"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    libgl1 \
    libglib2.0-0 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Ensure python3 points to python3.10 (remove existing link first if needed)
RUN if [ -L "/usr/bin/python3" ]; then rm /usr/bin/python3; fi && \
    ln -s /usr/bin/python3.10 /usr/bin/python3

# Create and activate a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Clone the Stable Diffusion WebUI Forge repository
WORKDIR /app
RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN pip install -r requirements_versions.txt

# Add model download script
COPY download_models.sh /app/download_models.sh
RUN chmod +x /app/download_models.sh

# Create a directory for models
RUN mkdir -p /app/models/Stable-diffusion

# Expose the web UI port
EXPOSE 7860

# Entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]