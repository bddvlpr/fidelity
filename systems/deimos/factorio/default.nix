{ pkgs, ... }:
{
  services.factorio = {
    enable = true;
    openFirewall = true;
    package = pkgs.factorio-space-age;
  };
}
