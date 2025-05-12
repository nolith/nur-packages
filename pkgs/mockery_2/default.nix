{
  pkgs,
  fetchFromGitHub,
  ...
}:
pkgs.buildGo123Module rec {
  pname = "mockery";
  version = "2.53.3";
  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    rev = "v${version}";
    sha256 = "sha256-X0cHpv4o6pzgjg7+ULCuFkspeff95WFtJbVHqy4LxAg=";
  };
  vendorHash = "sha256-c63NA0hbWH1HLpSK/vcNHz1fPaLlMLAkJ9cpl8cxdSs=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/vektra/mockery/v2/pkg/logging.SemVer=v${version}"
  ];

  CGO_ENABLED = false;
  # mockery make use of go workspace, but we don't need it for compiling the tool
  env.GOWORK = "off";
  # some stuff don't work withoug go workspace
  prePatch = ''
    rm -rf pkg/fixtures
    rm -rf mocks
    rm -rf tools
  '';

  preBuild = "export GOWORK='off'";

  # same for the tests using a workspace module
  doCheck = false;
  # checkPhase = "echo skipping tests";
}
