{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  curl,
  exiv2,
  lcms2,
  lensfun,
  libarchive,
  libjpeg,
  libraw,
  librtprocess,
  libtiff,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "filmulator-gui";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "CarVac";
    repo = "filmulator-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d1JVfPFzWsjHH9QVOyBg6wxjd5FZfRpR5/qivrk4eJM=";
  };

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  patches = [
    # TODO: upstream fix compat with with exiv2 0.28+ and lensfun 0.3.4
    ./fix-exiv2-lensfun-compat.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];

  buildInputs = [
    curl
    exiv2
    lcms2
    lensfun
    libarchive
    libjpeg
    libraw
    librtprocess
    libtiff
    libsForQt5.qtbase
    libsForQt5.qtdeclarative
    libsForQt5.qtquickcontrols2
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
  ];

  postInstall = ''
    install -Dm644 ../filmulator-gui.desktop.in $out/share/applications/filmulator-gui.desktop
    install -Dm644 ../filmulator-gui64.png $out/share/icons/hicolor/64x64/apps/filmulator-gui64.png
  '';

  meta = {
    description = "Simplified raw photo editor with the power of film";
    longDescription = ''
      Filmulator accepts raw files from cameras and simulates the development of
      film as if exposed to the same light as the camera's sensor.
    '';
    homepage = "https://filmulator.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "filmulator";
    platforms = lib.platforms.linux;
  };
})
