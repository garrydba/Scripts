$filePath="C:\temp\theFile.txt"
$dateTimeToChange="30 August 2021 18:10:00"

(Get-Item $filePath).CreationTime=($dateTimeToChange)
(Get-Item $filePath).LastWriteTime=($dateTimeToChange)
(Get-Item $filePath).LastAccessTime=($dateTimeToChange)