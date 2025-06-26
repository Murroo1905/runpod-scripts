#!/bin/bash
set -e  # exit on error

echo "
========================================
🚀 Starting full ComfyUI setup...
========================================
"

# Create base directories
echo "
----------------------------------------
📁 Creating base directories...
----------------------------------------"
mkdir -p /workspace/ComfyUI
mkdir -p /workspace/miniconda3
mkdir -p /workspace/ComfyUI/models/checkpoints
mkdir -p /workspace/ComfyUI/models/loras
mkdir -p /workspace/ComfyUI/models/upscale_models

# Download and install Miniconda if missing
echo "
----------------------------------------
📥 Downloading and installing Miniconda...
----------------------------------------"
if [ ! -f "/workspace/miniconda3/bin/conda" ]; then
    cd /workspace/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x Miniconda3-latest-Linux-x86_64.sh
    ./Miniconda3-latest-Linux-x86_64.sh -b -p /workspace/miniconda3 -f
else
    echo "Miniconda already installed, skipping..."
fi

# Initialize conda in shell
echo "
----------------------------------------
🐍 Initializing conda...
----------------------------------------"
eval "$(/workspace/miniconda3/bin/conda shell.bash hook)"

# Clone ComfyUI repos
echo "
----------------------------------------
📥 Cloning ComfyUI and custom nodes repos...
----------------------------------------"
if [ ! -d "/workspace/ComfyUI/.git" ]; then
    git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI
else
    echo "ComfyUI already cloned, skipping..."
fi

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-Manager/.git" ]; then
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git /workspace/ComfyUI/custom_nodes/ComfyUI-Manager
else
    echo "ComfyUI-Manager already cloned, skipping..."
fi

if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI_RyanOnTheInside/.git" ]; then
    git clone https://github.com/ryanontheinside/ComfyUI_RyanOnTheInside.git /workspace/ComfyUI/custom_nodes/ComfyUI_RyanOnTheInside
else
    echo "RyanOnTheInside nodes already cloned, skipping..."
fi

# Create conda environment if missing
echo "
----------------------------------------
🌟 Creating conda environment...
----------------------------------------"
if ! conda info --envs | grep -q "comfyui"; then
    conda create -n comfyui python=3.11 -y
else
    echo "conda environment 'comfyui' already exists, skipping creation..."
fi

# Activate comfyui env and install requirements
echo "
----------------------------------------
🔧 Activating comfyui environment & installing requirements...
----------------------------------------"
conda activate comfyui

cd /workspace/ComfyUI
pip install -r requirements.txt

cd custom_nodes/ComfyUI-Manager
pip install -r requirements.txt

if [ -f "/workspace/ComfyUI/custom_nodes/ComfyUI_RyanOnTheInside/requirements.txt" ]; then
    cd /workspace/ComfyUI/custom_nodes/ComfyUI_RyanOnTheInside
    pip install -r requirements.txt
fi

# Extra dependencies to avoid missing module errors
pip install einops

# Download all models, loras, upscalers
echo "
----------------------------------------
⬇️ Downloading models, loras, and upscalers...
----------------------------------------"

cd /workspace/ComfyUI/models/checkpoints
wget -nc -O v1-5-pruned-emaonly-fp16.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/v1-5-pruned-emaonly-fp16.safetensors
wget -nc -O redcraftCADSUpdatedJUN1_illust3relustion.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/redcraftCADSUpdatedJUN1_illust3relustion.safetensors
wget -nc -O ponyRealism_V23ULTRA.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/ponyRealism_V23ULTRA.safetensors
wget -nc -O cyberrealisticPony_v120.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/cyberrealisticPony_v120.safetensors
wget -nc -O pornmasterPro_realismILV2VAE.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/pornmasterPro_realismILV2VAE.safetensors

cd /workspace/ComfyUI/models/loras
wget -nc -O pony_breasts_horny_areolas_own_0999.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/pony%20breasts%20horny%20areolas%20(horny%20areolas)%20own%200999.safetensors
wget -nc -O Perfect_Booty_XL_V1.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/Perfect_Booty_XL_V1.safetensors
wget -nc -O Dramatic_Lighting_Slider.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/Dramatic%20Lighting%20Slider.safetensors
wget -nc -O Breast_Size_Slider.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/Breast%20Size%20Slider.safetensors
wget -nc -O aidmaRealisticSkin-IL-v0.1.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/aidmaRealisticSkin-IL-v0.1.safetensors
wget -nc -O PerfectEyesXL.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/PerfectEyesXL.safetensors
wget -nc -O ILXL_Realism_Slider_V.1.safetensors https://huggingface.co/Muro1905/comfyui-models/resolve/main/ILXL_Realism_Slider_V.1.safetensors

cd /workspace/ComfyUI/models/upscale_models
wget -nc -O remacri_original.pt https://huggingface.co/Muro1905/comfyui-models/resolve/main/remacri_original.pt

# Create placeholder files so ComfyUI recognizes folders properly
touch /workspace/ComfyUI/models/checkpoints/put_checkpoints_here
touch /workspace/ComfyUI/models/loras/put_loras_here
touch /workspace/ComfyUI/models/upscale_models/put_upscale_models_here

# Kill any existing ComfyUI process on port 8188 to avoid bind errors
echo "
----------------------------------------
🔍 Checking for existing ComfyUI processes on port 8188...
----------------------------------------"
EXISTING_PID=$(lsof -ti tcp:8188 || true)
if [ -n "$EXISTING_PID" ]; then
    echo "Killing process(es) on port 8188: $EXISTING_PID"
    kill -9 $EXISTING_PID
else
    echo "No processes on port 8188."
fi

echo "
----------------------------------------
✅ Setup complete! You can now run ComfyUI with:
cd /workspace/ComfyUI
conda activate comfyui
python3 main.py --listen 0.0.0.0 --port 8188
----------------------------------------
"



