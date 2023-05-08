$ErrorActionPreference = 'SilentlyContinue'
Get-ChildItem -Path "$env:LOCALAPPDATA\CrashDumps" -r | rm -r -Force
gci -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache" -r | rm -r -Force  
gci -Path "C:\Program Files (x86)\Microsoft\EdgeUpdate\Download" -r | rm -r -Force  
gci -Path "$env:LOCALAPPDATA\Microsoft\Teams\packages" -r | rm -r -Force  
gci -Path "$env:APPDATA\Microsoft\Teams\Service Worker\CacheStorage" -r | rm -r -Force  
gci -Path "$env:APPDATA\Microsoft\Teams\Cache\Cache_Data" -r | rm -r -Force  
gci -Path "$env:APPDATA\Microsoft\Teams\previous" -r | rm -r -Force  
gci -Path "$env:APPDATA\Code\Cache\Cache_Data" -r | rm -r -Force  
gci -Path "$env:APPDATA\discord\Cache\Cache_Data" -r | rm -r -Force  
gci -Path "$env:LOCALAPPDATA\Spotify\Browser\Cache\Cache_Data" -r | rm -r -Force  
gci -Path "$env:LOCALAPPDATA\Spotify\Data" -r | rm -r -Force  
gci -Path "$env:LOCALAPPDATA\Package Cache" -r | rm -r -Force  
gci -Path "C:\ProgramData\Package Cache" -r | rm -r -Force  
gci -Path "$env:LOCALAPPDATA\Softdeluxe\Free Download Manager\cache" -r | rm -r -Force  
gci -Path "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache_4430\Cache" -r | rm -r -Force  
gci -Path "$env:LOCALAPPDATA\Steam\htmlcache\Cache" -r | rm -r -Force  
gci -Path "C:\Program Files\Microsoft Office\Updates\Download\PackageFiles" -r | rm -r -Force  
gci -Path "C:\Windows\SoftwareDistribution\Download\" -r | rm -r -Force  
gci -Path "$env:SystemRoot\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\" -r | rm -r -Force  
gci -Path "$env:SystemRoot\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Logs\" -r | rm -r -Force  
Clear-RecycleBin -Force