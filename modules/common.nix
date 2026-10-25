{ ... }:
{
  # Gemeinsame Basis für desktop, laptop und vm
  systemd.services."systemd-oomd".enable = false;
  boot.initrd.systemd.enable = true;
}
