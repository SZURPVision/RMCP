{ self, ...}:
{
  perSystem = { pkgs, ...}:
  let
    version = "0.1.0";
    
    all-gen = pkgs.stdenv.mkDerivation {
      name = "rmcp-all-internal";
      src = self;
      nativeBuildInputs = [ pkgs.protobuf pkgs.buf ];
      buildPhase = ''
        export HOME=$TMPDIR
        buf generate
      '';
      installPhase = "cp -r gen $out";
    };
  in {
    packages = {

      default = all-gen;
      rmcp = all-gen;
      
      rmcp-cpp = pkgs.stdenv.mkDerivation {
        pname = "rmcp-cpp";
        inherit version;
        
        phases = [ "installPhase" ];
        installPhase = ''
          mkdir -p $out/include/rmcp
          ln -s ${all-gen}/cpp/*.h $out/include/rmcp/
          ln -s ${all-gen}/cpp/*.cc $out/include/rmcp/
        '';

        meta = {
          description = "RobotMaster Client Protocol source lib in C++";
        };
      };

      rmcp-csharp = pkgs.stdenv.mkDerivation {
        pname = "rmcp-csharp";
        inherit version;

        phases = [ "installPhase" ];
        installPhase = ''
          mkdir -p $out/src
          ln -s ${all-gen}/csharp/* $out/src/
        '';

        meta = {
          description = "RobotMaster Client Protocol source lib in C#";
        };
      };
      
    };
  };
}