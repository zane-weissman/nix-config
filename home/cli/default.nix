{
  config, lib, pkgs, ...
}:

let
  myFuncs = import ../../lib/src.nix;
in
{
  imports = [
    ./nvim.nix
  ];

  config = {

    home.file = {
      # lazy secrets, but eventually git repo can be public
      ".password-store" = {
        source = ../../secrets/pass
      };
      ".ssh" = {
        source = ../../secrets/ssh
        recursive = true;
      };
    };
  
    xdg.configFile = 
      let 
        inherit (myFuncs) src;
      in
      src ./. [
        "nvim/lua"
        "fish/functions"
      ]; 

    home.sessionVariables = {
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "/home/zane/.config/";

      SSHFS_OPTS = "auto_cache,reconnect,no_readahead";
      SSHFS_CIPHERS = "aes128-ctr"; #,aes128-gcm@openssh.com,aes128-cbc'
      PATH = builtins.concatStringsSep ":" [
        "$PATH"
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
            '';
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
          init.defaultBranch = "main";
        };
      };
      lazygit.enable = true;
      neovim.enable = true;
      gpg.enable = false;
      password-store = { 
        enable = true;
        settings = { PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store"; };
      };
      ssh.enable = false;
      vim.enable = false;
    };
  };
}
