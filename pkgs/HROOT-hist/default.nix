{ cabal, root5, fficxx-runtime, HROOT-src-tree, HROOT-core }:

cabal.mkDerivation (self: {
  pname = "HROOT-hist";
  version = "0.8";
  src = HROOT-src-tree;
  sourceRoot = "HROOT/HROOT-hist";
  isLibrary = true;
  isExecutable = false;
  buildDepends = [ root5  
                   fficxx-runtime
                   HROOT-src-tree
                   HROOT-core
                 ];
  doCheck = false;
  meta = {
    homepage = "http://ianwookim.org/HROOT";
    description = "automatic HROOT binding generation";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
