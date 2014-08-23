echo open your ftp host>ftp.txt
echo username>>ftp.txt
echo password>>ftp.txt
echo cd %3>>ftp.txt
REM remove quotation marks from head to tail
set tmp=%1
set "tmp=%tmp:"=%"
REM echo prompt off>>ftp.txt 
REM mdelete format: mdelete 1.txt 2.txt 3.txt 
echo mdelete %tmp%>>ftp.txt 
echo bye>>ftp.txt
echo quit>>ftp.txt
echo exit>>ftp.txt
ftp -i -s:ftp.txt >>%2
del ftp.txt

