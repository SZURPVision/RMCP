{ self, ... }:
{
  perSystem = { pkgs,config, ... }:
  {
    packages = {
      rmcp-src = pkgs.callPackage ./rmcp-src/package.nix { src = self; };
      rmcp-cpp = pkgs.callPackage ./rmcp-cpp/package.nix { src = config.packages.rmcp-src; };
      default = config.packages.rmcp-src;
    };
  };
}