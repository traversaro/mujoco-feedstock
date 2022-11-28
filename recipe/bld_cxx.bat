set "CC=clang-cl.exe"
set "CXX=clang-cl.exe"

mkdir build
cd build

cmake ^
    -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_SHARED_LIBS:BOOL=ON ^
    -DBUILD_TESTING:BOOL=OFF ^
    -DMUJOCO_BUILD_TESTS:BOOL=ON ^
    -DMUJOCO_BUILD_SIMULATE:BOOL=OFF ^
    -DMUJOCO_BUILD_EXAMPLES:BOOL=OFF ^
    -DMUJOCO_ENABLE_AVX:BOOL=OFF ^
    -DMUJOCO_ENABLE_AVX_INTRINSICS:BOOL=OFF ^
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION:BOOL=OFF ^
    -DMUJOCO_INSTALL_PLUGINS:BOOL=ON ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

echo "Listing files in 
del %LIBRARY_PREFIX%\bin\mujuco_plugin\*.lib
:: Cleanup plugin installed in %LIBRARY_PREFIX%\bin\mujuco_plugin"
dir %LIBRARY_PREFIX%\bin\mujuco_plugin

:: Test.
ctest --output-on-failure -C Release 
if errorlevel 1 exit 1


