if (-not (Get-Module -ListAvailable -Name dbatools)) {
    Install-Module -Name dbatools
}
Import-Module -Name dbatools

$SqlInstance = 'localhost'                                                              # SQL Server name 
$Name = 'Management'                                                                    # database name
$DataFilePath = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\' # data file path
$LogFilePath = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\'  # log file path
$Recoverymodel = 'Simple'                                                               # recovery model
$Owner = $env:UserDomain + "\" + $env:UserName                                          # database owner
$PrimaryFilesize = 1024                                                                 # data file initial size
$PrimaryFileGrowth = 256                                                                # data file autrogrowth amount
$LogSize = 512                                                                          # data file initial size
$LogGrowth = 128                                                                        # data file autrogrowth amount

New-DbaDatabase -SqlInstance $SqlInstance -Name $Name -DataFilePath $DataFilePath -LogFilePath $LogFilePath -Recoverymodel $Recoverymodel -Owner $Owner -PrimaryFilesize $PrimaryFilesize -PrimaryFileGrowth $PrimaryFileGrowth -LogSize $LogSize -LogGrowth $LogGrowth | Out-Null
Write-Host("Successfully created Mangement DB")

$Name = 'Authorization'
New-DbaDatabase -SqlInstance $SqlInstance -Name $Name -DataFilePath $DataFilePath -LogFilePath $LogFilePath -Recoverymodel $Recoverymodel -Owner $Owner -PrimaryFilesize $PrimaryFilesize -PrimaryFileGrowth $PrimaryFileGrowth -LogSize $LogSize -LogGrowth $LogGrowth | Out-Null

Write-Host("Successfully created Authorization DB")