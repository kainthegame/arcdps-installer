$arcDpsFolder = "$($env:TEMP)\arcdps"
$gw2FolderRoot = "C:\Program Files\Guild Wars 2"

New-Item -Path $arcDpsFolder -ItemType Directory -Force | Out-Null
Get-ChildItem -Path $arcDpsFolder | Remove-Item -Force

Invoke-WebRequest "https://www.deltaconnected.com/arcdps/x64/d3d11.dll" -OutFile "$arcDpsFolder\d3d11.dll"
Invoke-WebRequest "https://www.deltaconnected.com/arcdps/x64/d3d11.dll.md5sum" -OutFile "$arcDpsFolder\d3d11.dll.md5sum"

$md5sum = Get-Content -Path "$arcDpsFolder\d3d11.dll.md5sum"
$md5sum = $md5sum.Substring(0, $md5sum.IndexOf(" "))

$filesum = (Get-FileHash -Path "$arcDpsFolder\d3d11.dll" -Algorithm MD5).Hash

if ($filesum.ToLower() -ne $md5sum.ToLower()) {
    throw "Check Sum FAILED"
}

$vLatestInfo = Get-ChildItem -Path "$arcDpsFolder\d3d11.dll" | Select-Object -ExpandProperty VersionInfo
Write-Host "ArcDPS latest version: $($vLatestInfo.ProductVersion)" -ForegroundColor Green

$vInstalledVersion = $null
if (Test-Path "$gw2FolderRoot\d3d11.dll" -PathType Leaf) {
    $vInstalledVersion = Get-ChildItem -Path "$gw2FolderRoot\d3d11.dll" | Select-Object -ExpandProperty VersionInfo
    Write-Host "ArcDPS current version: $($vInstalledVersion.ProductVersion)" -ForegroundColor Green
} else {
    Write-Host "ArcDPS current version: NONE" -ForegroundColor Green
}

if ($vLatestInfo.ProductVersion -eq $vInstalledVersion.ProductVersion) {
    Write-Host "ArcDPS is already at the latest version!" -ForegroundColor Cyan
} else {
    Write-Host "Do you wish to install ArcDPS version $($vLatestInfo.ProductVersion)? (y/n)" -ForegroundColor Cyan
    $option = Read-Host -Prompt "y or n"
    if ($option.ToLower() -eq "y" -or $option.ToLower() -eq "yes") {
        Copy-Item -Path "$arcDpsFolder\d3d11.dll" -Destination "$gw2FolderRoot\d3d11.dll" -Force
        if (Test-Path "$gw2FolderRoot\d3d11.dll" -PathType Leaf) {
            $vInstalledVersion = Get-ChildItem -Path "$gw2FolderRoot\d3d11.dll" | Select-Object -ExpandProperty VersionInfo
            if ($vInstalledVersion.ProductVersion -eq $vLatestInfo.ProductVersion) {
                Write-Host "ArcDPS successfully installed/updated" -ForegroundColor Cyan
            } else {
                Write-Warning "Copied version of ArcDPS is incorrect. Latest: $($vLatestInfo.ProductVersion) | Current: $($vInstalledVersion.ProductVersion)"
            }
        } else {
            Write-Warning "File wasn't copied to $gw2FolderRoot\d3d11.dl"
        }
    }
}

Read-Host -Prompt "Press any key to exit"
