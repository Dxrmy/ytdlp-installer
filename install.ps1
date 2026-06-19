[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

function Show-CatHeader {
    Clear-Host
    Write-Host ""
    Write-Host "  ╱|、       meow." -ForegroundColor Magenta
    Write-Host "(˚ˎ 。7     /" -ForegroundColor Magenta
    Write-Host " |、˜〵          " -ForegroundColor Magenta
    Write-Host " じしˍ,)ノ" -ForegroundColor Magenta
    Write-Host ""
    Write-Host " Universal YT-DLP Manager" -ForegroundColor Cyan
    Write-Host ""
}

function Invoke-FastDownload {
    param([string]$Url, [string]$OutFile)
    
    try {
        $request = [System.Net.WebRequest]::Create($Url)
        $response = $request.GetResponse()
        $totalLength = $response.ContentLength
        $responseStream = $response.GetResponseStream()
        $targetStream = [System.IO.File]::Create($OutFile)
        $buffer = New-Object byte[] 65536
        $count = 0
        $downloaded = 0
        
        do {
            $count = $responseStream.Read($buffer, 0, $buffer.Length)
            if ($count -gt 0) {
                $targetStream.Write($buffer, 0, $count)
                $downloaded += $count
                if ($totalLength -gt 0) {
                    $percent = [math]::Round(($downloaded / $totalLength) * 100)
                    Write-Progress -Activity "Downloading YT-DLP" -Status "$percent% Complete" -PercentComplete $percent -Id 1
                }
            }
        } while ($count -gt 0)
    } finally {
        if ($targetStream) { $targetStream.Dispose() }
        if ($responseStream) { $responseStream.Dispose() }
        if ($response) { $response.Close() }
    }
    Write-Progress -Activity "Downloading YT-DLP" -Completed -Id 1
}

function Install-Ytdlp {
    $installDir = Join-Path $HOME ".yt-dlp"
    
    if ($IsMacOS) {
        $url = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos"
        $binName = "yt-dlp"
    } elseif ($IsLinux) {
        $url = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux"
        $binName = "yt-dlp"
    } else {
        $url = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
        $binName = "yt-dlp.exe"
    }
    
    $binPath = Join-Path $installDir $binName

    Write-Host " [*] Preparing installation directory..." -ForegroundColor Yellow
    if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir -Force | Out-Null }

    Write-Host " [*] Downloading YT-DLP..." -ForegroundColor Yellow
    Invoke-FastDownload -Url $url -OutFile $binPath

    Write-Host " [*] Adding to system PATH..." -ForegroundColor Yellow
    if ($PSVersionTable.PSEdition -ne "Core" -or $IsWindows) {
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if ($userPath -notmatch [regex]::Escape($installDir)) {
            [Environment]::SetEnvironmentVariable("PATH", "$userPath;$installDir", "User")
        }
    } else {
        $exportLine = "`nexport PATH=`"`$PATH:$installDir`""
        foreach ($profile in @("$HOME/.bashrc", "$HOME/.zshrc")) {
            if (Test-Path $profile) {
                $content = Get-Content $profile -Raw
                if ($content -notmatch [regex]::Escape($installDir)) {
                    Add-Content -Path $profile -Value $exportLine
                }
            }
        }
        if (Test-Path $binPath) { bash -c "chmod +x '$binPath'" }
    }

    Write-Host " [v] Successfully installed YT-DLP!" -ForegroundColor Green
    Write-Host "     Please restart your terminal to use 'yt-dlp'." -ForegroundColor Gray
}

function Uninstall-Ytdlp {
    $installDir = Join-Path $HOME ".yt-dlp"

    Write-Host " [*] Removing YT-DLP files..." -ForegroundColor Yellow
    if (Test-Path $installDir) {
        Remove-Item -Path $installDir -Recurse -Force
    }

    Write-Host " [*] Removing from system PATH..." -ForegroundColor Yellow
    if ($PSVersionTable.PSEdition -ne "Core" -or $IsWindows) {
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if ($userPath) {
            $newPath = ($userPath -split ';' | Where-Object { $_ -ne $installDir -and $_ -ne "" }) -join ';'
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        }
    } else {
        Write-Host "     Please manually remove $installDir from your .bashrc or .zshrc" -ForegroundColor Gray
    }

    Write-Host " [v] Successfully uninstalled YT-DLP!" -ForegroundColor Green
}

Show-CatHeader

Write-Host " 1. Install YT-DLP" -ForegroundColor White
Write-Host " 2. Uninstall YT-DLP" -ForegroundColor White
Write-Host ""
$choice = Read-Host " Select an option (1/2)"

Write-Host ""
if ($choice -eq '1') {
    Install-Ytdlp
} elseif ($choice -eq '2') {
    Uninstall-Ytdlp
} else {
    Write-Host " [x] Invalid option selected." -ForegroundColor Red
}
