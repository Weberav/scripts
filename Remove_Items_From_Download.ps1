Get-ChildItem '~\Desktop' | Remove-Item -Include *.log -Recurse
 
 
 function date_time()
 {
     return (Get-Date -UFormat "%Y-%m-%d_%I-%M-%S").tostring()
 }



 $logFileName = "Log_" + (date_time) + ".log"

 $logFileName


Get-ChildItem '~\Downloads' | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-1))} | Remove-Item -Force -Verbose 4>&1 | Add-Content ~\Desktop\$logFileName