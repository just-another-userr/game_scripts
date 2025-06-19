# Author: theMadgamer 
# Date: May 2025
# Description: Script to swap mod folder names between our vanilla mods and Darkness Falls
# Version 1.0 - Initial script that renames the mod folders in 7dtd root and appdata with some error handling

# Global(s) 
$global:space = write-output " "
$global:rth = "C:\users\$env:username\documents"


function tmg_run_swap_check(){
    $answer = Read-Host -Prompt 'Would you like to swap mods now? Type y for YES or n for NO'
    while($answer -notmatch '[yYnN]'){
        $answer = Read-Host -Prompt 'You entered an invalid response? Type y for YES or n for NO'
    }
    return $answer
}

function tmg_config_check(){
    # Check for existence of config file and perform first time config if none is found
    # Set some vars
    $username = $env:username
    $config_name = $username + "_config.ps1"
    $config_path =  ".\$config_name"
    $username_upper = $username.ToUpper()
    # Look for existing configuration file
    $result1 = Test-Path -path $config_path
    
    if($result1 -eq $false){
        # Advise of script needs and collect game_path 
        $space
        Write-Output "Hello, $username_upper"
        [System.Threading.Thread]::Sleep(1500)
        $space
        write-output "It looks like this is the first time you're running this script"
        [System.Threading.Thread]::Sleep(2500)
        write-output "We're going to gather a few pieces of information that the script needs to swap mods"
        [System.Threading.Thread]::Sleep(3000)
        write-output "This will create a file called '$config_name'"
        [System.Threading.Thread]::Sleep(1500)
        write-output "in the directory that the script is in and only needs to be done this once"
        [System.Threading.Thread]::Sleep(2000)
        # Need to add functionality to gather game_patch and save to config file
        try {
        New-Item -ItemType File -Name $config_name -ErrorAction Stop | Out-Null
        } 
        catch {
            Write-Output "The script ran into an issue when creating the config file, please check the permissions on the directory and run the script again!"
            [System.Threading.Thread]::Sleep(20000)
            break
        }
    $space
    write-output "Please select the location of your Mods folder: "
    write-output "This should look something like C:\SteamLibrary\steamapps\common\7 Days To Die"
    # Gather game_path location and save to new config file
    # Load the Windows Forms assembly
    Add-Type -AssemblyName System.Windows.Forms
    
    # Create a new FolderBrowserDialog object
    $folder_browser_dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    
    # Set the initial directory
    $folder_browser_dialog.RootFolder = "Desktop"
    
    # Set the dialog title
    $folder_browser_dialog.Description = "Select a Folder"
    
    # Show the dialog box
    $result = $folder_browser_dialog.ShowDialog()
    
    # Check if the user selected a folder
    if ($result -eq "OK") {
        # Get the selected folder path
        $game_path = $folder_browser_dialog.SelectedPath
        }
        try {
            Set-Content -Path $config_path -value "`$global:game_path = '$game_path'"
        } catch {
            Write-Output "There was an error when writing to the config file, please confirm the directory permissions and run the script again"
        }       
        # Check to see if the user wants to swap mods now and run if so Run mod swap
        Write-output 'Config file created'
        Write-Output ' '
        $answer = tmg_run_swap_check
        if ($answer -eq 'n'){
            break
        } else {
            tmg_mod_swap
        }
    } else {
        # Config file exists, run mod swap
        tmg_mod_swap
}
    
}
function tmg_mod_swap(){

    write-output "Config file found!"
        [System.Threading.Thread]::Sleep(1500)
        $space
        # Dot-source the config 
        try {
        . "$PSScriptRoot\$config_name"
        $game_path = $game_path
    
        write-output "The path to the mods is $game_path, the script will now move there to start the swap"
        } catch {
            write-output "The script was not able to read the config file. Please check permisssions and rerun this script"
        }
    # Set folder names in vars
    $df_mod = 'Mods.DF'
    $vanilla_mod = 'Mods.vanilla'

    # Define folder paths (game_path will eventually be defined by the user during script configuration, hard coding for now)
    $appdata_path = "C:\Users\$env:username\AppData\Roaming\7DaysToDie"
    

    # Validate folder paths
    $result1 = test-path -Path $game_path
    $result3 = Test-Path -Path $appdata_path
    if ($result1 -eq $false){
        Write-Output "The game directory was not found, please confirm the folder exists and rerun the configuration"
        [System.Threading.Thread]::Sleep(5500)
        break
    } elseif ($result3 -eq $false){
        Write-Output "The appdata directory was not found, please confirm the folder exists and rerun the configuration"
        [System.Threading.Thread]::Sleep(5500)
        break
    } else {

    # Perform try to get the last played mod
    try {
        # Figure out which mod was played last
        $mod_check= Get-ChildItem -Path "$game_path\Mods.*" -ErrorAction Stop
        $not_current_mod = $mod_check.Name
    }
    catch {
        # Need to create options for configuration and running the script
        $space
        Write-Output "No additional Mods folders were found. Please check the directory path for the game and rerun the setup"
        Write-Output "$($_.Exception.Message)"
        break
    }
        
    # End message
    $msg = "Mods switched successfully! Now go stab some bitch ass zombies"

    # Add ascii cat to output while user waits
$cat = @'
     /\_/\  
    ( o.o ) 
     > ^ < 
'@

    Set-Location -Path "$game_path"

    # Make base 7dtd directory name change and advise user with helpful message 
    if ($not_current_mod -eq $vanilla_mod){
        # Change to Vanilla Mod
        write-output 'Current Mod is Darkness Falls, the script will set the active mods to Vanilla!'
        $space = write-output " "
        $space = write-output " "
        Write-Host $cat -ForegroundColor Magenta
        $space = write-output " "
        [System.Threading.Thread]::Sleep(3500)

        # Rename Mods in 2nd try 
        try {
            rename-item -Path "$game_path\Mods" -NewName $game_path\$df_mod -ErrorAction Stop
            rename-item -Path $game_path\$vanilla_mod -NewName "$game_path\Mods" -ErrorAction Stop
            # Load appdata mods for the vanilla games to work 
            Rename-Item -Path $appdata_path\$vanilla_mod -NewName "$appdata_path\Mods" -ErrorAction Stop
            $space
            write-output $msg
        }
        catch {
            $space
            Write-Output "An error occurred when setting the mod to Vanilla"
            Write-Output "$($_.Exception.Message)"
            break
        }
        [System.Threading.Thread]::Sleep(3500)

    } elseif ($not_current_mod -eq $df_mod) {
        # Change to Darkness Falls Mod 
        write-output 'Current Mod is Vanilla, the script will set the active mods to Darkness Falls'
        $space = write-output " "
        $space = write-output " "
        Write-Host $cat -ForegroundColor Magenta
        $space = write-output " "
        [System.Threading.Thread]::Sleep(3500)

        # Rename Mods 
        try {
        rename-item -Path "$game_path\Mods" -NewName $game_path\$vanilla_mod -ErrorAction Stop
        rename-item -Path $game_path\$df_mod -NewName "$game_path\Mods" -ErrorAction Stop
        # Rename appdata mod (no replacement needed as DF doesn't have any mods that need to go here)
        Rename-Item -Path "$appdata_path\Mods" -NewName $vanilla_mod -ErrorAction Stop
        $space
        write-output $msg
        }
        catch {
            Write-Output "There was an error when setting the mod to Darkness Falls"
            Write-Output "$($_.Exception.Message)"
            break
        }
        [System.Threading.Thread]::Sleep(3500)
    }

}
}
# Run config check function 
tmg_config_check
set-location -Path $rth