{ stdenv, asciidoctor }:

stdenv.mkDerivation {
  name = "computer-notes";
  version = "0.1.0";

  phases = [ "unpackPhase" "buildPhase" ];
  buildInputs = [ asciidoctor ];

  src = ./src;
  buildPhase = ''
    asciidoctor
  '';
}
