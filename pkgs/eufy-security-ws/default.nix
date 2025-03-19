{
  buildNpmPackage,
  inputs,
  lib,
}:
let
  input = inputs.eufy-security-ws;
in
buildNpmPackage {
  pname = "eufy-security-ws";
  version = input.rev;

  src = input;

  npmDepsHash = "sha256-0Zp3Qh80XvLOOdkEw38x7wctGYniRZpjIIXILa9meM8=";

  meta = {
    description = "Small server wrapper around eufy-security-client library to access it via a WebSocket";
    homepage = "https://github.com/bropat/eufy-security-ws";
    license = lib.licenses.mit;
  };
}
