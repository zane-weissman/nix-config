{
  description = "zane's nixos and home manager flake";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-colors,
      nixos-cosmic,
      nixos-hardware,
      nix-flatpak,
    }@inputs:
    {
      nixosConfigurations = {
        "adelaide" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos
            ./nixos/desktop
            ./nixos/desktop/gaming.nix
            ./nixos/desktop/plasma6.nix
            ./nixos/hosts/adelaide.nix
            nixos-cosmic.nixosModules.default
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
          ];
        };
        "frances" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos
            ./nixos/desktop
            ./nixos/desktop/plasma6.nix
            ./nixos/hosts/frances.nix
            #./nixos/desktop/cosmic.nix
            nixos-hardware.nixosModules.framework-13-7040-amd
            nix-flatpak.nixosModules.nix-flatpak
            # nixos-cosmic.nixosModules.default
            # {
            #   nix.settings = {
            #     substituters = [ "https://cosmic.cachix.org/" ];
            #     trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            #   };
            # }
          ];
        };
        "natalia" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./nixos
            ./nixos/hosts/natalia.nix
          ];
        };
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
                ./home/desktop
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
          "zane@frances" = home-manager.lib.homeManagerConfiguration (
            withColors
            // {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              modules = [
                ./home
                ./home/desktop
                ./home/hosts/frances.nix
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
          "zane@adelaide" = home-manager.lib.homeManagerConfiguration (
            withColors
            // {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              modules = [
                ./home
                ./home/desktop
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
                ./home/desktop
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
          "zane@natalia" = home-manager.lib.homeManagerConfiguration ({
            pkgs = nixpkgs.legacyPackages.aarch64-linux;
            modules = [ ./home ];
          });
        };
    };
}
