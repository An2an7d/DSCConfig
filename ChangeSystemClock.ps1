Configuration ChangeSystemClock {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Registry "ShowSecondsInSystemClock"
        {
            Ensure = "Present"
            Key = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            ValueName = "ShowSecondsInSystemClock"
            ValueData = "1"
            ValueType = "DWORD"
            Force = $true
        }
    }
}
ChangeSystemClock