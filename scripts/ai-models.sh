#!/usr/bin/env bash
# Laedt die Modelle fuer modules/system/ai.nix nach /mnt/Big_SSD/ai (~70 GB).
# Fortsetzbar: abgebrochene Downloads laufen beim naechsten Aufruf weiter.
set -euo pipefail

AI=/mnt/Big_SSD/ai
HF=https://huggingface.co

# get <repo> <pfad-im-repo> <zieldatei>
get() {
  local url="$HF/$1/resolve/main/$2" out="$3"
  if [[ -f "$out" ]]; then echo "ok   $out"; return; fi
  echo "load $out"
  mkdir -p "$(dirname "$out")"
  curl -fL --retry 5 -C - -o "$out.part" "$url"
  mv "$out.part" "$out"
}

# LLMs (llama-swap)
get google/gemma-4-12B-it-qat-q4_0-gguf gemma-4-12b-it-qat-q4_0.gguf        "$AI/llm/gemma-4-12b-it-qat-q4_0.gguf"
get google/gemma-4-12B-it-qat-q4_0-gguf mmproj-gemma-4-12b-it-qat-q4_0.gguf "$AI/llm/mmproj-gemma-4-12b-it-qat-q4_0.gguf"
get unsloth/Qwen3.6-35B-A3B-GGUF Qwen3.6-35B-A3B-UD-IQ4_XS.gguf             "$AI/llm/Qwen3.6-35B-A3B-UD-IQ4_XS.gguf"
get unsloth/Qwen3.6-35B-A3B-GGUF mmproj-F16.gguf                            "$AI/llm/mmproj-Qwen3.6-35B-A3B-F16.gguf"

# ohne Ablehnungen (uncensored / abliterated)
get huihui-ai/Huihui-Qwen3.6-35B-A3B-abliterated-MTP-GGUF Huihui-Qwen3.6-35B-A3B-abliterated-ggml-model-Q4_K.gguf "$AI/llm/Huihui-Qwen3.6-35B-A3B-abliterated-Q4_K.gguf"
get huihui-ai/Huihui-Qwen3.6-35B-A3B-abliterated-MTP-GGUF mmproj-model-f16.gguf "$AI/llm/mmproj-Huihui-Qwen3.6-35B-A3B-f16.gguf"

# Bildgenerierung (ComfyUI, Z-Image-Turbo)
Z=Comfy-Org/Z-Image-Turbo
get $Z split_files/diffusion_models/z_image_turbo_bf16.safetensors "$AI/comfyui/models/diffusion_models/z_image_turbo_bf16.safetensors"
get $Z split_files/text_encoders/qwen_3_4b.safetensors             "$AI/comfyui/models/text_encoders/qwen_3_4b.safetensors"
get $Z split_files/vae/ae.safetensors                              "$AI/comfyui/models/vae/ae.safetensors"

curl -s -d "KI-Modelle fertig geladen ($(du -sh "$AI" | cut -f1))" https://push.lmlzr.com/claude >/dev/null || true
echo "fertig"
