@echo off
setlocal enabledelayedexpansion

REM === Get project name ===
if "%~1"=="" (
    for %%I in (.) do set "PROJECT_NAME=%%~nI"
) else (
    set "PROJECT_NAME=%~1"
)

REM === Fixed GUID (can be randomized if needed) ===
set "PROJECT_GUID={11111111-1111-1111-1111-111111111111}"

REM === Collect .cpp/.c files ===
set "SOURCE_FILES="
for %%f in (*.cpp *.c) do (
    if exist "%%f" (
        set "SOURCE_FILES=!SOURCE_FILES!    <ClCompile Include=\"%%f\" />^
"
    )
)

REM === Collect .h files ===
set "H_FILES="
for %%f in (*.h) do (
    if exist "%%f" (
        set "H_FILES=!H_FILES!    <ClInclude Include=\"%%f\" />^
"
    )
)

REM === Generate .sln ===
(
echo Microsoft Visual Studio Solution File, Format Version 12.00
echo # Visual Studio Version 17
echo VisualStudioVersion = 17.0.31903.59
echo MinimumVisualStudioVersion = 10.0.40219.1
echo Project("{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}") = "%PROJECT_NAME%", "%PROJECT_NAME%.vcxproj", "%PROJECT_GUID%"
echo EndProject
echo Global
echo ^    GlobalSection(SolutionConfigurationPlatforms) = preSolution
echo ^        Debug^|x64 = Debug^|x64
echo ^        Release^|x64 = Release^|x64
echo ^    EndGlobalSection
echo ^    GlobalSection(ProjectConfigurationPlatforms) = postSolution
echo ^        %PROJECT_GUID%.Debug^|x64.ActiveCfg = Debug^|x64
echo ^        %PROJECT_GUID%.Debug^|x64.Build.0 = Debug^|x64
echo ^        %PROJECT_GUID%.Release^|x64.ActiveCfg = Release^|x64
echo ^        %PROJECT_GUID%.Release^|x64.Build.0 = Release^|x64
echo ^    EndGlobalSection
echo EndGlobal
) > "%PROJECT_NAME%.sln"

REM === Generate .vcxproj ===
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003"^>
echo ^  ^<ItemGroup Label="ProjectConfigurations"^>
echo ^    ^<ProjectConfiguration Include="Debug^|x64"^>
echo ^      ^<Configuration^>Debug^</Configuration^>
echo ^      ^<Platform^>x64^</Platform^>
echo ^    ^</ProjectConfiguration^>
echo ^    ^<ProjectConfiguration Include="Release^|x64"^>
echo ^      ^<Configuration^>Release^</Configuration^>
echo ^      ^<Platform^>x64^</Platform^>
echo ^    ^</ProjectConfiguration^>
echo ^  ^</ItemGroup^>
echo.
echo ^  ^<PropertyGroup Label="Globals"^>
echo ^    ^<ProjectGuid^>%PROJECT_GUID%^</ProjectGuid^>
echo ^    ^<RootNamespace^>%PROJECT_NAME%^</RootNamespace^>
echo ^    ^<WindowsTargetPlatformVersion^>10.0^</WindowsTargetPlatformVersion^>
echo ^  ^</PropertyGroup^>
echo.
echo ^  ^<Import Project="$(VCTargetsPath)\Microsoft.Cpp.Default.props" /^>
echo ^  ^<PropertyGroup Condition="'$(Configuration)^|$(Platform)'=='Debug^|x64'" Label="Configuration"^>
echo ^    ^<ConfigurationType^>Application^</ConfigurationType^>
echo ^    ^<UseDebugLibraries^>true^</UseDebugLibraries^>
echo ^  ^</PropertyGroup^>
echo ^  ^<PropertyGroup Condition="'$(Configuration)^|$(Platform)'=='Release^|x64'" Label="Configuration"^>
echo ^    ^<ConfigurationType^>Application^</ConfigurationType^>
echo ^    ^<UseDebugLibraries^>false^</UseDebugLibraries^>
echo ^  ^</PropertyGroup^>
echo ^  ^<Import Project="$(VCTargetsPath)\Microsoft.Cpp.props" /^>
echo.
echo ^  ^<ItemGroup^>
echo !SOURCE_FILES!
echo ^  ^</ItemGroup^>
echo.
echo ^  ^<ItemGroup^>
echo !H_FILES!
echo ^  ^</ItemGroup^>
echo.
echo ^  ^<Import Project="$(VCTargetsPath)\Microsoft.Cpp.targets" /^>
echo ^</Project^>
) > "%PROJECT_NAME%.vcxproj"

REM === Generate .vcxproj.filters ===
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<Project ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003"^>

set "HAS_SRC="
for %%f in (*.cpp *.c) do (
    if exist "%%f" (
        if not defined HAS_SRC echo ^  ^<ItemGroup^>
        echo ^    ^<ClCompile Include="%%f"^>
        echo ^      ^<Filter^>Source Files^</Filter^>
        echo ^    ^</ClCompile^>
        set "HAS_SRC=1"
    )
)
if defined HAS_SRC echo ^  ^</ItemGroup^>

set "HAS_HDR="
for %%f in (*.h) do (
    if exist "%%f" (
        if not defined HAS_HDR echo ^  ^<ItemGroup^>
        echo ^    ^<ClInclude Include="%%f"^>
        echo ^      ^<Filter^>Header Files^</Filter^>
        echo ^    ^</ClInclude^>
        set "HAS_HDR=1"
    )
)
if defined HAS_HDR echo ^  ^</ItemGroup^>

echo ^  ^<ItemGroup^>
if defined HAS_SRC echo ^    ^<Filter Include="Source Files" /^>
if defined HAS_HDR echo ^    ^<Filter Include="Header Files" /^>
echo ^  ^</ItemGroup^>
echo ^</Project^>
) > "%PROJECT_NAME%.vcxproj.filters"

REM === Summary ===
echo.
echo ✅ Generated Visual Studio project files:
echo   - %PROJECT_NAME%.sln
echo   - %PROJECT_NAME%.vcxproj
echo   - %PROJECT_NAME%.vcxproj.filters

set /a SRC_COUNT=0
for %%f in (*.cpp *.c) do if exist "%%f" set /a SRC_COUNT+=1

set /a HDR_COUNT=0
for %%f in (*.h) do if exist "%%f" set /a HDR_COUNT+=1

echo Included %SRC_COUNT% source and %HDR_COUNT% header files.

endlocal

