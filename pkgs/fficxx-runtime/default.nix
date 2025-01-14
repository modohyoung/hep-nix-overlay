{ cabal, fetchgit }:

cabal.mkDerivation (self: {
  pname = "fficxx-runtime";
  version = "0.1.999";
  src = fetchgit { url = "https://github.com/wavewave/fficxx-runtime.git"; 
                   rev = "2b0750ce73392983c9d1c9b8cdfc71e5b5cd6d1d";
                   sha256 = "f170fd755dddf6a3ce4ab937a98181d9f7392e03faafa5e904facafdf14b924f";
                 };  
  isLibrary = true;
  isExecutable = false;
  buildDepends = [ 
                
                 ];
  doCheck = false;
  meta = {
    homepage = "http://ianwookim.org/fficxx";
    description = "Runtime for fficxx-generated library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
