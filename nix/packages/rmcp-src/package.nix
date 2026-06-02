{ src, stdenv, protobuf, buf, ...}:
stdenv.mkDerivation {
  name = "rmcp-src";
  version = "0.1.0";
  inherit src;
  nativeBuildInputs = [ protobuf buf ];
  buildPhase = ''
    export HOME=$TMPDIR
    buf generate
  '';
  installPhase = "cp -r gen $out";
}