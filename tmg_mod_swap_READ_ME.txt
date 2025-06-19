7dtd Mod swap script instructions: 

This script will perform a name swap for the 7D2D version 1.4 mod folders in 2 locations;
	- the 'Base Game Folder', usually found in '<Some Letter>:\SteamLibrary\steamapps\common\7 Days To Die\'
	and 
	- the 'Appdata Location' that The Fun Pimps recommend most mods be placed in, usually found in C:\Users\<username>\AppData\Roaming\7DaysToDie
	
We have vanilla mods in both of the above locations so this script handles them both even though the Darkness Falls mods are all in the 'Base Game folder'
	
1) Determine which mod is currently loaded and create the necessary additional directory

	- If Darkness Falls is loaded, create a directory in the 'Base Game Folder' and 'Appdata Location' called 'Mods.vanilla' and add the vanilla mods.
	
	- If the vanilla mods are loaded, create a directory in the base game folder called 'Mods.DF' and add the Darkness Falls mods. (Note that there are no Darkness Falls mods in the 'Appdata Location' so the script doesn't do anything in that location when switching back to vanilla)

2) Download script and place it in C:\users\$env:username\documents

3) Close all File explorer or Shell windows to the Appdata Location or Base Game Folders

4) Open Powershell and run the following commands:

	- Set-ExecutionPolicy -ExecutionPolicy Unrestricted
	- cd C:\users\$env:username\documents
	- .\tmg_7dtd_mod_swap.ps1

5) Navigate to Base Game Folder and select it 
6) The script will swap to the non-active mod 

# Troubleshooting: 

If the script isn't working or is throwing an error, make sure there are no processes or windows accessing the Base Game Folder and rerun
