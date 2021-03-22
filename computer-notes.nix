{ stdenv, asciidoctor, asciidoctor-multipage }:

stdenv.mkDerivation {
  name = "computer-notes";
  version = "0.1.0";

  phases = [ "unpackPhase" "buildPhase" ];
  buildInputs = [ asciidoctor-multipage ];

  src = ./src;
  buildPhase = ''
    asciidoctor --failure-level=WARNING -r asciidoctor-multipage -b multipage_html5 index.adoc -o $out/index.html
  '';
}
