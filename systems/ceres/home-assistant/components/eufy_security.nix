{
  input,
  buildHomeAssistantComponent,
}:
buildHomeAssistantComponent {
  owner = "fuatakgun";
  domain = "eufy_security";
  version = input.rev;

  src = input;

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
}
