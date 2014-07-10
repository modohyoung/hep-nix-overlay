{ stdenv, cmake, git
, root5, HepMC, gsl, FastJet, pkgconfig
, python, cython0192, libyamlcppPIC,  boost, YODA, gtest, pkgs
}:
 
let #patchedFiles = [ "CMakeLists.txt"
    #                 "CMakeModules/FindCython.cmake"
    #                 "CMakeModules/FindYamlCpp.cmake"
    #                 "CMakeModules/FindROOT.cmake"
    #                 "CMakeModules/UseCython.cmake"
    #                 "master/CMakeModules/FindCython.cmake"
    #                 "master/CMakeModules/FindROOT.cmake"
    #                 "master/CMakeModules/FindYamlCpp.cmake"
    #                 "master/CMakeModules/UseCython.cmake"
    #                 "bin/atomenv.csh"
    #                 "bin/atomenv.sh"
    #               ];
    #toGitAssumeUnchangedCommand = s: "git update-index --assume-unchanged ${s}";
    #doGitAssumeUnchanged = stdenv.lib.concatStringsSep ";" (map toGitAssumeUnchangedCommand patchedFiles);

    # postPatchStr = doGitAssumeUnchanged;
    pythonWithCython = pkgs.pythonFull.override { 
                         extraLibs = [ cython0192 ]; 
                       }; 
    
in stdenv.mkDerivation rec { 
  name = "Atom-dev"; 
  patches = [ ../../Atom/findYamlCpp.patch 
              ../../Atom/findROOT.patch 
              ../../Atom/absolutePathInAtomenv.patch 
              ../../Atom/TestsCMakeEnv.patch
            ];
  #postPatch = postPatchStr;

  buildInputs = [ git cmake root5 HepMC gsl FastJet pkgconfig libyamlcppPIC 
                  #cython0192 
                  boost YODA gtest  
                  #pkgs.pythonFull
                  #python
                  pythonWithCython 
                ] ++ (if (!stdenv.isDarwin) then [stdenv.gcc.libc] else []);
  # propagatedBuildInputs = [ pkgs.pythonPackages.readline ];

  pkgconfigDepends = [ libyamlcppPIC ] ;
  enableParallelBuilding = true; 
  doCheck = true;

  preConfigure = '' 
    substituteInPlace bin/atomenv.sh --subst-var prefix
    substituteInPlace bin/atomenv.csh --subst-var prefix 
    substituteInPlace bin/atom --replace /usr/bin/env ${pkgs.coreutils}/bin/env
    substituteInPlace bin/atom-config.in --replace /usr/bin/env ${pkgs.coreutils}/bin/env
    substituteInPlace bin/aida2root --replace /usr/bin/env ${pkgs.coreutils}/bin/env
    ''; 

  cmakeFlags = if ( stdenv.isDarwin ) then
    ''-DCMAKE_CXX_FLAGS=-fPIC  -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-undefined,dynamic_lookup" -DYamlCpp_STATIC_LIBRARY=TRUE -DYamlCpp_DIR=${libyamlcppPIC} -DBoost_DIR=${boost} -DBoost_NO_SYSTEM_PATHS=true  -DHEPMC_DIR=${HepMC} -DHEPMC_ROOT_DIR=${HepMC} -DUSE_BOOST_FILESYSTEM=OFF -DENABLE_TESTS=true''
               else ''-DCMAKE_CXX_FLAGS=-fPIC  -DYamlCpp_STATIC_LIBRARY=TRUE -DYamlCpp_DIR=${libyamlcppPIC} -DBoost_DIR=${boost} -DBoost_NO_SYSTEM_PATHS=true  -DHEPMC_DIR=${HepMC} -DHEPMC_ROOT_DIR=${HepMC} -DUSE_BOOST_FILESYSTEM=OFF -DENABLE_TESTS=true'';

  #dontPatchShebangs = true; 
 
  meta = { 
  };

}

#-DCMAKE_VERBOSE_MAKEFILE=ON
# -DCMAKE_VERBOSE_MAKEFILE=ON
# -DENABLE_TESTS=true
# -DENABLE_TESTS=true