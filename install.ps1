$APP_NAME = "sqlfmt"
$InstallDir = Join-Path $HOME "bin"
$BinName = "$APP_NAME.exe"
$Target = Join-Path $InstallDir $BinName

function Detect-BinName {
	# Use PROCESSOR_ARCHITEW6432 when running under WOW64 (32-bit on 64-bit)
	$arch = if ($env:PROCESSOR_ARCHITEW6432) {
		$env:PROCESSOR_ARCHITEW6432
	} else {
		$env:PROCESSOR_ARCHITECTURE
	}

	switch ($arch) {
		"AMD64" {
			return "${APP_NAME}-windows-x64.exe"
		}
		"ARM64" {
			return "${APP_NAME}-windows-arm64.exe"
		}
		default {
			Write-Host "Unsupported Windows architecture: $arch"
			exit 1
		}
	}
}

$SourceBin = Detect-BinName

if (!(Test-Path ".\$SourceBin")) {
	Write-Host "Binary not found: .\$SourceBin"
	Write-Host "Run .\build.ps1 first to build the binary."
	exit 1
}

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

Copy-Item ".\$SourceBin" $Target -Force

Write-Host "Installed:"
Write-Host "  .\$SourceBin → $Target"
Write-Host ""

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
