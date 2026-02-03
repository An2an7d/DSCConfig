<# 
Reason for non-compliance
No related resources match the effect details in the policy definition. (Error code: NoComplianceReport)
#>

Configuration testMachineConfig {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        # Registries to Disable TLS 1.1
        Registry "DisableTLS 1.1_Server"
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
            ValueName = "DisabledByDefault"
            ValueData = "1"
            ValueType = "DWORD"
            Force = $true
        }

        Registry "DisableTLS 1.1_ServerDisabled"
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
            ValueName = "Enabled"
            ValueData = "0"
            ValueType = "DWORD"
            Force = $true
        }
    }

}
testMachineConfig