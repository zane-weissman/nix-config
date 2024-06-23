{
  config,
  lib,
  pkgs,
  ...
}:

let
  ### FUNCTIONS #####
  myFuncs = {
    src =
      s:
      builtins.listToAttrs (
        map (x: {
          name = x;
          value = {
            source = ./. + ("/" + x);
          };
        }) s
      );

    sym = s: config.lib.file.mkOutOfStoreSymlink ("${config.xdg.configHome}/home-manager/${s}");

    recursiveFiles =
      let
        listFilesRecursive =
          dir: acc:
          pkgs.lib.flatten (
            pkgs.lib.mapAttrsToList (
              k: v: if v == "regular" then "${acc}${k}" else listFilesRecursive dir "${acc}${k}/"
            ) (builtins.readDir "${dir}/${acc}")
          );
      in
      dir:
      builtins.listToAttrs (
        map (x: {
          name = x;
          value = {
            source = "${dir}/${x}";
          };
        }) (listFilesRecursive dir "")
      );
  };
in
{

  imports = [
    ./nvim.nix
    ./alacritty.nix
  ];

  options =
    let
      inherit (lib) mkOption types;
    in
    {
      font = mkOption { type = types.attrsOf types.anything; };
    };

  config = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.

    targets.genericLinux.enable = true;

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = [ pkgs.qtile ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file =
      let
        inherit (myFuncs) src;
      in
      src [
        #".alacritty.yml"
      ]
      // {
        #".alacritty.yml".source = ./.alacritty.yml;
        "./.fonts".source = ./fontconfig/fonts;
      };

    # or using XDG config directory
    xdg.configFile =
      let
        inherit (myFuncs) src;
      in
      src [
        #"fontconfig/fonts.conf"
        "qtile/"
        "nvim/lua"
      ]
      // {
        "fish/functions/".source = ./fish/functions;
        "fontconfig/fonts.conf".text = ''
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <dir prefix="relative">
              fonts
            </dir>
          </fontconfig>
        '';
      };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/zane/etc/profile.d/hm-session-vars.sh
    #
    home.sessionVariables = {
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "/home/zane/.config/";
      MOZ_USE_XINPUT2 = "1";

      SSHFS_OPTS = "auto_cache,reconnect,no_readahead";
      SSHFS_CIPHERS = "aes128-ctr"; #,aes128-gcm@openssh.com,aes128-cbc'
      PATH = builtins.concatStringsSep ":" [
        "/home/zane/.cargo/bin"
        "/home/zane/.nix-profile/bin"
        "/nix/var/nix/profiles/default/bin"
        "/usr/local/bin"
        "/usr/bin"
        "/bin"
        "/usr/local/games"
        "/usr/games"
        "/snap/bin"
        "/sbin"
        "/usr/sbin"
        "/home/zane/.local/bin"
      ];
    };

    # Let Home Manager install and manage itself.
    programs.home-manager = {
      enable = true;
      #backupFileExtension = "backup";
    };

    # more programs
    programs = {
      fish = {
        enable = true;
        shellInit = builtins.readFile fish/theme.fish;
        interactiveShellInit = "
          fish_vi_key_bindings
          set fish_cursor_default block
          set fish_cursor_insert line
          set fish_vi_force_cursor
        ";
        shellAbbrs =
          let
            withCursor = exp: {
              expansion = exp;
              setCursor = true;
            };
          in
          {
            fdi = "find . -iname";
            lsmnt = "findmnt";
            vsbs = withCursor "vim scp://zane@sunar/Leapfrog/%";
            sbs = {
              expansion = "scp://zane@sunar/Leapfrog/%";
              setCursor = true;
              position = "anywhere";
            };
            nvsbs = withCursor "nvim scp://zane@sunar/Leapfrog/%";
            vskem = withCursor "vim scp://kemal-ddr4@kemal/Desktop/memory_mayhem_kristi/%";
            sfsbs = withCursor ''
            SUNAR="autoreg-203842.dyn.wpi.edu" sshfs zane@$SUNAR:/home/zane/ ~/mnt/berksunar -o$SSHFS_OPTS,Ciphers=$SSHFS_CIPHERS; cd ~/mnt/berksunar/%
            ''
            gca = withCursor "git commit -am \"%\"";
            gcm = withCursor "git commit -m \"%\"";
          };
        shellAliases = {
          #cd = "z";
          mkdir = "mkdir -p";
          mv = "mv -i";
          rm = "rm -i";
          cp = "cp -i";
          grep = "grep --color=auto";
          vim = "nvim";
        };
        functions = {
          #sfsbs =  
        };
        # more functions sourced from ./fish/functions/ to xdg-config
      };
      bat.enable = true;
      fzf = {
        enable = true;
        enableFishIntegration = true;
      };
      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };
      git = {
        enable = true;
        userName = "Zane Weissman";
        userEmail = "zweissman@wpi.edu";
        ignores = [
          "**/*.sw*"
          "**/__pycache__"
        ];
        extraConfig = {
          credential = {
            helper = [
              "cache --timeout 3600"
              "!pass-git-helper $@"
            ];
            #helper = "!pass-git-helper $@";
          };
        };
      };
      lazygit.enable = true;
      neovim.enable = true;
      gpg.enable = false;
      password-store.enable = false;
      ssh.enable = false;
      vim.enable = false;
      alacritty = {
        #enable = true;
        settings.font.size = config.font.size.normal;
        settings.font.normal.family = config.font.family;
        #settings = import ./alacritty.nix;
      };
    };
  };
}
