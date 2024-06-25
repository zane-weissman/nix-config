{
  src =
    sourceDir: s:
    builtins.listToAttrs (
      map (x: {
        name = x;
        value = {
          source = sourceDir + ("/" + x);
        };
      }) s
    );

  #sym = s: config.lib.file.mkOutOfStoreSymlink ("${config.xdg.configHome}/home-manager/${s}");

  #recursiveFiles =
  #  let
  #    listFilesRecursive =
  #      dir: acc:
  #      pkgs.lib.flatten (
  #        pkgs.lib.mapAttrsToList (
  #          k: v: if v == "regular" then "${acc}${k}" else listFilesRecursive dir "${acc}${k}/"
  #        ) (builtins.readDir "${dir}/${acc}")
  #      );
  #  in
  #  dir:
  #  builtins.listToAttrs (
  #    map (x: {
  #      name = x;
  #      value = {
  #        source = "${dir}/${x}";
  #      };
  #    }) (listFilesRecursive dir "")
  #  );
}
