{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperqueue";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "It4innovations";
    repo = "hyperqueue";
    rev = "v${version}";
    hash = "sha256-+H35BVKVYxH/R9TmSDz7c/LKVcOKXyIMAEuEfWn9NEc=";
  };
  
  # Don't do checking because this will cause build to fail
  doCheck = false;
  
  cargoHash = "sha256-9X+gFuNphTfTOkxB9DeAHe55KgOKq4UmVRkQD2peizY=";

  meta = with lib; {
    description = "Scheduler for sub-node tasks for HPC systems with batch scheduling";
    homepage = "https://github.com/It4innovations/hyperqueue";
    changelog = "https://github.com/It4innovations/hyperqueue/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "hyperqueue";
  };
}
