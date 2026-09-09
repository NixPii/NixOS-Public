{
  config,
  lib,
  pkgs,
  ...
}: let
  unityhub = pkgs.unityhub;

  fhsBin = "${unityhub.fhsEnv}/bin/unityhub-fhs-env";

  # Same wrapper works for every Unity version because it determines
  # Unity.real relative to its own location.
  unityWrapper = pkgs.writeShellScript "unity-fhs-wrapper" ''
    real="$(dirname "$0")/Unity.real"

    exec -a "$real" \
      "${fhsBin}" \
      "$real" \
      "$@"
  '';
in {
  home.packages = [
    pkgs.alcom
    unityhub
  ];

  home.activation.wrapUnityEditors = lib.hm.dag.entryAfter ["writeBoundary"] ''
    for unity in "$HOME"/Unity/Hub/Editor/*/Editor/Unity; do
      # Glob matched nothing
      [ -e "$unity" ] || continue

      editor="$(dirname "$unity")"

      # First time we encounter this Unity installation:
      # preserve the real executable.
      if [ ! -e "$editor/Unity.real" ]; then
        echo "Wrapping Unity editor: $editor"

        $DRY_RUN_CMD mv \
          "$editor/Unity" \
          "$editor/Unity.real"
      fi

      # Put our FHS wrapper where Unity normally lives.
      $DRY_RUN_CMD install -m755 \
        ${unityWrapper} \
        "$editor/Unity"
    done
  '';
}
