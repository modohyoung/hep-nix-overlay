{ stdenv, fetchgit, cmake, root5, HepMC, gsl, FastJet, pkgconfig
, python, cython0192, libyamlcppPIC,  boost
# , Rivet
# , graphviz
# , doxygen 
}:
 
# Rivet,

stdenv.mkDerivation rec { 
  name = "Atom"; 
  version = "0.1";

  src = fetchgit { 
    url = "/home/wavewave/repo/srcc/Atom";
    rev = "1afa89578b61b7bff9698823b1217f77f330265d";
    sha256 = "24bdb9470c771da9f02791571957dc26f60fb9c65f2a13033c67f8fd47cd793c" ;
  };
  patches = [ ./findYamlCpp.patch ./findROOT.patch ./noDoxygen.patch ./absolutePathInAtomenv.patch ]; # ./findHepMC.patch 

  buildInputs = [ cmake root5 HepMC gsl FastJet pkgconfig libyamlcppPIC 
                  python cython0192 boost 
                # graphviz
                #  doxygen
                ] ++ (if (!stdenv.isDarwin) then [stdenv.gcc.libc] else []);
  pkgconfigDepends = [ libyamlcppPIC ] ;
  #enableParallelBuilding = true; 

  # Necessary to find libdl (for linux)
  dlpath = if ( !stdenv.isDarwin ) then "${stdenv.gcc.libc}" else "";


  preConfigure = '' 

    substituteInPlace bin/atomenv.sh --subst-var prefix
    substituteInPlace bin/atomenv.csh --subst-var prefix 
    substituteInPlace CMakeModules/FindROOT.cmake --subst-var dlpath 
''; 



  cmakeFlags = if ( stdenv.isDarwin ) then
    ''-DCMAKE_CXX_FLAGS=-fPIC  -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-undefined,dynamic_lookup"  -DCMAKE_VERBOSE_MAKEFILE=ON -DYamlCpp_STATIC_LIBRARY=TRUE -DYamlCpp_DIR=${libyamlcppPIC} -DBoost_DIR=${boost} -DBoost_NO_SYSTEM_PATHS=true  -DHEPMC_DIR=${HepMC} -DHEPMC_ROOT_DIR=${HepMC} -DUSE_BOOST_FILESYSTEM=OFF ''
               else ''-DCMAKE_CXX_FLAGS=-fPIC  -DCMAKE_VERBOSE_MAKEFILE=ON -DYamlCpp_STATIC_LIBRARY=TRUE -DYamlCpp_DIR=${libyamlcppPIC} -DBoost_DIR=${boost} -DBoost_NO_SYSTEM_PATHS=true  -DHEPMC_DIR=${HepMC} -DHEPMC_ROOT_DIR=${HepMC} -DUSE_BOOST_FILESYSTEM=OFF '';
 
  # 
  # -DCMAKE_SKIP_RPATH=FALSE -DCMAKE_SKIP_BUILD_RPATH=FALSE
  # -DMACOSX_RPATH
  # -DBoost_SYSTEM_LIBRARY=${boost}/lib/libboost_system.dylib -DBoost_FILESYSTEM_LIBRARY=${boost}/lib/libboost_filesystem.dylib
  meta = { 
    priority  = "9";
  };

}
