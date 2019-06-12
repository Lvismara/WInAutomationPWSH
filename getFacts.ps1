# Discos locais e remotos montados

[System.IO.DriveInfo]::GetDrives() | Format-Table | Export-Csv -path ./Discos.csv

# Diretórios compartilhados e permissões

powershell -ExecutionPolicy ByPass -File ListAllSharedFolderPermission.ps1 | Export-Csv -path ./Paths.csv

# Variáveis de ambiente

Get-ChildItem Env: | Export-Csv -path ./Enviroment.csv
               
# Versão do windows e update

systeminfo /fo csv | ConvertFrom-Csv | select OS*, System*, Hotfix* | Format-List | Export-Csv -path ./WinVersion.csv

# Schedules (agendador de tarefas)

schtasks /query /fo LIST | Export-Csv -path ./SchedulesTasks.csv

# Lista de comunicação- Ips de entrada e saida (Comunicação entre os servidores), portas listen, etc

netstat -an | Export-Csv -path ./Net.csv
               
# Programas em execução:

 
# Serviços ativos:

get-services | Export-Csv -path ./services.csv

# Programas instalados e versões:

Get-WmiObject -Class Win32_Product -ComputerName . | Format-List -Property Name,InstallDate,InstallLocation,PackageCache,Vendor,Version,IdentifyingNumber | Export-Csv -path ./Packages.csv

# Verificar usuário locais com permissão de administrador.

Get-WmiObject  -Class Win32_UserAccount|select * | Export-Csv -path ./Users.csv