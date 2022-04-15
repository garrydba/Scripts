@echo off

set svnAdminPath="C:\Program Files\VisualSVN Server\bin"
set repositoryRoot=C:\Repositories
set backupPath=C:\temp\svn_dumps
set dateStamp=%DATE:~-4%-%DATE:~4,2%-%DATE:~7,2%

for /f %%f in ('dir /b /AD %%repositoryRoot%%') do ( 
call:dumpRepository %%f 
)
goto:eof

:dumpRepository
cd /d %svnAdminPath%
set repoPath=%repositoryRoot%/%~1
set dumpFile=%~1_%dateStamp%
echo.-------------------
echo.Dumping %~1 to %dumpFile%.dump
echo.-------------------
svnadmin dump "%repoPath%" > "%backupPath%\%dumpFile%.dump"
exit /b


pause