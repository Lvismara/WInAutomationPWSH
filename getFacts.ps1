
$Pcname = $env:COMPUTERNAME #get-host | select Name 

$hostName = $Pcname+"_"+$((Get-Date).ToString('MM-dd-yyyy'))

mkdir $hostName

# Discos locais e remotos montados

[System.IO.DriveInfo]::GetDrives() | Export-Csv -path ./$hostName/$hostName"_Discs_"$((Get-Date).ToString('MM-dd-yyyy')).csv

# Diretórios compartilhados e permissões

powershell -ExecutionPolicy ByPass -File ListAllSharedFolderPermission.ps1 

# Variáveis de ambiente

Get-ChildItem Env: | select Key*, Value* | Export-Csv -path ./$hostName/$hostName"_Enviroment_"$((Get-Date).ToString('MM-dd-yyyy')).csv 
               
# Versão do windows e update

systeminfo /fo csv | ConvertFrom-Csv | select OS*, System*, Hotfix* | Export-Csv -path ./$hostName/$hostName"_WinVersion_"$((Get-Date).ToString('MM-dd-yyyy')).csv

# Schedules (agendador de tarefas)

$tasks=schtasks /v /fo csv /query | Where-Object {$_.TaskName -ne "TaskName"} | ConvertFrom-Csv 
$tasks | Where-Object {$_.TaskName -ne "TaskName"} | Export-Csv -path ./$hostName/$hostName"_SchedulesTasks_"$((Get-Date).ToString('MM-dd-yyyy')).csv

# Lista de comunicação- Ips de entrada e saida (Comunicação entre os servidores), portas listen, etc

#netstat -ano | Out-File ./$hostName/Network_$((Get-Date).ToString('MM-dd-yyyy')).csv 

#$net=netstat -ano  ConvertFrom-Csv | Export-Csv -path ./$hostName/$hostName"_Network_"$((Get-Date).ToString('MM-dd-yyyy')).csv 

$data = (netstat -bano |select -skip 4 | Out-String) -replace '(?m)^  (TCP|UDP)', '$1' -replace '\r?\n\s+([^\[])', "`t`$1" -replace '\r?\n\s+\[', "`t[" -split "`n"

[regex]$regex = '(?<protocol>TCP|UDP)\s+(?<address>\d+.\d+.\d+.\d+|\[::\]|\[::1\]):(?<port>\d+).+(?<state>LISTENING|\*:\*)\s+(?<pid>\d+)\s+(?<service>Can not obtain ownership information|\[\w+.exe\]|\w+\s+\[\w+.exe\])'

$output = @()

$data | foreach {
    $_ -match $regex

    $outputobj = @{
        protocol = [string]$matches.protocol
        address = [string]$matches.address -replace '\[::\]','[..]' -replace '\[::1\]','[..1]'
        port = [int]$matches.port
        state = [string]$matches.state -replace "\*:\*",'NA'
        pid = [int]$matches.pid
        service = ([string]$matches.service -replace 'Can not obtain ownership information','[System' -split '.*\[')[1] -replace '\]',''
        subservice = ([string]$matches.service  -replace 'Can not obtain ownership information','' -split '\[.*\]')[0]
    }
    $output += New-Object -TypeName PSobject -Property $outputobj
}

$output |select address,port,protocol,pid,state,service,subservice | Export-Csv -path ./$hostName/$hostName"_Network_"$((Get-Date).ToString('MM-dd-yyyy')).csv 

# Serviços ativos:
 
get-service | Export-Csv -path ./$hostName/$hostName"_Services_"$((Get-Date).ToString('MM-dd-yyyy')).csv

# Programas instalados e vers=ões:

Get-WmiObject -Class Win32_Product -ComputerName . -Property Name,InstallDate,InstallLocation,PackageCache,Vendor,Version,IdentifyingNumber | Export-Csv -path ./$hostName/$hostName"_Packages_"$((Get-Date).ToString('MM-dd-yyyy')).csv

# Verificar usuário locais com permissão de administrador.

Get-WmiObject  -Class Win32_UserAccount |select * |  Export-Csv -path ./$hostName/$hostName"_LocalUsers_"$((Get-Date).ToString('MM-dd-yyyy')).csv

#Sever inventory

powershell -ExecutionPolicy ByPass -File get-inventory.ps1
