@echo off
REM Fundamental configuration initialization
set BASE=d:
set BASE_PATH=D:\bat\ftp
set LOG_FILE=%BASE_PATH%\ftpgetfile.log

set FLAG_FILE=%BASE_PATH%\tmp.tmp
set DOWNLOAD_PATH=%BASE_PATH%\download
set TMP_PATH=%BASE_PATH%\temp
REM remote ftp directory
set REMOTE_PATH=/ftp_dir
REM program running begin
echo "==========================begin=================================" >> %LOG_FILE%
set mydate=%date:~0,10% %time:~0,8%
echo "Program is running start time:%mydate%" >> %LOG_FILE%
%BASE%
if not exist %BASE_PATH% (
  mkdir %BASE_PATH%
)
if not exist %DOWNLOAD_PATH% (
  mkdir %DOWNLOAD_PATH%
)
if not exist %TMP_PATH% (
  mkdir %TMP_PATH%
)
cd %TMP_PATH%
REM  presetting 0 into flag file,if the program running is ok ,end of this program this flag will be updated to 1
echo 0 > %FLAG_FILE%
if not exist %DOWNLOAD_PATH% (
	echo Can't found the %DOWNLOAD_PATH% >> %LOG_FILE%
)
ftp -s:"%BASE_PATH%\getfile.ftp" >> %LOG_FILE%
echo Following is the get files list：>> %LOG_FILE%
dir /B %TMP_PATH%\*.* > %BASE_PATH%\filelist.tmp 
setlocal EnableDelayedExpansion
set count=0
FOR /F  "delims=" %%i IN (%BASE_PATH%\filelist.tmp) DO (
    set /a count+= 1
)
if %count% == 0 (
	echo "NO files need download!" >> %LOG_FILE%
	exit
)
dir /B %TMP_PATH%\*.* >> %LOG_FILE%
REM move temporary files to download directory
move /Y %TMP_PATH%\*.* %DOWNLOAD_PATH%\
set num=1
set filelist=
FOR /F "delims=" %%i IN (%BASE_PATH%\filelist.tmp) DO (
	set filelist=!filelist! %%i
	REM one time delete 5 files , this parameter is the flexible value that you can set it according you require
	set /a tmp = !num! %% 5
	if !tmp! == 0 (
		call %BASE_PATH%\removefile.bat "!filelist!" %LOG_FILE% %REMOTE_PATH%
		set filelist=
	) else (
		if !count! LEQ !num! (
			call %BASE_PATH%\removefile.bat "!filelist!" %LOG_FILE% %REMOTE_PATH%
			set filelist=
		)
	)
	set /a num+= 1
)
endlocal 
REM set flag is 1
echo 1 > %FLAG_FILE%
set mydate=%date:~0,10% %time:~0,8%
echo "==========================end=================================" >> %LOG_FILE%
echo "Program is running end:%mydate%" >> %LOG_FILE%
exit

