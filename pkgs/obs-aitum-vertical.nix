{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
  qt6,
}:

stdenv.mkDerivation {
  pname = "obs-aitum-vertical";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "Aitum";
    repo = "obs-vertical-canvas";
    rev = "refs/heads/main";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    obs-studio
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Aitum Vertical Canvas plugin for OBS Studio";
    homepage = "https://github.com/Aitum/obs-vertical-canvas";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
