#!/bin/bash
set -e

# Source the bash profile to get Python in PATH
source ~/.bashrc

# Source environment variables from .env file if it exists
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Create the ~/.anthropic directory if it doesn't exist
mkdir -p ~/.anthropic

# Save WANDB_API_KEY to ~/.anthropic/wandb_api_key
if [ -n "$WANDB_API_KEY" ]; then
    echo "$WANDB_API_KEY" > ~/.anthropic/wandb_api_key
    chmod 600 ~/.anthropic/wandb_api_key
fi

# Save ANTHROPIC_API_KEY to ~/.anthropic/api_key
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "$ANTHROPIC_API_KEY" > ~/.anthropic/api_key
    chmod 600 ~/.anthropic/api_key
fi

# Save OPENAI_API_KEY to ~/.anthropic/openai_api_key
if [ -n "$OPENAI_API_KEY" ]; then
    echo "$OPENAI_API_KEY" > ~/.anthropic/openai_api_key
    chmod 600 ~/.anthropic/openai_api_key
fi

# Save GOOGLE_API_KEY to ~/.anthropic/gemini_api_key
if [ -n "$GOOGLE_API_KEY" ]; then
    echo "$GOOGLE_API_KEY" > ~/.anthropic/gemini_api_key
    chmod 600 ~/.anthropic/gemini_api_key
fi

# Start necessary services
./start_all.sh
./novnc_startup.sh

python http_server.py > /tmp/server_logs.txt 2>&1 &

STREAMLIT_SERVER_PORT=8501 python -m streamlit run computer_use_demo/streamlit.py > /tmp/streamlit_stdout.log &

echo "✨ Computer Use Demo is ready!"
echo "➡️  Open http://localhost:8080 in your browser to begin"

# Keep the container running
tail -f /dev/null
