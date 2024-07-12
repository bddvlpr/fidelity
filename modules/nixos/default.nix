{lib, ...}:
with builtins; let
  modules = lib.attrsets.filterAttrs (module: type: type == "directory") (readDir ./.);
in
  mapAttrs (k: _: import ./${k}) modules
