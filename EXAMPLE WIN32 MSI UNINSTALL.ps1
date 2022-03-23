#############
#Uninstall für Script "SafeExamBrowserFix"
#############

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

If((test-path $RegistryInstallSoftwareValidationPath))
{
        #alte Keys komplett löschen
        Remove-Item -Path "$RegistryInstallSoftwareValidationPath" -Recurse
        #neu erstellen mit Uninstall Infos
        New-Item –Path "$RegistryInstallValidationPath" -Name $Paketname -Force -ItemType Directory
        New-ItemProperty -Path "$RegistryInstallSoftwareValidationPath" -Name "Deinstalliert am" -PropertyType "String" -Value "$Datum" -Force
        exit 0
}

#HEADER END

#START PROGRAM
#Deinstallation. Code muss ausgelesen werden. Nirsoft Uninstallview hilft hier
Start-Process -Wait msiexec "{2A2B7611-A26E-452F-9C7B-759BD8FEABA9}" -ArgumentList "/x /qn"
#END PROGRAM
