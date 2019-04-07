@echo off
cd "Program Files"
:menu
SET line=--------------
cls
title Please choose an option
choice /c:RL /m "Choose an option: Register (R) or Login (L):
if errorlevel 2 goto login
if errorlevel 1 goto register

:login
cls
title Please login
SET u=harry
SET p=nopassword
cls
set /p u=Username: 
editv64 -m -p "Password: " p
REM Sets the variable p2 from the first line of %u%.login
set /p p2=<%u%.login
REM Saves the variable p2 in the file old.pass
echo %p2%>>old.pass
REM decrypts the variable p2 from the password, and saves it as new.pass
openssl enc -d -A -a -aes-256-cbc -in old.pass -out new.pass -k encryptionkey
REM Sets the variable encpass3 as the first line of new.pass
set /p encpass3=<new.pass
REM Deletes the before and after files as they are saved as variables
del old.pass
del new.pass
REM If the password the user types, matches the decrypted variable, goto done
if %encpass3%==%p% goto done
goto login

:register
cls
title User Creation Tool
echo %line%
echo Welcome to the User Creation Tool.
echo %line%
echo.
echo Please enter the login details of an admin:
echo.
set /p adminchecku=Enter a Staff Username: 
editv64 -m -p "Enter a Staff Password: " admincheckp
(
set /p acpass=
set /p acperm=
)<%adminchecku%.login
echo %acpass%>>old.pass
openssl enc -d -A -a -aes-256-cbc -in old.pass -out new.pass -k encryptionkey
set /p encpass3=<new.pass
del old.pass
del new.pass
if %encpass3%==%admincheckp% goto checkrole
goto menu

:checkrole
cls
if %acperm%==normal goto noperm
if %acperm%==admin goto register2


:done
cls
title Logged in as %u%.
echo Welcome %u%.
echo.
echo 1) Check permissions
echo 2) List users
echo 3) Message Admins
echo 4) Change a Password
echo 5) Logout
set /p menuc=Enter number: 
if %menuc%==1 goto cperm
if %menuc%==2 goto lusers
if %menuc%==3 goto mad
if %menuc%==4 goto cngpwd
if %menuc%==5 goto menu
cls
echo That is not an option.
pause
goto done

:logpro
cls
title Logging out.
goto menu



:mad
cls
title Please choose an option
echo 1) Message Admins
echo 2) Read Messages
echo 3) Quit
set /p choo=
if %choo%==1 goto mesad 
if %choo%==2 goto redad
if %choo%==3 goto done
cls
echo That is not an option.
pause
goto mad

:mesad
cls
title Message an admin.
echo Please type a message you would like to send to the admins.
set /p msg=
echo Message from %u%: >> msg.admin
echo %msg% >> msg.admin
echo. >> msg.admin
cls
echo Message has been sent.
pause
goto done



:redad
cls
title Read messages
(
set /p acpass=
set /p acperm=
)<%u%.login
if %acperm%==normal goto noperm2
if %acperm%==admin goto redad2

:redad2
cls
if not exist msg.admin goto nomsg
echo Here are the latest messages.
echo.
type msg.admin
pause
set /p qd=Would you like to clear the messages? [Y/n]
if %qd%==Y del msg.admin && goto done
if %qd%==y del msg.admin && goto done
if %qd%==N goto done
if %qd%==n goto done


:nomsg
title No messages found.
cls
echo There are no messages to be read.
pause
goto done


:noperm2
cls
title You are not staff.
echo You are not staff on the login system.
echo Try again later.
pause
goto done

:cperm
cls
title Check permissions
(
set /p acpass=
set /p acperm=
)<%u%.login
if %acperm%==normal goto noperm2
if %acperm%==admin goto cperm2

:cperm2
cls
title Check permissions
echo Enter the name of the user you would like to check:
set /p nc=
(
set /p acpass=
set /p acperm=
)<%nc%.login
cls
echo This account is %acperm%.
pause
goto done

:lusers
cls
title List users
(
set /p acpass=
set /p acperm=
)<%u%.login
if %acperm%==normal goto noperm2
if %acperm%==admin goto lusers2

:lusers2
cls
echo Here is a list of users:
echo.
dir *.login
pause
goto done



:register2
cls
title User Creation Tool
echo %line%
echo Welcome to the User Creation Tool.
echo %line%
echo.
echo Please enter the login details of the user you would like to create:
echo.
set /p ru=Username: 
set /p rp=Password: 
set /p aorn=Should this account be admin (a) or normal (n)? 
cls
del %ru%.login
cls
if %aorn%==n goto normalreg
if %aorn%==a goto adminreg
cls
echo This is not an option.
pause
goto menu



:noperm
cls
title You are not staff.
echo You are not staff on the login system.
echo Try again later.
pause
goto menu

:normalreg
cls
set regtype=normal
echo %rp% >> old.pass
openssl enc -A -a -aes-256-cbc -in old.pass -out new.pass -k encryptionkey
set /p rp2=<new.pass
echo %rp2% >> %ru%.login
echo normal >> %ru%.login
del old.pass
del new.pass
goto regdone


:adminreg
cls
set regtype=admin
echo %rp% >> old.pass
openssl enc -A -a -aes-256-cbc -in old.pass -out new.pass -k encryptionkey
set /p rp2=<new.pass
echo %rp2% >> %ru%.login
echo admin >> %ru%.login
del old.pass
del new.pass
goto regdone


:regdone
cls
title User created
echo Created a user with the name: %ru%
echo Created a user with the password: %rp%
echo Created a user with the permissions of: %regtype%
echo.
pause
goto menu

:cngpwd
cls
title Change a Password
echo 




