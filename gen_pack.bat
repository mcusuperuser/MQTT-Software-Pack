@ECHO OFF

REM Batch File for Generating a Software Pack

REM *****************
ECHO Remove previous installation
REM *****************
DEL   /q gen_pack_err.log
rmdir /s /q .\temp
mkdir    .\temp\
rmdir /s /q .\library-build\Objects
rmdir /s /q .\library-build\Listings
RMDIR /s /q .\Files
MKDIR .\Files\
MKDIR .\Files\doc\
MKDIR .\Files\SRC\
MKDIR .\Files\Lib\
MKDIR .\Files\Lib\ARM\

REM *****************
ECHO Downloading release 1.0.0 from git.eclipse.org:
REM *****************
"C:\Program Files (x86)\GnuWin32\bin\wget.exe" http://git.eclipse.org/c/paho/org.eclipse.paho.mqtt.embedded-c.git/snapshot/org.eclipse.paho.mqtt.embedded-c-1.0.0.zip
move org.eclipse.paho.mqtt.embedded-c-1.0.0.zip .\temp\

REM *****************
ECHO Extracting release
REM *****************
"C:\Program Files\7-Zip\7z.exe" x -o.\temp\ -y .\temp\org.eclipse.paho.mqtt.embedded-c-1.0.0.zip

REM *****************
ECHO Preparing source for library build
REM *****************
COPY /y .\temp\org.eclipse.paho.mqtt.embedded-c-1.0.0\MQTTPacket\src\* .\library-build

REM *****************
ECHO Building Cortex-M3 Little-endian library
REM *****************
c:\Keil_v5\UV4\UV4.exe -b .\library-build\mqtt.uvprojx -t"ARMv7M"
REM *****************
ECHO Building Cortex-M0 Little-endian library
REM *****************
c:\Keil_v5\UV4\UV4.exe -b .\library-build\mqtt.uvprojx -t"ARMv6M"

REM *****************
ECHO Preparing Package
REM *****************
COPY /y .\license.rtf .\Files\doc
COPY /y .\temp\org.eclipse.paho.mqtt.embedded-c-1.0.0\MQTTPacket\src\* .\Files\SRC
COPY /y .\library-build\Objects\*.lib .\Files\Lib\ARM

REM *****************
ECHO Check for a single PDSC file
REM *****************
SET count=0
FOR %%x IN (*.pdsc) DO SET /a count+=1
IF NOT "%count%"=="1" GOTO ErrPDSC

REM *****************
ECHO Set name of PDSC file to be packed
REM *****************
DIR /b *.pdsc > PDSCName.txt
SET /p PDSCName=<PDSCName.txt
DEL /q PDSCName.txt

REM *****************
ECHO Copy PDSC file to Files directory
REM *****************
COPY /y %PDSCName% Files

REM ************
ECHO   Checking
REM ************
C:\Keil_v5\ARM\Pack\ARM\CMSIS\4.3.0\CMSIS\Utilities\PackChk.exe .\Files\%PDSCName% -n MyPackName.txt

REM ************
ECHO Check if PackChk.exe has completed successfully
REM ************
IF %errorlevel% neq 0 GOTO ErrPackChk

REM ************
REM   Pipe Pack's Name into Variable
REM ************
SET /p PackName=<MyPackName.txt
DEL /q MyPackName.txt

REM ************
ECHO Packing
REM ************
PUSHD Files
"C:\Program Files\7-Zip\7z.exe" a %PackName% -tzip
MOVE %PackName% ..\
POPD
GOTO End

:ErrPDSC
ECHO There is more than one PDSC file present! >> gen_pack_err.log
EXIT /b

:ErrPackChk
ECHO PackChk.exe has encountered an error! >> gen_pack_err.log
EXIT /b

:End
ECHO End of batch file.