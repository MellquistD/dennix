{
  self,
  inputs,
  ...
}: {
  # Import and configure home-manager
  flake.nixosModules.homeManager = {pkgs, ...}: {
    imports = [
      # Import home manager
      inputs.home-manager.nixosModules.default
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };
  };
}
