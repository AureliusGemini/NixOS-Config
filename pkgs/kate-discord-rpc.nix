{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  rapidjson,
}:

stdenv.mkDerivation {
  pname = "kate-discord-rpc";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "leia-uwu";
    repo = "kate-discord-rpc";
    rev = "f5fbf77d206f6e1f0e21ce9a0f4435ce3ef41870";
    hash = "sha256-TWMYy6oeFJZ1WTS9tNQLk9RcRBwkvVrZy9kVU2Kr90s=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    ktexteditor
    kcoreaddons
    kconfig
    ki18n
    qtbase
    rapidjson
  ];
}
