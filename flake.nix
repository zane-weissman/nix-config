{
  description = "zane's home manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    {
      nixosConfigurations."adelaide" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };

      homeConfigurations = {
        "zane@lydia" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home
            {
              # extra nix config goes here
              home = {
                username = "zane";
                homeDirectory = "/home/zane";
                stateVersion = "23.11"; # Please read the comment before changing.
              };
              font = {

                size = {
                  small = 10.5;
                  normal = 13.5;
                  big = 16.5;
                };
                family = "ComicMono Nerd Font";
              };
            }
          ];
        };
        "zane@adelaide" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home
            {
              # extra nix config goes here
              home = {
                username = "zane";
                homeDirectory = "/home/zane";
                stateVersion = "23.11"; # Please read the comment before changing.
              };
              font = {

                size = {
                  small = 8;
                  normal = 10;
                  big = 12;
                };
                family = "ComicMono Nerd Font";
              };
            }
          ];
        };
        "zane@clara" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          modules = [
            #./device/clara/
            ./home
            {
              # extra nix config goes here
              home = {
                username = "zane";
                homeDirectory = "/home/zane";
                stateVersion = "23.11"; # Please read the comment before changing.
              };
              font = {
                size = {
                  small = 16;
                  normal = 20;
                  big = 24;
                };
                family = "ComicMono Nerd Font";
              };
            }
          ];
        };
      };
    };
}
