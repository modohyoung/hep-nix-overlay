{ mkDerivation, stdenv, fetchgit, HStringTemplate, fficxx, configurator, cmdargs }:

mkDerivation {
  pname = "HROOT-generate";
  version = "0.8.1";
  src = fetchgit { url = "https://github.com/wavewave/HROOT-generate.git"; 
                   rev = "416b56c866283e8b6d6406a4545fc471b038647a";
                   sha256 = "02585156c7c71c0a56a0251c3b79b651599b4cf2a87c518ca96eb5d1d26ea9e0";
                 };  
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ HStringTemplate
                   fficxx
                   configurator
                   cmdargs
                 ];
  doCheck = false;
  license = stdenv.lib.licenses.gpl3;

}
