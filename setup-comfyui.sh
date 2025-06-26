#!/bin/bash
# ComfyUI full setup with models, manager, loras, and upscalers

echo "
========================================
🚀 Starting ComfyUI setup...
========================================
"

# Create base directories
echo "
----------------------------------------
📁 Creating base directories...
----------------------------------------"
mkdir -p /workspace/ComfyUI
mkdir -p /workspace/miniconda3

# Download and install Miniconda
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
    echo "✅ Miniconda already installed, skipping..."
fi

# Initialize conda in the shell
echo "
----------------------------------------
🐍 Initializing conda...
----------------------------------------"
eval "$(/workspace/miniconda3/bin/conda shell.bash hook)"

# Clone ComfyUI
echo "
----------------------------------------
📥 Cloning ComfyUI repository...
----------------------------------------"
if [ -d "/workspace/ComfyUI" ] && [ ! -d "/workspace/ComfyUI/.git" ]; then
    echo "⚠️  Removing broken or incomplete ComfyUI directory..."
    rm -rf /workspace/ComfyUI
fi
if [ ! -d "/workspace/ComfyUI/.git" ]; then
    git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI
else
    echo "✅ ComfyUI already cloned."
fi

# Clone ComfyUI-Manager
echo "
----------------------------------------
📥 Installing ComfyUI-Manager...
----------------------------------------"
MANAGER_DIR="/workspace/ComfyUI/custom_nodes/ComfyUI-Manager"
if [ -d "$MANAGER_DIR" ] && [ ! -d "$MANAGER_DIR/.git" ]; then
    echo "⚠️  Removing broken ComfyUI-Manager..."
    rm -rf "$MANAGER_DIR"
fi
if [ ! -d "$MANAGER_DIR" ]; then
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git "$MANAGER_DIR"
else
    echo "✅ ComfyUI-Manager already cloned."
fi

# Clone RyanOnTheInside
echo "
----------------------------------------
📥 Installing RyanOnTheInside nodes...
----------------------------------------"
RYAN_DIR="/workspace/ComfyUI/custom_nodes/ComfyUI_RyanOnTheInside"
if [ -d "$RYAN_DIR" ] && [ ! -d "$RYAN_DIR/.git" ]; then
    echo "⚠️  Removing broken RyanOnTheInside folder..."
    rm -rf "$RYAN_DIR"
fi
if [ ! -d "$RYAN_DIR" ]; then
    git clone https://github.com/ryanontheinside/ComfyUI_RyanOnTheInside.git "$RYAN_DIR"
else
    echo "✅ RyanOnTheInside nodes already cloned."
fi

# Create conda environment
echo "
----------------------------------------
🌟 Creating conda environment...
----------------------------------------"
if ! conda info --envs | grep -q "comfyui"; then
    conda create -n comfyui python=3.11 -y
else
    echo "✅ comfyui environment already exists, skipping..."
fi

# Activate conda env
echo "
----------------------------------------
🔧 Setting up comfyui environment...
----------------------------------------"
set -x
conda activate comfyui
set +x

# Install ComfyUI requirements
cd /workspace/ComfyUI
echo "📦 Installing ComfyUI requirements..."
pip install -r requirements.txt

cd custom_nodes/ComfyUI-Manager
echo "📦 Installing ComfyUI-Manager requirements..."
pip install -r requirements.txt

if [ -f "$RYAN_DIR/requirements.txt" ]; then
    cd "$RYAN_DIR"
    echo "📦 Installing RyanOnTheInside requirements..."
    pip install -r requirements.txt
fi

# Download models
echo "
----------------------------------------
📥 Downloading models...
----------------------------------------"
MODEL_DIR="/workspace/ComfyUI/models/checkpoints"
mkdir -p "$MODEL_DIR"
cd "$MODEL_DIR"
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/v1-5-pruned-emaonly-fp16.safetensors
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/redcraftCADSUpdatedJUN1_illust3relustion.safetensors
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/ponyRealism_V23ULTRA.safetensors
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/cyberrealisticPony_v120.safetensors
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/pornmasterPro_realismILV2VAE.safetensors

# Download LoRAs
echo "
----------------------------------------
📥 Downloading LoRAs...
----------------------------------------"
LORA_DIR="/workspace/ComfyUI/models/loras"
mkdir -p "$LORA_DIR"
cd "$LORA_DIR"
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/pony%20breasts%20horny%20areolas%20(horny%20areolas)%20own%200999.safetensors
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/Perfect_Booty_XL_V1.safetensors
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/Dramatic%20Lighting%20Slider.safetensors
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/Breast%20Size%20Slider.safetensors
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/aidmaRealisticSkin-IL-v0.1.safetensors
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/PerfectEyesXL.safetensors
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/ILXL_Realism_Slider_V.1.safetensors

# Download upscaler
echo "
----------------------------------------
📥 Downloading upscaler...
----------------------------------------"
UPSCALER_DIR="/workspace/ComfyUI/models/upscale_models"
mkdir -p "$UPSCALER_DIR"
cd "$UPSCALER_DIR"
wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/remacri_original.pt

# Deactivate environment
echo "🔄 Deactivating comfyui environment..."
conda deactivate

echo "
========================================
✨ Setup complete! Ready to launch ComfyUI ✨
========================================

📌 Run these after server starts:
1️⃣  /workspace/miniconda3/bin/conda init bash
2️⃣  conda activate comfyui
3️⃣  cd /workspace/ComfyUI && python main.py --listen
"
