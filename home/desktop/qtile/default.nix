{
  config,
  lib,
  pkgs,
  ...
}:

let
  myFuncs = import ../../lib/src.nix;
in
{
  config = {
    xdg.configFile =
      let
        inherit (myFuncs) src;
      in
      src ./. [ "qtile" ];
  };
}
