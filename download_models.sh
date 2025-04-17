#!/bin/bash

# Directory where models will be downloaded
MODEL_DIR="/app/models/Stable-diffusion"

# List of models to download (add or remove as needed)
MODELS=(
    "https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors"
    "https://huggingface.co/Comfy-Org/flux1-dev/resolve/main/flux1-dev-fp8.safetensors"
)

# Download function
download_model() {
    local url=$1
    local filename=$(basename "$url")
    local filepath="$MODEL_DIR/$filename"
    
    if [ ! -f "$filepath" ]; then
        echo "Downloading $filename..."
        wget -q --show-progress -O "$filepath" "$url"
        
        if [ $? -eq 0 ]; then
            echo "Successfully downloaded $filename"
        else
            echo "Failed to download $filename"
            rm -f "$filepath" 2>/dev/null
        fi
    else
        echo "$filename already exists, skipping download"
    fi
}

# Create model directory if it doesn't exist
mkdir -p "$MODEL_DIR"

# Download all models
for model_url in "${MODELS[@]}"; do
    download_model "$model_url"
done

echo "Model download complete"