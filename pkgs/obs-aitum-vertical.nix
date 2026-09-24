{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
  qt6,
  curl,
}:

stdenv.mkDerivation {
  pname = "obs-aitum-vertical";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "Aitum";
    repo = "obs-vertical-canvas";
    rev = "1.6.4";
    hash = "sha256-yQ6JvJ/fG4U6V9kU0Y+9zU3vM41G40dZ+237D2xN93o=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    obs-studio
    qt6.qtbase
    curl
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Aitum Vertical Canvas plugin for OBS Studio";
    homepage = "https://github.com/Aitum/obs-vertical-canvas";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}