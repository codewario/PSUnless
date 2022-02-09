@{
    ModuleVersion        = '0.1'
    CompatiblePSEditions = 'Core', 'Desktop'
    GUID                 = '2b12635f-ace1-4661-a282-1ca694ee2e88'
    Author               = 'codewario'
    Copyright            = '(c) codewario. All rights reserved.'
    Description          = 'A dumb module I created for some reason that adds an `unless` function to PowerShell, which feels like a keyword in practice.'
    PowerShellVersion    = '5.1'
    RootModule           = 'PSUnless'
    FunctionsToExport    = @('unless')
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    PrivateData          = @{
        PSData = @{
        }
    }
}
