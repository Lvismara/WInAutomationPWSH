
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

$nets = netstat -an 
$output = @() 
foreach ($n in $nets)    { 
        $a = $n.Trim() 
        $a = $a -replace '\s+',' ' 
        $FileName =  $a -replace ' ',';' 
        $output += $FileName 
} 
$output|Out-file ./$hostName/$hostName"_Network_"$((Get-Date).ToString('MM-dd-yyyy')).csv 

# Serviços ativos:
 
get-service | Export-Csv -path ./$hostName/$hostName"_Services_"$((Get-Date).ToString('MM-dd-yyyy')).csv

# Programas instalados e vers=ões:

Get-WmiObject -Class Win32_Product -ComputerName . -Property Name,InstallDate,InstallLocation,PackageCache,Vendor,Version,IdentifyingNumber | Export-Csv -path ./$hostName/$hostName"_Packages_"$((Get-Date).ToString('MM-dd-yyyy')).csv

# Verificar usuário locais com permissão de administrador.

Get-WmiObject  -Class Win32_UserAccount |select * |  Export-Csv -path ./$hostName/$hostName"_LocalUsers_"$((Get-Date).ToString('MM-dd-yyyy')).csv

#Sever inventory

powershell -ExecutionPolicy ByPass -File get-inventory.ps1
