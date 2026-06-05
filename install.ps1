$SourceBin = "sqlfmt-windows-x64.exe"
$BinName = "sqlfmt.exe"
$InstallDir = Join-Path $HOME "bin"
$Target = Join-Path $InstallDir $BinName

if (!(Test-Path ".\$SourceBin")) {
	Write-Host "Binary not found: .\$SourceBin"
	Write-Host "Run .\build.ps1 first to build the binary."
	exit 1
}

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

Copy-Item ".\$SourceBin" $Target -Force

$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")

$Paths = $UserPath -split ";"

if ($Paths -notcontains $InstallDir) {
	$NewPath = if ([string]::IsNullOrWhiteSpace($UserPath)) {
		$InstallDir
	} else {
		"$UserPath;$InstallDir"
	}

	[Environment]::SetEnvironmentVariable(
		"Path",
		$NewPath,
		"User"
	)

	Write-Host "Added $InstallDir to user PATH"
} else {
	Write-Host "$InstallDir already in PATH"
}

Write-Host "Installed to $Target"
Write-Host ""
Write-Host "Restart terminal to use sqlfmt"
