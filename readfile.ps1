foreach($line in Get-Content ./file.txt) {
        Write-Host "line: " $line
        Get-Acl $line | format-list

        # Write-Output $line | Export-Csv -path ./table.csv
}

# Export-Csv -path C:\example\excel.csv

# $startFolder = "/home/lvismara/Documents/windows/"
# $L1folders = get-childitem $startFolder

# write-host = $L1folders
# Foreach ($L1folder in $L1folders) {   

        
#         write-host "L2:"
#         write-host $L2folder      
#         write-host $L2folder.fullname   

#         Get-Acl $L2folder.FullName | format-list


# #         write-host "L1"
# #         write-host $L1folder
# #         $L2folders = Get-ChildItem $L1folder.FullName -Directory -Recurse
# #         write-host $L2folders
# #         Foreach ($L2folder in $L2folders) { 
              
# #                 #insert magic code to grant full permission for domain users group here
# #     }
# }