{stdenv, fetchurl, cmake, boostHeaders}:

stdenv.mkDerivation {
  name = "libyaml-cpp-0.5.1-PIC";

  src = fetchurl {
    url = http://yaml-cpp.googlecode.com/files/yaml-cpp-0.5.1.tar.gz;
    sha256 = "01kg0h8ksp162kdhyzn67vnlxpj5zjbks84sh50pv61xni990z1y";
  };

  buildInputs = [ cmake boostHeaders ];

  cmakeFlags = "-DCMAKE_CXX_FLAGS=-fPIC"; 

  meta = {
    homepage = http://code.google.com/p/yaml-cpp/;
    description = "A YAML parser and emitter for C++";
    license = "MIT";
  };
}
