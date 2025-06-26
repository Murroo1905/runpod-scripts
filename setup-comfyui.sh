#!/bin/bash
# ComfyUI Setup Script for RunPod - Includes Checkpoints and LoRAs

echo "
========================================
🚀 Starting ComfyUI + Models Setup...
========================================
"

# -----------------------------
# 🔧 Create directories
# -----------------------------
mkdir -p /workspace/ComfyUI/models/checkpoints
mkdir -p /workspace/ComfyUI/models/loras
mkdir -p /workspace/miniconda3

# -----------------------------
# 🐍 Install Miniconda
# -----------------------------
if [ ! -f "/workspace/miniconda3/bin/conda" ]; then
    cd /workspace/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x Miniconda3-latest-Linux-x86_64.sh
    ./Miniconda3-latest-Linux-x86_64.sh -b -p /workspace/miniconda3
else
    echo "✅ Miniconda already installed, skipping..."
fi

# Initialize conda in the shell
eval "$(/workspace/miniconda3/bin/conda shell.bash hook)"

# -----------------------------
# 🧠 Clone ComfyUI + Nodes
# -----------------------------
if [ ! -d "/workspace/ComfyUI/.git" ]; then
    git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI
fi

# ComfyUI Manager
if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-Manager" ]; then
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git /workspace/ComfyUI/custom_nodes/ComfyUI-Manager
fi

# -----------------------------
# 🌱 Create Conda environment
# -----------------------------
if ! conda info --envs | grep -q "comfyui"; then
    conda create -y -n comfyui python=3.11
fi

# Activate environment
conda activate comfyui

# -----------------------------
# 📦 Install requirements
# -----------------------------
cd /workspace/ComfyUI
pip install -r requirements.txt

cd /workspace/ComfyUI/custom_nodes/ComfyUI-Manager
pip install -r requirements.txt

# -----------------------------
# 💾 Download Models
# -----------------------------
cd /workspace/ComfyUI/models/checkpoints

wget -nc -O v1-5-pruned-emaonly-fp16.safetensors \
  https://huggingface.co/Muro1905/comfyui-models/resolve/main/v1-5-pruned-emaonly-fp16.safetensors

wget -nc -O redcraftCADSUpdatedJUN1_illust3relustion.safetensors \
  https://huggingface.co/Muro1905/comfyui-models/resolve/main/redcraftCADSUpdatedJUN1_illust3relustion.safetensors

wget -nc -O ponyRealism_V23ULTRA.safetensors \
  https://huggingface.co/Muro1905/comfyui-models/resolve/main/ponyRealism_V23ULTRA.safetensors

wget -nc -O cyberrealisticPony_v120.safetensors \
  https://huggingface.co/Muro1905/comfyui-models/resolve/main/cyberrealisticPony_v120.safetensors

# -----------------------------
# 💾 Download LoRAs
# -----------------------------
cd /workspace/ComfyUI/models/loras

wget -nc -O pony_breasts_horny_areolas.safetensors \
  https://huggingface.co/Muro1905/comfyui-models/resolve/main/pony%20breasts%20horny%20areolas%20(horny%20areolas)%20own%200999.safetensors

wget -nc -O Perfect_Booty_XL_V1.safetensors \
  https://huggingface.co/Muro1905/comfyui-models/resolve/main/Perfect_Booty_XL_V1.safetensors

wget -nc -O Dramatic_Lighting_Slider.safetensors \
  https://huggingface.co/Muro1905/comfyui-models/resolve/main/Dramatic%20Lighting%20Slider.safetensors

wget -nc -O Breast_Size_Slider.safetensors \
  https://huggingface.co/Muro1905/comfyui-models/resolve/main/Breast%20Size%20Slider.safetensors

echo "
✅ All models and LoRAs downloaded successfully!
"

echo "
========================================
✨ Setup Complete! You can now launch ComfyUI:
cd /workspace/ComfyUI
python3 main.py --listen 0.0.0.0 --port 8188
========================================
"

