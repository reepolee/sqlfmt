$APP = "sqlfmt"

cargo build --release

Copy-Item "./target/release/${APP}.exe" "./${APP}-windows-x64.exe" -Force

Write-Host "Built Windows x64:"
Write-Host "./${APP}-windows-x64.exe"

Remove-Item ./target -Recurse -Force
