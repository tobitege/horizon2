$ErrorActionPreference = "Stop"

# Clean build,test dir
Remove-Item ./bin/*.*
Remove-Item ./testresults/*.*

# Build
./DUBuild/DUBuild.exe build -nm -e ./DUBuild,./DUnit,./UnitTests,./Modules/SpecialisedModules -s ./ -m ./Main*.lua -o ./bin/;
get-content ./bin/Comms-Test.json | set-clipboard;
write-host "`nLoaded to clipboard.`n";
write-host "Running tests...";

# Test
./DUnit/DUnit.exe test -s ./bin/*.json -t ./UnitTests -l ./testresults