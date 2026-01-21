Configuration MiscConfig{
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Node Localhost {
    

    Script EnforceExecutionPolicyRemoteSigned
    {
        SetScript = {
        }
        GetScript = {@{}}
        TestScript = {
            Set-ExecutionPolicy RemoteSigned -Force
            return $true
            }
    }

    File ABCFolder
    {
        Ensure = "Present"
        Type = "Directory"
        DestinationPath = "C:\ABC"
    }

    File DummyFile
    {
        DependsOn = "[File]ABCFolder"
        Ensure = "Present"
        Type = "File"
        Contents = "This is a dummy file" 
        DestinationPath = "C:\ABC\dummy.txt"
    }

    Script ShutdownRestriction
    {
        GetScript = {
            @{ Result = "Restrict shutdown to administrators" }
        }

        TestScript = {
            secedit /export /cfg C:\Windows\Temp\check.cfg
            $content = Get-Content C:\Windows\Temp\check.cfg
            return [bool]($content -match '^SeShutdownPrivilege = \*S-1-5-32-544$')
        }

        SetScript = {
            secedit /export /cfg C:\Windows\Temp\check.cfg
            $content = Get-Content C:\Windows\Temp\check.cfg
            $content -replace 'SeShutdownPrivilege =.*', 'SeShutdownPrivilege = *S-1-5-32-544' |
                    Set-Content C:\Windows\Temp\secpol.cfg
                secedit /configure /db secedit.sdb /cfg C:\Windows\Temp\secpol.cfg /areas USER_RIGHTS
        }
    }
    
     Service EnsureTimeService
        {
            Name        = "w32time"
            State       = "Running"
            StartupType = "Automatic"
        }

    Script Remove7Zip
    {
        TestScript = {
            $exists = Get-ItemProperty `
              HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* `
              -ErrorAction SilentlyContinue |
              Where-Object { $_.DisplayName -like "*7-Zip*" }

            return -not $exists
        }

        SetScript = {
            Start-Process `
              "C:\Program Files\7-Zip\Uninstall.exe" `
              -ArgumentList "/S" `
              -Wait
        }

        GetScript = { @{ Result = "7-Zip removal" } }
    }

    Script DefenderExclusion
    {
        SetScript = {
            Add-MpPreference -ExclusionPath "C:\ABC"
        }

        TestScript = {
            (Get-MpPreference).ExclusionPath -contains "C:\ABC"
        }

        GetScript = {
            @{ Result = "Defender exclusion configured" }
        }
    }
}
}