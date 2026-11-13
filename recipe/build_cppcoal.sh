#!/bin/sh

INSTALL_DOCUMENTATION=ON
if [[ "${target_platform}" == "linux-riscv64" ]]; then
  # doxygen isn't available on linux-riscv64
  INSTALL_DOCUMENTATION=OFF
fi

mkdir build
cd build

# CMAKE_CXX_STANDARD hard coding should be removed in JRLv2
cmake ${CMAKE_ARGS} .. \
      -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_CXX_STANDARD=17 \
      -DINSTALL_DOCUMENTATION=${INSTALL_DOCUMENTATION} \
      -DBUILD_PYTHON_INTERFACE=OFF \
      -DCOAL_HAS_QHULL=ON \
      -DBUILD_TESTING=OFF

ninja
ninja install

if [[ $CONDA_BUILD_CROSS_COMPILATION == 1 ]]; then
  echo $BUILD_PREFIX
  echo $PREFIX
  sed -i.back 's|'"$BUILD_PREFIX"'|'"$PREFIX"'|g' $PREFIX/lib/cmake/coal/coalTargets.cmake
  rm $PREFIX/lib/cmake/coal/coalTargets.cmake.back
fi
