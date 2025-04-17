#!/bin/bash

# Run the model download script
if [ "$SKIP_MODEL_DOWNLOAD" != "true" ]; then
    /app/download_models.sh
fi

# Start the web UI
cd /app
exec python launch.py --listen --port 7860 --enable-insecure-extension-access --xformers