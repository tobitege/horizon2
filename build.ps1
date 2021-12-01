$ErrorActionPreference = "Stop"

# The file to copy to clipboard after building:
$FileToCopy = "Standard.json"

# Ensure DUBuild and DUnit directories exist
New-Item -Path ./DUBuild/ -ItemType Directory -Force > $null
New-Item -Path ./DUnit/ -ItemType Directory -Force > $null

# Create build,test dir
New-Item -Path ./bin/ -ItemType Directory -Force > $null
New-Item -Path ./testresults/ -ItemType Directory -Force > $null

# Clean build,test dir
Remove-Item ./bin/*.*
Remove-Item ./testresults/*.*

# Ensure that DUBuild is present
if (-not(Test-Path -Path ./DUBuild/DUBuild.dll -PathType Leaf)) {
    write-host -ForegroundColor Red "`ERROR! DUBuild is not present. Exising...";
    exit
}

write-host -ForegroundColor Blue "Building...";

# Build
./DUBuild/DUBuild.exe build -nm -e ./DUBuild,./DUnit,./Tests,./Modules/SpecialisedModules -s ./ -m ./Main*.lua -o ./bin/ | Select-String -CaseSensitive "ERROR"
if($?) {
    write-host -ForegroundColor Green "Build successful.`n";
}
else {
    write-host -ForegroundColor Red "`nERROR! Build failed. Exiting...";
    exit
}
get-content ./bin/$FileToCopy | set-clipboard;
write-host -ForegroundColor Blue "JSON loaded to clipboard."

# Ensure that DUnit is present
if (-not(Test-Path -Path ./DUnit/DUnit.dll -PathType Leaf)) {
    write-host -ForegroundColor Red "`ERROR! DUnit is not present. Exising...";
    exit
}

write-host -ForegroundColor Blue "`nRunning tests...";

# Test
dotnet ./DUnit/DUnit.dll test -s ./bin/*.json -t ./Tests -l ./testresults | Set-Variable -Name "UnitTests" | Select-String "was successful"
if($?) {
    write-host -ForegroundColor Green "Tests finished OK";
}
else {
    write-host -ForegroundColor Red "`nERROR! Tests failed. Error log written to 'error.log'";
    $UnitTests | out-file error.log
}