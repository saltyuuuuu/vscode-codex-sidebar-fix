[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ''
Write-Host '  ===== Codex Sidebar Fix Tool =====' -ForegroundColor Cyan
Write-Host '  Fix: Codex icon missing from left sidebar' -ForegroundColor Cyan
Write-Host '  VS Code / Trae / Cursor / Windsurf' -ForegroundColor Cyan
Write-Host '  =====================================' -ForegroundColor Cyan
Write-Host ''

$subs  = @('.vscode', '.vscode-insiders', '.trae', '.trae-cn', '.cursor', '.windsurf')
$names = @('VS Code', 'VS Code Insiders', 'Trae', 'Trae CN', 'Cursor', 'Windsurf')
$totalFixed = 0
$totalFound = 0

# UTF-8 WITHOUT BOM - critical for package.json
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

for ($i = 0; $i -lt $subs.Count; $i++) {
    $extRoot = Join-Path $env:USERPROFILE "$($subs[$i])\extensions"
    if (-not (Test-Path $extRoot)) { continue }

    $dirs = Get-ChildItem $extRoot -Directory -Filter 'openai.chatgpt-*' -ErrorAction SilentlyContinue
    foreach ($d in $dirs) {
        $pkg = Join-Path $d.FullName 'package.json'
        if (-not (Test-Path $pkg)) { continue }
        $totalFound++

        $ver = $d.Name -replace 'openai\.chatgpt-', ''
        Write-Host "  $($names[$i]) - Codex v$ver" -ForegroundColor Yellow
        Write-Host "  $pkg" -ForegroundColor Gray

        $raw = [System.IO.File]::ReadAllText($pkg, $utf8NoBom)

        # Regex: remove "when": "chatgpt.doesNotSupportSecondarySidebar" (without !)
        # Also removes the trailing comma on the previous line
        $pattern = ',\s*[\r\n]+\s*"when"\s*:\s*"chatgpt\.doesNotSupportSecondarySidebar"'
        $found = [regex]::Matches($raw, $pattern)

        if ($found.Count -gt 0) {
            $patched = [regex]::Replace($raw, $pattern, '')
            Write-Host "  [OK] Removed $($found.Count) when condition(s)" -ForegroundColor Green

            $ts = Get-Date -Format 'yyyyMMdd_HHmmss'
            Copy-Item $pkg "$pkg.bak_$ts"
            Write-Host '  [OK] Backup created' -ForegroundColor Green

            # Write WITHOUT BOM
            [System.IO.File]::WriteAllText($pkg, $patched, $utf8NoBom)
            Write-Host '  [OK] Saved (UTF-8 no BOM)' -ForegroundColor Green
            $totalFixed++
        }
        else {
            Write-Host '  [SKIP] Already patched' -ForegroundColor DarkGray
        }
        Write-Host ''
    }
}

if ($totalFound -eq 0) {
    Write-Host '[ERR] No Codex extension found' -ForegroundColor Red
    Write-Host ''
    for ($i = 0; $i -lt $subs.Count; $i++) {
        $p = Join-Path $env:USERPROFILE "$($subs[$i])\extensions"
        if (Test-Path $p) {
            Write-Host "  [Y] $($names[$i]): $p" -ForegroundColor Green
        }
        else {
            Write-Host "  [N] $($names[$i]): $p" -ForegroundColor DarkGray
        }
    }
}
elseif ($totalFixed -gt 0) {
    Write-Host "[OK] Fixed $totalFixed extension(s). Please restart your IDE." -ForegroundColor Green
}
else {
    Write-Host '[SKIP] All extensions already patched.' -ForegroundColor DarkGray
}
