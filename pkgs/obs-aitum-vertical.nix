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
    hash = "sha256-GlRyQl2XcH8PFndv9L6STqT+YJk4S+Sjz/q+6P0A5Og=";
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
