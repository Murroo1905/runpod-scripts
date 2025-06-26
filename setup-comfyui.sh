#!/bin/bash
# ComfyUI Full Auto Setup Script (Updated with models, LoRAs, upscaler)

echo "🚀 Starting ComfyUI setup..."

# Create workspace structure
mkdir -p /workspace/ComfyUI
mkdir -p /workspace/miniconda3
mkdir -p /workspace/ComfyUI/models/checkpoints
mkdir -p /workspace/ComfyUI/models/loras
mkdir -p /workspace/ComfyUI/models/upscale_models

# Download and install Miniconda
if [ ! -f "/workspace/miniconda3/bin/conda" ]; then
    cd /workspace/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x Miniconda3-latest-Linux-x86_64.sh
    ./Miniconda3-latest-Linux-x86_64.sh -b -p /workspace/miniconda3 -f
fi

# Initialize conda
eval "$(/workspace/miniconda3/bin/conda shell.bash hook)"

# Clone ComfyUI
if [ ! -d "/workspace/ComfyUI/.git" ]; then
    git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI
fi

# Clone custom nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git /workspace/ComfyUI/custom_nodes/ComfyUI-Manager
git clone https://github.com/ryanontheinside/ComfyUI_RyanOnTheInside.git /workspace/ComfyUI/custom_nodes/ComfyUI_RyanOnTheInside

# Create environment if not exists
if ! conda info --envs | grep -q "comfyui"; then
    conda create -n comfyui python=3.11 -y
fi

# Activate environment
conda activate comfyui

# Install requirements
pip install -r /workspace/ComfyUI/requirements.txt
pip install -r /workspace/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt

REQ_RYAN="/workspace/ComfyUI/custom_nodes/ComfyUI_RyanOnTheInside/requirements.txt"
if [ -f "$REQ_RYAN" ]; then
    pip install -r "$REQ_RYAN"
fi

# Download Checkpoints
cd /workspace/ComfyUI/models/checkpoints

declare -a MODELS=(
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/v1-5-pruned-emaonly-fp16.safetensors"
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/redcraftCADSUpdatedJUN1_illust3relustion.safetensors"
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/ponyRealism_V23ULTRA.safetensors"
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/cyberrealisticPony_v120.safetensors"
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/pornmasterPro_realismILV2VAE.safetensors"
)

for URL in "${MODELS[@]}"; do
    wget -N "$URL"
done

# Download LoRAs
cd /workspace/ComfyUI/models/loras

declare -a LORAS=(
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/pony%20breasts%20horny%20areolas%20(horny%20areolas)%20own%200999.safetensors"
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/Perfect_Booty_XL_V1.safetensors"
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/Dramatic%20Lighting%20Slider.safetensors"
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/Breast%20Size%20Slider.safetensors"
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/aidmaRealisticSkin-IL-v0.1.safetensors"
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/PerfectEyesXL.safetensors"
"https://huggingface.co/Muro1905/comfyui-models/resolve/main/ILXL_Realism_Slider_V.1.safetensors"
)

for URL in "${LORAS[@]}"; do
    wget -N "$URL"
done

# Download Upscaler
cd /workspace/ComfyUI/models/upscale_models

wget -N https://huggingface.co/Muro1905/comfyui-models/resolve/main/remacri_original.pt

# Deactivate
conda deactivate

echo "✅ All done. Launch ComfyUI with:"
echo "
-----------------------------------
eval \"\$(/workspace/miniconda3/bin/conda shell.bash hook)\"
conda activate comfyui
cd /workspace/ComfyUI
python3 main.py --listen 0.0.0.0 --port 8188
-----------------------------------
"


