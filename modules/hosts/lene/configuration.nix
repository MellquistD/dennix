{
  self,
  inputs,
  ...
}: {
  # Nixos configuration entry point
  flake.nixosConfigurations.Lene = inputs.nixpkgs.lib.nixosSystem {
    imports = [
      ./hardware-configuration.nix
    ];

    modules = [
      self.nixosModules.Lene
      self.nixosModules.homeManager
    ];
  };

  # Actual nixos configuration
  flake.nixosModules.Lene = {pkgs, ...}: {
    modules = [
      self.nixosModules.hyprland
    ];

    users.users.jdenn = {
      isNormalUser = true;
      shell = pkgs.bash;
    };

    home-manager.users.jdenn = self.homeModules.jdenn;

    environment.systemPackages = with pkgs; [
      udiskie
    ];
  };
}
