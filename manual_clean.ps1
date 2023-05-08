function Remove-Cache{
    param (
        [Parameter(Mandatory=$true)]
        [string]$path,                  #cached directory
        [Parameter(Mandatory=$true)]
        [string]$Name                   #cached name
    )
    Write-Host "Searching for $Name files..." -ForegroundColor Blue
    $CacheLocation = Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue
    if ($error[0].categoryinfo.category -match "PermissionDenied"){
        #change the output of the Errors so it does not confuse users
        Write-Warning "$path not existed or permission not granted"
        $Error.Clear()
        Clear-Variable CacheLocation
        return
    }else{
        # calculate the number of files
        $CacheCount = $CacheLocation.count
        Write-Host "Found $CacheCount files"
        if ($CacheCount -ge 1){
            # if the files is greater or equal to 1, which means there are cached files
            # display progress bar on top
            Write-Progress -Activity "Removing $Name files" -Status "Removing files..." -PercentComplete 0
            $percent = 0
            $CacheSize = 0
            $RemovedCache = 0
            foreach ($file in $CacheLocation) {
                $percent++
                Write-Progress -Activity "Removing $Name files" -Status "Removing file $percent of $CacheCount..." -PercentComplete (($percent/$CacheCount)*100)
                # remove cached files in the directory
                Remove-Item -Path $file.FullName -Recurse -ErrorAction SilentlyContinue
                if ($error[0].categoryinfo.category -match "WriteError"){
                    Write-Warning "$($path+'\'+$file) in used, close the application and retry."
                    $Error.Clear()
                }else{
                    $Cachesize+= $file.Length/1MB
                    $RemovedCache++
                }
            }
            #convert to 2 decimals
            $CacheSize = "{0:N2}" -f $CacheSize
            # show how many files & file size that has been removed 
            Write-Host "Removed $RemovedCache $Name files, $CacheSize MB space saved." -ForegroundColor Cyan
        }else{
            Write-Host "No $Name files found, skipping process..." -ForegroundColor Red
        }
    }
    Clear-Variable CacheLocation
    return
}

# Process started
Write-Host "**Cache Cleaning Tool**" -ForegroundColor Magenta
Write-Host "Select the folder to clean" -ForegroundColor DarkBlue
# list of processes
$processes = @(
    "1.CrashDumps",
    "2.RecycleBin",
    "3.Packages",
    "4.EpicGames",
    "5.Steam  ",
    "6.Discord",
    "7.MSEdge",
    "8.MSTeams",
    "9.VSCode",
    "10.Office365",
    "11.Spotify",
    "12.FDM"
)
#print menu
for ($i = 0; $i -lt $processes.Count; $i+=3){
    $process=""
    for ($j = $i; $j -lt ($i + 3); $j++){
        $index = $j
        if ($index -lt $processes.Count){
            $process += "$($processes[$index])`t"
        }
    }
    Write-Host "$process"
}

#prompt user for slections
$excludeSelections = Read-Host "Enter the correspond numbers to start cleaning (Seperate each number with a comma [,])`nSelection (ENTER to run ALL)"
# clean the input string from the user, accept only digits
$excludeSelections = $excludeSelections -split ',' | ForEach-Object {$_.Trim()} | Where-Object {$_ -match '^\d+$'} | ForEach-Object {[int]$_}

$exetime = Measure-Command{
    for ($i = 1; $i -le $processes.Count; $i++){
        if ($excludeSelections -eq $i){
            Write-Host "Skipping $($processes[$i-1])" -ForegroundColor Cyan
            continue
        }
        switch ($i){
            1 {
                #CrashDumps
                $path = "$env:LOCALAPPDATA\CrashDumps"
                Remove-Cache -Path $path -Name "CrashDumps"
            }
            2 {
                #RecycleBin
                Clear-RecycleBin -Force -ErrorAction SilentlyContinue
                Write-Host "RecycleBin has been emptied" -ForegroundColor Cyan
            }
            3 {
                #Packages
                $path = "C:\ProgramData\Package Cache"
                Remove-Cache -Path $path -Name "Global App Packages"
                $path = "$env:LOCALAPPDATA\Package Cache"
                Remove-Cache -Path $path -Name "Local App Packages"
            }
            4 {
                #EpicGames
                $path = "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache_4430\Cache"
                Remove-Cache -Path $path -Name "EpicGames Cache"
            }
            5 {
                #Steam
                $path = "$env:LOCALAPPDATA\Steam\htmlcache\Cache"
                Remove-Cache -Path $path -Name "Steam Cache"
            }
            6 {
                #Discord
                $path = "$env:APPDATA\discord\Cache\Cache_Data"
                Remove-Cache -Path $path -Name "Discord Cache"
            }
            7 {
                #MSEdge
                $path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
                Remove-Cache -Path $path -Name "MSEdge Cache"
                $path = "C:\Program Files (x86)\Microsoft\EdgeUpdate\Download"
                Remove-Cache -Path $path -Name "MSEdge Update Packages"
            }
            8 {
                #MSTeams
                $path = "$env:LOCALAPPDATA\Microsoft\Teams\packages"
                Remove-Cache -Path $path -Name "MSTeams Update Packages"
                $path = "$env:APPDATA\Microsoft\Teams\Service Worker\CacheStorage"
                Remove-Cache -Path $path -Name "MSTeams CacheStorage"
                $path = "$env:APPDATA\Microsoft\Teams\Cache\Cache_Data"
                Remove-Cache -Path $path -Name "MSTeams CacheData"
                $path = "$env:APPDATA\Microsoft\Teams\previous"
                Remove-Cache -Path $path -Name "MSTeams old installation"
            }
            9 {
                #VSCode
                $path = "$env:APPDATA\Code\Cache\Cache_Data"
                Remove-Cache -Path $path -Name "VSCode Cache"
            }
            10 {
                #Office365
                $path = "C:\Program Files\Microsoft Office\Updates\Download\PackageFiles"
                Remove-Cache -Path $path -Name "Office365 Cache"
            }
            11 {
                #Spotify
                $path = "$env:LOCALAPPDATA\Spotify\Browser\Cache\Cache_Data"
                Remove-Cache -Path $path -Name "Spotify Browser Cache Data"
                $path = "$env:LOCALAPPDATA\Spotify\Data"
                Remove-Cache -Path $path -Name "Spotify Cache Data"
            }
            12 {
                #FDM
                $path = "$env:LOCALAPPDATA\Softdeluxe\Free Download Manager\cache"
                Remove-Cache -Path $path -Name "FDM cache"
            }
        }
    }
}

Write-Host "Execution time: $($exetime.TotalSeconds) seconds"
# Prompt the user to press any key to exit
Pause