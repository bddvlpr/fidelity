{
  mkTest,
  lib,
  self,
  alejandra,
}:
mkTest {
  name = "fmt";

  src = lib.sourceFilesBySuffices self [".nix"];

  checkInputs = [alejandra];
  checkPhase = ''
    mkdir -p $out
    alejandra --check . | tee $out/fmt.log
  '';
}
