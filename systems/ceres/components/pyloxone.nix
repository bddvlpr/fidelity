{
  src,
  buildHomeAssistantComponent,
}:
buildHomeAssistantComponent {
  owner = "jodehli";
  domain = "pyloxone";
  version = "0.6.10";

  inherit src;

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
}
