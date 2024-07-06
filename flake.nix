{
  description = "zane's nixos and home manager flake";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-colors,
    }@inputs:
    {
      nixosConfigurations."adelaide" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos
          ./nixos/desktop
          ./nixos/desktop/gaming.nix
          ./nixos/desktop/plasma6.nix
        ];
      };

      homeConfigurations =
        let
          withColors = {
            extraSpecialArgs = {
              inherit nix-colors;
            };
          };
        in
        {
          "zane@lydia" = home-manager.lib.homeManagerConfiguration (
            withColors
            // {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              modules = [
                ./home
                ./home/desktop/i3
                {
                  font.size = {
                    small = 10.5;
                    normal = 13.5;
                    big = 16.5;
                  };
                }
              ];
            }
          );
          "zane@adelaide" = home-manager.lib.homeManagerConfiguration (
            withColors
            // {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              modules = [
                ./home
                {
                  font.size = {
                    small = 10;
                    normal = 12;
                    big = 14;
                  };
                }
              ];
            }
          );
          "zane@clara" = home-manager.lib.homeManagerConfiguration (
            withColors
            // {
              pkgs = nixpkgs.legacyPackages.aarch64-linux;
              modules = [
                #./device/clara/
                ./home
                {
                  font.size = {
                    small = 16;
                    normal = 20;
                    big = 24;
                  };
                }
              ];
            }
          );
        };
    };
}
