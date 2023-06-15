rem =======================================================================
rem add the framework directory to the path variable - we'll need this for msbuild
set path=%path%;C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319

msbuild CAMLA.build.proj /T:DeploymentBuild /P:Config=Debug /P:BUILD_NUMBER=1.0.0.0
PAUSE /verbosity:detailed