#!/usr/bin/env bash 
# Generates minimal VS2022 project files in current directory 

# ---- Get project name ---- 
if [ -n "$1" ]; then 
    PROJECT_NAME="$1" 
else 
    PROJECT_NAME=$(basename "$PWD") 
fi 

# ---- Fixed GUID (can be changed to random if desired) ---- 
PROJECT_GUID="{11111111-1111-1111-1111-111111111111}" 

# ---- Collect source and header files ---- 
SOURCE_FILES=$(find . -maxdepth 1 \( -name "*.cpp" -o -name "*.c" \) -printf "    <ClCompile Include=\"%f\" />\n") 
H_FILES=$(find . -maxdepth 1 \( -name "*.h" -o -name "*.hpp" \) -printf "    <ClInclude Include=\"%f\" />\n") 

# ---- Generate .sln ---- 
cat > "$PROJECT_NAME.sln" <<EOF
Microsoft Visual Studio Solution File, Format Version 12.00 
# Visual Studio Version 17 
VisualStudioVersion = 17.0.31903.59 
MinimumVisualStudioVersion = 10.0.40219.1 
Project("{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}") = "$PROJECT_NAME", "$PROJECT_NAME.vcxproj", "$PROJECT_GUID" 
EndProject 
Global 
    GlobalSection(SolutionConfigurationPlatforms) = preSolution 
        Debug|x64 = Debug|x64 
        Release|x64 = Release|x64 
    EndGlobalSection 
    GlobalSection(ProjectConfigurationPlatforms) = postSolution 
        $PROJECT_GUID.Debug|x64.ActiveCfg = Debug|x64 
        $PROJECT_GUID.Debug|x64.Build.0 = Debug|x64 
        $PROJECT_GUID.Release|x64.ActiveCfg = Release|x64 
        $PROJECT_GUID.Release|x64.Build.0 = Release|x64 
    EndGlobalSection 
EndGlobal 
EOF

# ---- Generate .vcxproj ---- 
cat > "$PROJECT_NAME.vcxproj" <<EOF
<?xml version="1.0" encoding="utf-8"?> 
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003"> 
  <ItemGroup Label="ProjectConfigurations"> 
    <ProjectConfiguration Include="Debug|x64"> 
      <Configuration>Debug</Configuration> 
      <Platform>x64</Platform> 
    </ProjectConfiguration> 
    <ProjectConfiguration Include="Release|x64"> 
      <Configuration>Release</Configuration> 
      <Platform>x64</Platform> 
    </ProjectConfiguration> 
  </ItemGroup> 

  <PropertyGroup Label="Globals"> 
    <ProjectGuid>$PROJECT_GUID</ProjectGuid> 
    <RootNamespace>$PROJECT_NAME</RootNamespace> 
    <WindowsTargetPlatformVersion>10.0</WindowsTargetPlatformVersion> 
  </PropertyGroup> 

  <Import Project="\$(VCTargetsPath)\Microsoft.Cpp.Default.props" /> 

  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Debug|x64'" Label="Configuration"> 
    <ConfigurationType>Application</ConfigurationType> 
    <UseDebugLibraries>true</UseDebugLibraries> 
    <PlatformToolset>v143</PlatformToolset> 
  </PropertyGroup> 

  <PropertyGroup Condition="'\$(Configuration)|\$(Platform)'=='Release|x64'" Label="Configuration"> 
    <ConfigurationType>Application</ConfigurationType> 
    <UseDebugLibraries>false</UseDebugLibraries> 
    <PlatformToolset>v143</PlatformToolset> 
  </PropertyGroup> 

  <Import Project="\$(VCTargetsPath)\Microsoft.Cpp.props" /> 

  <ItemGroup> 
$SOURCE_FILES 
  </ItemGroup> 

  <ItemGroup> 
$H_FILES 
  </ItemGroup> 

  <Import Project="\$(VCTargetsPath)\Microsoft.Cpp.targets" /> 
</Project> 
EOF

# ---- Generate .vcxproj.filters ---- 
{ 
  echo '<?xml version="1.0" encoding="utf-8"?>' 
  echo '<Project ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">' 
   
  # Group .cpp and .c files under Source Files 
  SRC_FILES=(*.cpp *.c) 
  if compgen -G "*.cpp" >/dev/null || compgen -G "*.c" >/dev/null; then 
    echo '  <ItemGroup>' 
    for f in "${SRC_FILES[@]}"; do 
      [ -e "$f" ] || continue 
      echo "    <ClCompile Include=\"$f\">" 
      echo "      <Filter>Source Files</Filter>" 
      echo "    </ClCompile>" 
    done 
    echo '  </ItemGroup>' 
  fi 

  # Group .h and .hpp files under Header Files 
  HEADER_FILES=(*.h *.hpp)
  if compgen -G "*.h" >/dev/null || compgen -G "*.hpp" >/dev/null; then 
    echo '  <ItemGroup>' 
    for f in "${HEADER_FILES[@]}"; do 
      [ -e "$f" ] || continue 
      echo "    <ClInclude Include=\"$f\">" 
      echo "      <Filter>Header Files</Filter>" 
      echo "    </ClInclude>" 
    done 
    echo '  </ItemGroup>' 
  fi 

  # Declare the folders 
  echo '  <ItemGroup>' 
  [ -n "$SOURCE_FILES" ] && echo '    <Filter Include="Source Files" />' 
  [ -n "$H_FILES" ] && echo '    <Filter Include="Header Files" />' 
  echo '  </ItemGroup>' 

  echo '</Project>' 
} > "$PROJECT_NAME.vcxproj.filters" 

# ---- Done ---- 
echo "✅ Generated Visual Studio 2022 (v143) project files:" 
echo " - $PROJECT_NAME.sln" 
echo " - $PROJECT_NAME.vcxproj" 
echo " - $PROJECT_NAME.vcxproj.filters (grouped by Source/Headers)" 

echo "Included $(find . -maxdepth 1 \( -name '*.cpp' -o -name '*.c' \) | wc -l) source and $(find . -maxdepth 1 \( -name '*.h' -o -name '*.hpp' \) | wc -l) header files"
