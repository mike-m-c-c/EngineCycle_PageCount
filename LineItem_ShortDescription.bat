@ECHO OFF
REM ==============================================================================
rem  
rem © Copyright 2020 HP, Inc.
rem 
rem Disclaimer Of Warranty and Support
rem THE SOFTWARE AND ANY RELATED DOCUMENTATION ARE PROVIDED "AS IS", WITHOUT 
rem WARRANTY OR SUPPORT OF ANY KIND.  THE ENTIRE RISK AS TO THE USE, RESULTS AND 
rem PERFORMANCE OF THE SOFTWARE AND DOCUMENTATION ARE ASSUMED BY YOU AND THOSE TO 
rem WHOM YOU PROVIDE THE SOFTWARE AND DOCUMENTATION.  HP Inc., AND THEIR AFFILIATES
rem AND SUBSIDIARIARIES HEREBY SPECIFICALLY DISCLAIM ANY AND ALL WARRANTIES, 
rem EXPRESS, IMPLIED OR STATUTORY, INCLUDING BUT NOT LIMITED TO THE IMPLIED 
rem WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE 
rem AND NONINFRINGEMENT.
rem 
rem Limitation Of Liability
rem IN NO EVENT SHALL HP Inc., OR THEIR AFFILIATES AND SUBSIDIARIARIES BE LIABLE 
rem FOR ANY CLAIM, DAMAGES (DIRECT, INDIRECT, INCIDENTAL, PUNITIVE, SPECIAL OR 
rem OTHER DAMAGES, INCLUDING WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS 
rem PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY 
rem LOSS AND THE LIKE) OR OTHER LIABILITY WHATSOEVER, WHETHER IN AN ACTION OF CONTRACT, 
rem TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
rem DOCUMENTATION, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH CLAIM, DAMAGES OR 
rem OTHER LIABILITY. 
rem 
rem  =============================================================================

cls

REM Echo PURPOSE:  Using SNMP, collect from HP printer OIDs define in the public printer MIB and proprietary HP MIB.
REM Echo This includes contractually authorized OIDs enabled by JetAdvantage Management used by HP Smart Device Services.
REM echo This script requires installation of https://sourceforge.net/projects/net-snmp/files/net-snmp%20binaries/5.7-binaries/*.exe
REM echo **Other versions should work fine.
REM echo USAGE INSTRUCTIONS:  From command prompt, type the batchfile name plus IP address of target printer.  Example...
REM echo.
REM echo C:\LineItem_ShartDescription 192.168.2.40
REM echo Data will print to screen and write to log file 
rem v2020-NOV-13_1730 mgm

Set LogFileSNMP=LineItem_ShortDescription.txt
Set NameCommunitySNMP=public

rem rem ECHO ========================================================================================
rem rem ECHO ==== Device Information Returned from Command Line Request to %1       ======
rem rem ECHO ========================================================================================
echo ------------------------------- >%LogFileSNMP%
echo DEVICE IDENTIFICATION >>%LogFileSNMP%
Echo IP Address >>%LogFileSNMP%
Echo %1  >>%LogFileSNMP%
echo. >>%LogFileSNMP%

:REM HP Printer Serial Number
:ECHO HP Printer Serial Number
:snmpget.exe -v 2c -c %NameCommunitySNMP% %1 .1.3.6.1.4.1.11.2.3.9.4.2.1.1.3.3.0
:echo.

:REM HP Product Model Name  >>%LogFileSNMP%
:ECHO HP Product Model Name >>%LogFileSNMP%
:snmpget.exe -v 2c -c %NameCommunitySNMP% %1 .1.3.6.1.4.1.11.2.3.9.4.2.1.1.3.2.0 >>%LogFileSNMP%
:Echo.  >>%LogFileSNMP%

:REM HP Devcie Name
:ECHO HP Device Name (if present)
:snmpget.exe -v 2c -c %NameCommunitySNMP% %1 .1.3.6.1.2.1.25.3.2.1.3.1
:Echo. 

:REM HP Model Number
:ECHO HP Model Number
:snmpget.exe -v 2c -c %NameCommunitySNMP% %1 .1.3.6.1.4.1.11.2.3.9.4.2.1.1.3.1.0
:Echo. 

:REM HP Device Firmware Version
:ECHO HP Device Firmware Version
:snmpget.exe -v 2c -c %NameCommunitySNMP% %1 .1.3.6.1.4.1.11.2.3.9.4.2.1.1.3.6.0
:Echo. 

echo HP Product Model Name >>%LogFileSNMP%
snmpget.exe -v 2c -c public -O v %1 .1.3.6.1.4.1.11.2.3.9.4.2.1.1.3.2.0 >>%LogFileSNMP%

:echo HP Device Firmware Version >>%LogFileSNMP%
:snmpget.exe -v 2c -c public -O v %1 .1.3.6.1.4.1.11.2.3.9.4.2.1.1.3.6.0 >>%LogFileSNMP%
REM echo %1 >>%LogFileSNMP% 
echo. >>%LogFileSNMP%
echo ------------NOT FOR BILLING-------------- >>%LogFileSNMP%

REM ========================================================================
echo TOTAL engine cycles* = >>%LogFileSNMP%
snmpwalk.exe -v 2c -c public -O v %1 1.3.6.1.2.1.43.10.2.1.4 >>%LogFileSNMP%
echo.>>%LogFileSNMP%
echo COLOR engine cycles* = >>%LogFileSNMP%
snmpget.exe -v 2c -c public -O v %1 1.3.6.1.4.1.11.2.3.9.4.2.1.4.1.2.7.0 >>%LogFileSNMP%
echo.>>%LogFileSNMP%
echo MONO engine cycles* = >>%LogFileSNMP%
snmpget.exe -v 2c -c public -O v %1 1.3.6.1.4.1.11.2.3.9.4.2.1.4.1.2.6.0  >>%LogFileSNMP%
echo. >>%LogFileSNMP%
echo ------------DESIGNED FOR BILLING---------- >>%LogFileSNMP%
echo COLOR 8x11 Impressions = >>%LogFileSNMP%
snmpget.exe -v 2c -c public -O v %1 1.3.6.1.4.1.11.2.3.9.4.2.1.1.16.1.20.2.2.0 >>%LogFileSNMP%
echo.>>%LogFileSNMP%
echo MONO 8x11 Impressions = >>%LogFileSNMP%
snmpget.exe -v 2c -c public -O v %1 1.3.6.1.4.1.11.2.3.9.4.2.1.1.16.1.20.1.2.0 >>%LogFileSNMP%
echo. >>%LogFileSNMP%
echo Simplex Total>>%LogFileSNMP%
snmpget.exe -v 2c -c public -O v %1 1.3.6.1.4.1.11.2.3.9.4.2.1.1.16.1.1.13.0>>%LogFileSNMP%
echo.>>%LogFileSNMP%
echo Duplex Total>>%LogFileSNMP%
snmpget.exe -v 2c -c public -O v %1 1.3.6.1.4.1.11.2.3.9.4.2.1.1.16.1.1.14.0>>%LogFileSNMP%
echo. >>%LogFileSNMP%
echo.>>%LogFileSNMP%
type %LogFileSNMP%



echo *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
:ECHO RESULT WRITTEN TO FILENAME:            >%LogFileSNMP%
ECHO RESULT SAVED  TO  FILENAME:  %time:~0,2%h%time:~3,2%m%time:~6,2%s--%LogFileSNMP%
:copy /Y >%LogFileSNMP%.txt %time:~0,2%h%time:~3,2%m%time:~6,2%s-->%LogFileSNMP%
:Notepad %LogFileSNMP%
ren %LogFileSNMP% %time:~0,2%h%time:~3,2%m%time:~6,2%s--%LogFileSNMP%

:move %time:~0,2%h%time:~3,2%m%time:~6,2%s-->%LogFileSNMP%.txt %temp%
:If not exist C:\JAMC\Logs-HPoidsMSKU MKDIR C:\JAMC\Logs-HPoidsMSKU
:move *h*m*s--.txt C:\JAMC\Logs-HPoidsMSKU
:move %time:~0,2%h%time:~3,2%m%time:~6,2%s-->%LogFileSNMP%.txt C:\JAMC\Logs-HPoidsMSKU
exit /b

