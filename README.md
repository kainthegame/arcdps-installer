# arcdps-installer
ArcDPS installer/updater

## Running script with powershell
It's possible that powershell scripts are blocked from running on your machine. For more information, consult the microsoft documentation [here](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.3).
An example to set the execution policy for running scripts: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

## Running script via command prompt
You can execute the `Install-ArcDPS.bat` file and this will call the powershell script.
