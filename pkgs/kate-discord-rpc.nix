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
  version = "0-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "leia-uwu";
    repo = "kate-discord-rpc";
    rev = "93a14a03887540f819b3b4885fd8c789aee05b19";
    hash = "sha256-NHa5SHx2IKUCHlwAGwDRoiRSBygzuNRxmXV5qM5GDfE=";
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

  meta = with lib; {
    description = "Discord Rich Presence plugin for KDE Kate";
    homepage = "https://github.com/leia-uwu/kate-discord-rpc";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
