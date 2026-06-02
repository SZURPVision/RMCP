{ src, stdenv, scons, protobuf, pkg-config, replaceVars }:
let
  version = "0.1.0";
  pname = "rmcp-cpp";
  meta = {
    description = "RoboMaster Client Protocol Library for C++";
  };
in stdenv.mkDerivation {
  inherit src version pname meta;
  nativeBuildInputs = [ scons pkg-config ];
  buildInputs = [ protobuf ];
  postPatch = ''
    echo "[PatchPhase] Making the source structure"
    mkdir src include
    cp ${./SConstruct} ./SConstruct
    cp cpp/*.cc src/
    cp cpp/*.h include/
  '';
  buildPhase = ''
    scons -j$NIX_BUILD_CORES
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/rmcp $out/lib $out/lib/pkgconfig

    cp include/*.h $out/include/rmcp/
    cp lib/*.so $out/lib/

    substitute ${./rmcp-cpp.pc.in} $out/lib/pkgconfig/rmcp-cpp.pc \
      --replace "@out@" "$out" \
      --replace "@pname@" "${pname}" \
      --replace "@description@" "${meta.description}" \
      --replace "@version@" "${version}"

    runHook postInstall
  '';
}