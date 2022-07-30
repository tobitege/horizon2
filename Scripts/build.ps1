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

# Ensure submodules are init
if (-not(Test-Path -Path ./Libs/Utils/*)) {
    git submodule update --init --recursive --remote
}

# Ensure that DUBuild is present
if (-not(Test-Path -Path ./DUBuild/DUBuild.dll -PathType Leaf)) {
    write-host -ForegroundColor Red "`ERROR! DUBuild is not present.";
    write-host -ForegroundColor Yellow "Opening repo to download..."
    Start-Process "https://git.internal.st/dual-universe/dubuild/-/jobs/artifacts/master/download?job=Build+Artifacts"
    Start-Process ".\DUBuild"
    exit
}

# Build
write-host -ForegroundColor Blue "Building...";
$Host.UI.RawUI.ForegroundColor = "Red"
Remove-Item ./bin/*.*
dotnet ./DUBuild/DUBuild.dll build -nm -e ./DUBuild,./DUnit,./Tests,./Modules/SpecialisedModules,./DU,./Mocks -s ./ -m ./Main*.lua -o ./bin/ | Select-String -CaseSensitive "ERROR"
if($?) {
    write-host -ForegroundColor Green "Build successful.`n";
    (get-content -Encoding UTF8 ./bin/$FileToCopy) `
    -replace '%CI_COMMIT_TAG%','local' `
    -replace '%CI_COMMIT_BRANCH%',(git rev-parse --abbrev-ref HEAD) `
    -replace '%CI_COMMIT_SHORT_SHA%',(git rev-parse --short HEAD) | set-clipboard;

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
    write-host -ForegroundColor Red "`ERROR! DUnit is not present.";
    write-host -ForegroundColor Yellow "Opening repo to download..."
    Start-Process "https://git.internal.st/dual-universe/dunit/-/jobs/artifacts/master/download?job=Build+Artifacts"
    Start-Process ".\DUnit"
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
    $Host.UI.RawUI.ForegroundColor = $DefaultColor
    Remove-Item -Force ./error.log
    write-host -ForegroundColor Green "Tests finished successfully.";
}
else {
    write-host -ForegroundColor Red "ERROR! Tests failed. Test log written to 'error.log'";
    $Host.UI.RawUI.ForegroundColor = $DefaultColor
}