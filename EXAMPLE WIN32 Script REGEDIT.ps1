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
    $Paketname = "SafeExamBrowserFix"

    #InstallationsvalidierungsPfad. nicht anpassen
    $RegistryInstallValidationPath = "HKLM:\SOFTWARE\SchumirInstall"
    #InstallationsvalidierungsPfad
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

    #Variabeln Regkey
    $SafeExamRegKey = "HKLM:SOFTWARE\Classes\Installer\Products\79273B060352FE944AAD37056C4B36BD"


    #Löschung eines Registry Keys und Hinzufügen der Information in den Schumir Install
    If(!(test-path $SafeExamRegKey))
    {
            New-ItemProperty -Path "$RegistryInstallSoftwareValidationPath" -Name "Zusatzinformationen" -PropertyType "String" -Value "Keine aenderungen vorgenommen.Key nicht vorhanden" -Force
            #Programm beenden und "sucess" Rückmelden. Codes gemäss Einstellungen zu Beginn von W32 App Erstellunng
            exit 0
    }
    Else
    {
            Remove-Item -Path "$SafeExamRegKey" -Recurse
            New-ItemProperty -Path "$RegistryInstallSoftwareValidationPath" -Name "Zusatzinformationen" -PropertyType "String" -Value "Ausführung erfolgreich. Eintrag gelöscht" -Force
            #Programm beenden und "sucess" Rückmelden. Codes gemäss Einstellungen zu Beginn von W32 App Erstellunng
            exit 0 

    }

#END PROGRAM
