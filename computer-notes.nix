{ stdenv, sphinx }:

stdenv.mkDerivation {
  name = "computer-notes";
  version = "0.1.0";

  phases = [ "unpackPhase" "buildPhase" ];
  buildInputs = [ sphinx ];

  src = ./.;
  buildPhase = ''
    sphinx-build -b html ./src $out
  '';
}