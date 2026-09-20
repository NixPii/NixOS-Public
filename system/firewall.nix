{
  config,
  pkgs,
  ...
}: {
  # --- Core Networking ---
  networking.nftables.enable = true;

  # --- Network Manager & Interface Tweaks ---

  # --- Firewall ---
  networking = {
    firewall = {
      enable = true;
      checkReversePath = "loose";
      trustedInterfaces = [config.services.tailscale.interfaceName "virbr0"];

      allowedUDPPorts = [
        config.services.tailscale.port
        9757
        5353
        10767
      ];

      allowedTCPPorts = [
        9757
        10767
      ];
    };

    nameservers = [
      #"1.1.1.1"
      #"1.0.0.1"
      "127.0.0.1"
      "::1"
    ];
  };

  # --- Tailscale Mesh ---
  services.tailscale.enable = true;
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  # --- DNS Fix ---
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNS = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
        FallbackDNS = ["1.1.1.1#one.one.one.one 1.0.0.1#one.one.one.one"];
        DNSSEC = "yes";
        DNSOverTLS = "yes";
        Domains = "~.";
      };
    };
  };

  # --- Boot & Performance Tweaks ---
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
}
