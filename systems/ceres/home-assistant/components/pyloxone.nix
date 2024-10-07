{
  input,
  buildHomeAssistantComponent,
}:
buildHomeAssistantComponent {
  owner = "jodehli";
  domain = "pyloxone";
  version = input.rev;

  src = input;

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
}
