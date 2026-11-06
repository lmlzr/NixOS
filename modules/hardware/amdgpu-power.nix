{ ... }:
# RX 7700 XT: Overdrive freischalten, damit LACT undervolten / Power-Limit anheben kann.
# Werte in der LACT-GUI einstellen; erst wenn stabil (Spiele + KI-Last), ggf. hier fest eintragen.
# Idle-Strom: VRAM-Takt bleibt bei 144+75+60 Hz auf Maximum (~40 W idle).
# Gemessen 2026-11-06: 120+60+60 Hz -> VRAM taktet runter, ~28 W idle.
{
  hardware.amdgpu.overdrive.enable = true;
  services.lact.enable = true;
}
