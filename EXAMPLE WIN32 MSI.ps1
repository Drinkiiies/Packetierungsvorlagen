###################################
#Name: 
#Installationsscript Software SafeExamBrowserFix
#Beschreibung:
#Wegen Bug mit SafeExamBrowser muss ein Registrykey gelöscht werden. Script prüft ob Regkey vorhanden und löscht diesen Anschliessend
#Scope:
#Alle Clients, minimalster Zeitimpact
#Typ:
#Win32 App ohne Abhängikeit
#Install:
#C:\Windows\Sysnative\WindowsPowerShell\v1.0\powershell.exe -noprofile -executionpolicy Bypass -file .\SafeExamBrowserFix.ps1
#Uninstall:
#C:\Windows\Sysnative\WindowsPowerShell\v1.0\powershell.exe -noprofile -executionpolicy Bypass -file .\Uninstall.ps1
#Versionen
#MK 10.12.2021:Script erstellt
#
####################################

#HEADER START

    #Globale Variabeln
    #Paketname für die Registry. ANPASSEN
    $Paketname = "MSISoftware"

    #InstallationsvalidierungsPfad. nicht anpassen
    $RegistryInstallValidationPath = "HKLM:\SOFTWARE\SchumirInstall"
    #Installationsvalidierungs Pfad
    $RegistryInstallSoftwareValidationPath = "HKLM:\SOFTWARE\SchumirInstall\$Paketname"
    #aktuelles Datum
    $Datum = Get-Date -UFormat "%d/%m/%Y %R %Z"


    ##Installationsvalidierung, wenn Pfad nicht existiert, wird bei Erstinallation dieser erstellt. 
    If(!(test-path $RegistryInstallSoftwareValidationPath))
    {
          #Registrykey erstellen
          New-Item –Path "$RegistryInstallValidationPath" -Name $Paketname -Force -ItemType Directory
          #Registrywerte abfüllen
          New-ItemProperty -Path "$RegistryInstallSoftwareValidationPath" -Name "Installiert" -PropertyType "String" -Value "1"
          New-ItemProperty -Path "$RegistryInstallSoftwareValidationPath" -Name "Installiert am" -PropertyType "String" -Value "$Datum"
          #Zusatzinformationen falls nötig
          #New-ItemProperty -Path "$RegistryInstallSoftwareValidationPath" -Name "Zusatzinformationen" -PropertyType "String" -Value ""

    }
    Else
    {
           #Falls der Pfad mit dem Uninstall bereits vorhanden war, kann es sich nur um eine Automatisiert reinstallation handeln.
           New-ItemProperty -Path "$RegistryInstallSoftwareValidationPath" -Name "Reinstalliert" -PropertyType "String" -Value "1"
           New-ItemProperty -Path "$RegistryInstallSoftwareValidationPath" -Name "Reinstalliert am" -PropertyType "String" -Value "$Datum"
           #Zusatzinformationen falls nötig
          #New-ItemProperty -Path "$RegistryInstallSoftwareValidationPath" -Name "Zusatzinformationen" -PropertyType "String" -Value ""
    }

#HEADER END

#START PROGRAM

#Wait ZWINGEND nötig. Alternativ pipe auf out-null
Start-Process -Wait msiexec "$($PSScriptRoot)\Software.msi" -ArgumentList "/i /qn"

#END PROGRAM
