{ pkgs, lib, ... }:
# Lokale KI: llama.cpp (Vulkan) + llama-swap, Open WebUI und ComfyUI (ROCm) als Podman-Container.
# Browser: http://localhost:3000 (Open WebUI), ComfyUI direkt: http://localhost:8188
# Modelle laden: ~/nixos-flakes/scripts/ai-models.sh
let
  aiDir = "/mnt/Big_SSD/ai";
  llmDir = "${aiDir}/llm";

  llamaCpp = pkgs.llama-cpp.override { vulkanSupport = true; };
  llamaServer = "${llamaCpp}/bin/llama-server";
  # --fit (Standard: an) verteilt Layer/MoE-Experten selbst auf VRAM und RAM
  serve = args: "${llamaServer} --port \${PORT} --no-webui ${args}";

  # ComfyUI-Quellcode aus nixpkgs (gepinnt), läuft im Container mit PyTorch-ROCm-Wheels
  comfySrc = pkgs.comfyui.src;
  torchIndex = "https://download.pytorch.org/whl/rocm10.0";
  comfyEntry = pkgs.writeText "comfyui-entry.sh" ''
    set -eu
    VENV=/data/venv
    WANT="${torchIndex} $(sha256sum /app/requirements.txt | cut -d' ' -f1)"
    [ -x "$VENV/bin/python" ] || python -m venv "$VENV"
    if [ "$(cat "$VENV/.stamp" 2>/dev/null)" != "$WANT" ]; then
      "$VENV/bin/pip" install --no-cache-dir torch torchvision torchaudio --index-url ${torchIndex}
      "$VENV/bin/pip" install --no-cache-dir -r /app/requirements.txt
      echo "$WANT" > "$VENV/.stamp"
    fi
    mkdir -p /data/custom_nodes /data/input /data/output /data/models /data/user /data/temp
    cd /data
    exec "$VENV/bin/python" /app/main.py --base-directory /data \
      --listen 127.0.0.1 --port 8188 --disable-smart-memory
  '';

  # Z-Image-Turbo, offizieller ComfyUI-Workflow im API-Format (fp8-Gewichte -> ~6 GB VRAM)
  zImageWorkflow = builtins.toJSON {
    "28" = {
      class_type = "UNETLoader";
      inputs = {
        unet_name = "z_image_turbo_bf16.safetensors";
        weight_dtype = "fp8_e4m3fn";
      };
    };
    "30" = {
      class_type = "CLIPLoader";
      inputs = {
        clip_name = "qwen_3_4b.safetensors";
        type = "lumina2";
        device = "default";
      };
    };
    "29" = {
      class_type = "VAELoader";
      inputs = {
        vae_name = "ae.safetensors";
      };
    };
    "11" = {
      class_type = "ModelSamplingAuraFlow";
      inputs = {
        shift = 3;
        model = [
          "28"
          0
        ];
      };
    };
    "27" = {
      class_type = "CLIPTextEncode";
      inputs = {
        text = "";
        clip = [
          "30"
          0
        ];
      };
    };
    "33" = {
      class_type = "ConditioningZeroOut";
      inputs = {
        conditioning = [
          "27"
          0
        ];
      };
    };
    "13" = {
      class_type = "EmptySD3LatentImage";
      inputs = {
        width = 1024;
        height = 1024;
        batch_size = 1;
      };
    };
    "3" = {
      class_type = "KSampler";
      inputs = {
        seed = 0;
        steps = 8;
        cfg = 1;
        sampler_name = "res_multistep";
        scheduler = "simple";
        denoise = 1;
        model = [
          "11"
          0
        ];
        positive = [
          "27"
          0
        ];
        negative = [
          "33"
          0
        ];
        latent_image = [
          "13"
          0
        ];
      };
    };
    "8" = {
      class_type = "VAEDecode";
      inputs = {
        samples = [
          "3"
          0
        ];
        vae = [
          "29"
          0
        ];
      };
    };
    "9" = {
      class_type = "SaveImage";
      inputs = {
        filename_prefix = "openwebui";
        images = [
          "8"
          0
        ];
      };
    };
  };
  zImageNodes = builtins.toJSON [
    {
      type = "prompt";
      key = "text";
      node_ids = [ "27" ];
    }
    {
      type = "model";
      key = "unet_name";
      node_ids = [ "28" ];
    }
    {
      type = "width";
      key = "width";
      node_ids = [ "13" ];
    }
    {
      type = "height";
      key = "height";
      node_ids = [ "13" ];
    }
    {
      type = "steps";
      key = "steps";
      node_ids = [ "3" ];
    }
    {
      type = "seed";
      key = "seed";
      node_ids = [ "3" ];
    }
    {
      type = "n";
      key = "batch_size";
      node_ids = [ "13" ];
    }
  ];
in
{
  environment.systemPackages = [
    llamaCpp
    pkgs.nvtopPackages.amd
  ];

  environment.shellAliases.ki-unload = "curl -s http://127.0.0.1:9292/unload";

  systemd.tmpfiles.rules = [
    "d ${aiDir} 0755 lmlzr users -"
    "d ${llmDir} 0755 lmlzr users -"
    "d ${aiDir}/comfyui 0755 lmlzr users -"
    "d ${aiDir}/open-webui 0755 lmlzr users -"
  ];

  # LLMs: llama-swap startet pro Modell einen llama-server und entlädt ihn nach ttl Sekunden
  services.llama-swap = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 9292;
    settings = {
      healthCheckTimeout = 300;
      models = {
        # schnell, komplett im VRAM, versteht Bilder
        "gemma-4-12b" = {
          cmd = serve "-m ${llmDir}/gemma-4-12b-it-qat-q4_0.gguf --mmproj ${llmDir}/mmproj-gemma-4-12b-it-qat-q4_0.gguf -c 32768";
          ttl = 600;
        };
        # MoE 35B/3B aktiv: Experten teils im RAM, gut fuer Code und schwere Fragen, versteht Bilder
        "qwen3.6-35b-a3b" = {
          cmd = serve "-m ${llmDir}/Qwen3.6-35B-A3B-UD-IQ4_XS.gguf --mmproj ${llmDir}/mmproj-Qwen3.6-35B-A3B-F16.gguf -c 32768";
          ttl = 600;
        };
        # ohne Ablehnungen (abliterated/uncensored), fuer Erwachsenen-Inhalte
        "gemma-4-12b-uncensored" = {
          cmd = serve "-m ${llmDir}/Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf --mmproj ${llmDir}/mmproj-gemma-4-12b-it-qat-q4_0.gguf -c 32768";
          ttl = 600;
        };
        "qwen3.6-35b-abliterated" = {
          cmd = serve "-m ${llmDir}/Huihui-Qwen3.6-35B-A3B-abliterated-Q4_K.gguf --mmproj ${llmDir}/mmproj-Huihui-Qwen3.6-35B-A3B-f16.gguf -c 32768";
          ttl = 600;
        };
      };
    };
  };
  systemd.services.llama-swap = {
    unitConfig.RequiresMountsFor = aiDir;
    # Vulkan-Treiber (RADV) mag W^X-Sperre nicht immer
    serviceConfig.MemoryDenyWriteExecute = lib.mkForce false;
  };

  # nur Open WebUI ins LAN, ComfyUI/llama-swap bleiben auf localhost
  networking.firewall.interfaces."enp14s0".allowedTCPPorts = [ 3000 ];

  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers = {
    open-webui = {
      image = "ghcr.io/open-webui/open-webui:main";
      volumes = [ "${aiDir}/open-webui:/app/backend/data" ];
      extraOptions = [ "--network=host" ];
      environment = {
        HOST = "0.0.0.0"; # LAN (Handy): http://10.0.0.193:3000
        PORT = "3000";
        ENABLE_OLLAMA_API = "False";
        OPENAI_API_BASE_URL = "http://127.0.0.1:9292/v1";
        OPENAI_API_KEY = "none";
        ENABLE_IMAGE_GENERATION = "True";
        IMAGE_GENERATION_ENGINE = "comfyui";
        COMFYUI_BASE_URL = "http://127.0.0.1:8188";
        COMFYUI_WORKFLOW = zImageWorkflow;
        COMFYUI_WORKFLOW_NODES = zImageNodes;
        IMAGE_GENERATION_MODEL = "z_image_turbo_bf16.safetensors";
        IMAGE_SIZE = "1024x1024";
        IMAGE_STEPS = "8";
        ANONYMIZED_TELEMETRY = "false";
        DO_NOT_TRACK = "true";
        SCARF_NO_ANALYTICS = "true";
      };
    };

    comfyui = {
      image = "docker.io/library/python:3.13-slim";
      entrypoint = "/bin/sh";
      cmd = [ "/entry.sh" ];
      # als lmlzr, damit generierte Bilder in output/ dir gehoeren
      user = "1000:100";
      volumes = [
        "${aiDir}/comfyui:/data"
        "${comfySrc}:/app:ro"
        "${comfyEntry}:/entry.sh:ro"
      ];
      environment = {
        PYTHONDONTWRITEBYTECODE = "1";
        HOME = "/data/user";
      };
      extraOptions = [
        "--network=host"
        "--device=/dev/kfd"
        "--device=/dev/dri"
        "--security-opt=seccomp=unconfined"
      ];
    };
  };
  systemd.services.podman-open-webui.unitConfig.RequiresMountsFor = aiDir;
  systemd.services.podman-comfyui.unitConfig.RequiresMountsFor = aiDir;
}
