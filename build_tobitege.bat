@ECHO Off
rem Only use slashes, not backslashes or the parameters won't be parsed correctly!
"D:/github/dubuild/DUBuild/bin/Debug/net8.0/DUBuild.exe" build -s "D:/github/horizon2/" -m "D:/github/horizon2/main_*.lua" -o "D:/github/horizon2/output/" -e "D:/github/horizon2/.history"
