$ErrorActionPreference = "Stop"
$DefaultColor = $Host.UI.RawUI.ForegroundColor

# The file to copy to clipboard after building:
$FileToCopy = "Standard.json"

# Ensure DUBuild and DUnit directories exist
New-Item -Path ./DUBuild/ -ItemType Directory -Force > $null
New-Item -Path ./DUnit/ -ItemType Directory -Force > $null

# Create build,test dir
New-Item -Path ./bin/ -ItemType Directory -Force > $null
New-Item -Path ./testresults/ -ItemType Directory -Force > $null

# Ensure that DUBuild is present
if (-not(Test-Path -Path ./DUBuild/DUBuild.dll -PathType Leaf)) {
    write-host -ForegroundColor Red "`ERROR! DUBuild is not present. Exising...";
    exit
}

# Build
write-host -ForegroundColor Blue "Building...";
$Host.UI.RawUI.ForegroundColor = "Red"
Remove-Item ./bin/*.*
dotnet ./DUBuild/DUBuild.dll build -nm -e ./DUBuild,./DUnit,./Tests,./Modules/SpecialisedModules -s ./ -m ./Main*.lua -o ./bin/ | Select-String -CaseSensitive "ERROR"
if($?) {
    write-host -ForegroundColor Green "Build successful.`n";
    get-content ./bin/$FileToCopy | set-clipboard;
    write-host -ForegroundColor Yellow "JSON loaded to clipboard.`n"
    $Host.UI.RawUI.ForegroundColor = $DefaultColor
}
else {
    write-host -ForegroundColor Red "ERROR! Build failed. Exiting...";
    $Host.UI.RawUI.ForegroundColor = $DefaultColor
    exit
}

# Ensure that DUnit is present
if (-not(Test-Path -Path ./DUnit/DUnit.dll -PathType Leaf)) {
    write-host -ForegroundColor Red "`ERROR! DUnit is not present. Exising...";
    exit
}


# Test
if (Test-Path ./error.log) {
    Remove-Item -Force ./error.log
}
write-host -ForegroundColor Blue "Running tests...";
$Host.UI.RawUI.ForegroundColor = "Red"
Remove-Item ./testresults/*.*
dotnet ./DUnit/DUnit.dll test -s ./bin/*.json -t ./Tests -l ./testresults | Tee-Object -FilePath ./error.log | Select-String -CaseSensitive "ERROR"
if($?) {
    Remove-Item -Force ./error.log
    write-host -ForegroundColor Green "Tests finished OK";
}
else {
    write-host -ForegroundColor Red "ERROR! Tests failed. Test log written to 'error.log'";
}
$Host.UI.RawUI.ForegroundColor = $DefaultColor