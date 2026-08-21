{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "kate-discord-rpc";
  version = "unstable";
  src = pkgs.fetchFromGitHub {
    owner = "leia-uwu";
    repo = "kate-discord-rpc";
    rev = "refs/heads/master";
    hash = "sha256-TWMYy6oeFJZ1WTS9tNQLk9RcRBwkvVrZy9kVU2Kr90s=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    pkgs.cmake
    pkgs.kdePackages.extra-cmake-modules
    pkgs.kdePackages.wrapQtAppsHook
  ];
  buildInputs = with pkgs.kdePackages; [
    ktexteditor
    kcoreaddons
    kconfig
    ki18n
    qtbase
    pkgs.rapidjson
  ];
}
