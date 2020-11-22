@echo off

title Window's script
color 0C
echo Checking admin rights...
net sessions

if %errorlevel%==0 (
echo Sucess
) else (
echo give/run the script admin privileges
pause
exit 
)
color 0A

:menu
cls
echo "These options are not in order"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "1) PasswordPolicies/Lockout Policies (auto/manual)"
echo "2) firewall (auto/manual)"
echo "3) userAccount (Ctrl Alt Del) (manual)"
echo "4) Automatic Updates (auto/manual)"
echo "5) list of command to delete user, change password for user, etc. (manual)"
echo "6) Disabling services"
echo "7) Enable/Disable remote Desktop"
echo "8) Disable guest/admin account"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo type in the number:
set /p options=Please choose an option (number): 
	if %options% ==1 goto :PasswordPolicies
	if %options% ==2 goto :firewall
	if %options% ==3 goto :userAccount
	if %options% ==4 goto :autoUpdate
	if %options% ==5 goto :manageUserCmd
	if %options% ==6 goto :disablingServices
	if %options% ==7 goto :remoteDesktop
	if %options% ==8 goto :disAccounts

pause

:PasswordPolicies
echo changing password PasswordPolicies. Make sure to check Account Lockout Policies
REM minimum password length: 8, maximum password age: 30, Password history: 5, minimum password age: 10 
REM Account lockout threshold: 5, Account lockout duration: 30, Reset account lockout counter after: 30
net accounts /MINPWLEN:8 /MAXPWAGE:30 /UNIQUEPW:5 /MINPWAGE:10 /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30
echo starting secpol.msc for manual process
start secpol.msc
pause
goto:menu

:manageUserCmd
REM list of commands to manage users
echo look at the list of users (it makes it easier to find admin)
net user
echo "I am going to use John Doe as an example "
echo "To add new user: "
echo "net user username password /ADD"
echo "For example, net user JohnDoe thisisJohnDoePassword777 /ADD "
echo "To change Password (Asterisk included): " 
echo "net user JohnDoe * "
echo "how to give admin prievelege to a user: "
echo "net localgroup administrators JohnDoe /add "
echo "If you want to add a user to a group: "
echo "net localgroup coolPersonGroup JohnDoe /add"
echo "this command will add JohnDoe in group called coolPersonGroup"
start cmd /wait
pause
goto:menu

:disAccounts
REM Admin and Guest disabled
echo turn off admin and guest
net user administrator /active:no
net user guest /active:no
goto:menu

:firewall
echo choose y for automatic and choose n for manual process
set /p firewallChk="Enable firewall and basic firewall rules (y/n)"
if %firewallChk%==y (
	REM Firewall enable
	netsh advfirewall set allprofiles state on
	echo Firewall enabled (please manually check some of the settings)
	echo Setting basic firewall rules..
	netsh advfirewall firewall set rule name="Remote Assistance (DCOM-In)" new enable=no 
	netsh advfirewall firewall set rule name="Remote Assistance (PNRP-In)" new enable=no 
	netsh advfirewall firewall set rule name="Remote Assistance (RA Server TCP-In)" new enable=no 
	netsh advfirewall firewall set rule name="Remote Assistance (SSDP TCP-In)" new enable=no 
	netsh advfirewall firewall set rule name="Remote Assistance (SSDP UDP-In)" new enable=no 
	netsh advfirewall firewall set rule name="Remote Assistance (TCP-In)" new enable=no 
	netsh advfirewall firewall set rule name="Telnet Server" new enable=no 
	netsh advfirewall firewall set rule name="netcat" new enable=no
	echo Set basic firewall rules
)

if %firewallChk%==n (
	echo set up the firewall manually
	start firewall.cpl
	pause
	goto:menu
)
echo Invalid input %firewallChk%
goto firewall


:userAccount
echo please check the user settings (also look at CTRL + ALT + DEL)
start Control Userpasswords2
pause
goto:menu

:autoUpdate
echo automatic Update
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 4 /f
start ms-settings:windowsupdate /wait
pause
goto:menu

:remoteDesktop
set /p remoteChk="Do you want to enable remote desktop (y/n)"
 if %remoteChk%==y (
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v AllowTSConnections /t REG_DWORD /d 1 /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fAllowToGetHelp /t REG_DWORD /d 1 /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 1 /f
	REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
	netsh advfirewall firewall set rule group="remote desktop" new enable=yes
	echo Please select "Allow connections only from computers running Remote Desktop with Network Level Authentication (more secure)"
	start SystemPropertiesRemote.exe /wait
	echo Enabled remote desktop
	pause
	goto:menu
 )
 
 if %remoteChk%==n (
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v AllowTSConnections /t REG_DWORD /d 0 /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fAllowToGetHelp /t REG_DWORD /d 0 /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f
	netsh advfirewall firewall set rule group="remote desktop" new enable=no
	echo Disabled remote desktop
	pause
	goto:menu
 )
echo invalid %remoteChk%
pause
goto remoteDesktop

:disablingServices
echo Disabling Services (Note: some of the services might be needed later on)
set servicesList= TapiSrv TlntSvr ftpsvc msftpsvc SNMP TermService SessionEnv UmRdpService SharedAccess remoteRegistry SSDPSRV W3SVC SNMPTRAP remoteAccess RpcSs HomeGroupProvider HomeGroupListener 
for %%i in (%servicesList%) do (
	echo disabled Service: %%i
	sc stop "%%i"
	sc config "%%i" start= disabled
)
echo check everything manually
start services.msc /wait
pause
goto :menu

:findUselessfiles
echo all informations will be sent to a file

goto :menu