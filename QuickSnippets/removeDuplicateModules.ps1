###############################################################################
# removeDuplicateModules.ps1
# Purpose: This script is designed to avoid confusion regarding any powershell 
#          module import versioning. It searches powershell modules for 
#          duplicate module names and deletes any older versions as well as 
#          duplicate copies of the most recent version (arbitrarily). 
###############################################################################

$names = @()
$modules = Get-Module -ListAvailable
foreach ($module in $modules)
{
    $name = $module.Name
    if($names -contains $name)
    {
        "Duplicate entry $name found!"
        $list = $modules | Where-Object { $_.Name -eq $name }
        if ($list.length -ge 2)
        {
            ($ver1, $path1) = ([version]$list[0].Version, $list[0].ModuleBase)
            ($ver2, $path2) = ([version]$list[1].Version, $list[1].ModuleBase)
            $result = $ver1 -lt $ver2
            "Comparing version numbers: $ver1 and $ver2"
            if($result)
            {
                "Removing: $path1 with version $ver1"
                Remove-Item -Path $path1 -Recurse -Force
            }
            else
            {
                "Removing: $path2 with version $ver2"
                Remove-Item -Path $path2 -Recurse -Force
            }
        }
    }
    else
    {
        $names += $name
    }
}
