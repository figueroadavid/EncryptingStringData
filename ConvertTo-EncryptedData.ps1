function ConvertTo-EncryptedData {
    <#
    .SYNOPSIS
        Converts a plain text string to an encrypted string suitable for storage using a key
    .DESCRIPTION
        The script takes a key in the form of a byte array (can be created using the New-EncryptionKey function),
        and a plain text string (UTF8 (or its children)), and creates a [SecureString], and then uses the
        ConvertFrom-SecureString to output the encrypted string
    .PARAMETER Key
        This is the byte array to be used as a key for the encryption.
    .PARAMETER KeyString
        This is the plain text encryption key.  If this parameter is used, then the New-EncryptionKey function is called
        to convert this into a byte array
    .PARAMETER PlainText
        This is the string data to be encrypted.
    .EXAMPLE
        PS C:\> $utf8key = 'This key contains UTF8 £'
        PS C:\> $EncryptionKey = New-EncryptionKey -KeyString $utf8key
        PS C:\> $UnEncryptedText = 'This is unencrypted text.  It also contains UTF8 characters like £ and ¢'
        PS C:\> $EncryptedText = ConvertTo-EncryptedData -key $EncryptionKey -PlainText $UnEncryptedText
        PS C:\> $EncryptedText
        76492d1116743f0423413b16050a5345MgB8AEUAKwBJADEAbQBHAGEAYgBrAC8AQwBLADYAMgBXAHYAUwAwADkAawB3AFEAPQA9AHwAOABlAGQAOQBkADgAZQA5AD
        EAZQA5ADMAYwBjAGUAMABhAGEAMQA4ADcAMQAxADEAYQBiADEAYwA3ADMAMABhADIANgA2ADUAZAA0ADQANAA3ADUAYwBjADkAMgAyADgAOQA0ADYAZAA3ADcAMgA0
        AGQANwBkAGMAZABkADEAYgAwADQANQBjAGYANgA1ADgAMQA4ADQANQBiAGYAMwBkAGMANQA1ADUAMwA5ADMAOABiAGQAZgA3AGQAZQA4ADEAYQAxAGUAOABlAGEAMA
        BiADUAYwBiADUAZgA5ADIAZQAyADgANwA3AGUAMwA2ADEAZgA3ADYAMAA2AGUAYwA2ADEANgA4ADUAYwAxAGEANwA5ADcAOQAzAGEAYwA1ADMAZQBlAGIAYwA4ADMA
        OQA4ADgAYQA4ADAAMwA1ADQAOABhAGUAZQBjAGUAMQBhADAAMQAxADcANwA5AGUAYwAyADAAMgBmAGUAYgBmADgAOABlAGIAZgBkADUAMgAzADIAZQA4ADkAMAA5AD
        IAZQA5AGUAYQAzADcAOABiADgAMgAxADMAYQA4ADAAOAA1AGEAMQA3ADIAYgAzADgAOAA2AGYANABjADYANAA5AGUANgBlADkAYQA4ADAAMAA3AGIAYgA0ADIANABm
        ADMANQAyADQAMgA4ADgAYgA5AGIAYgBkADkAMAAwAGEAOQA5AGIAMABhADkAYwBjAGEAMwBlAGEAOAA3ADQANAA2ADQAYwA2AGEAMwAwADUAMQBlADYAMQAyADIAOA
        AwAGIAYgBlAGQAZgAzAGUAYgAyAGIANgAxADIAMQA1ADIAYwBmAGIAYgAwAGIAMAA5ADgANwA4AA==
        PS C:\> $EncryptedText2 = ConvertTo-EncryptedData -KeyString $utf8key -PlainText $UnEncryptedText
        PS C:\> $EncryptedText2
        76492d1116743f0423413b16050a5345MgB8AHAAQwBrAFEASABVAFYAUgBHAGEASABGAHIAcQBnAHAASQBnAHgAUQBOAFEAPQA9AHwANgAxAGEANgBjADcANQA5AD
        kAOQBhADEAZAAwADAAMwAyADUAOAA1AGIANAA1AGQAMQBiAGYAMwA4ADYANwA5AGQAYwA0ADIAMQAwADcAYgA2AGMAYwA1AGIAMwAwAGQANABmAGQAZQAxAGMAZQAy
        ADMANwA5AGYAMgA2ADUAYQBmADEAMQAxADEAMAAxADAAYwAwADQANQA3ADcAYQAxADMAZgBiADUAMgBkAGQAYgBhADgANAA1ADkANAA1ADcAOQBjADEAOAAwAGEAYQ
        AyADEAZABjAGIAOQBjAGMANAA3ADkAMQBkAGUANQBiAGEAMwA1ADEAZABkADYAYgAzADAAOQAzADYAZQAwADEAOQA0ADQAMAA2ADQAYgBiAGQANAA3AGQAOQA2ADMA
        OABlADEAZgBkAGIAMAAzAGYANQA5ADgANABkADkAMQA1ADgANwA1AGYANQA0AGEAOABiADgAZQAzAGMAYwA1AGIAZgBmAGMAOQBhAGIAMgAzADMANgAyAGUANgAyAG
        EAZgA5ADQAYwAwAGEAOAAwAGEAMwBiAGUANABhADMAMgA2AGEAZABiAGYAYQA5AGUAYwA4AGYAYQAwAGUAYgA2AGIANgAyAGEAOAA5ADMANQBkAGEAOABiAGYAYQBj
        AGMAYQA2ADEAMwBmAGMANQAwAGIAMABkAGMAZQAwADYANAA3ADYAZQA3ADcAMQBkADMAMQBmADEAYgBjADgAMgBhAGMAYgBmADYAZgAyADAAMAA3ADIAMAAyAGIAMg
        AxADAAYwAyADQAZgBkADIAZgBmADkANgAwAGUANQBiADAANgAwADgAOAA4AGEAYwA5ADgAYwAzAA==
        PS C:\> ConvertFrom-EncryptedData -key $EncryptionKey -EncryptedData $EncryptedText
        This is unencrypted text.  It also contains UTF8 characters like £ and ¢
        PS C:\> ConvertFrom-EncryptedData -KeyString $utf8key -EncryptedData $EncryptedText
        This is unencrypted text.  It also contains UTF8 characters like £ and ¢
        PS C:\> ConvertFrom-EncryptedData -KeyString $utf8key -EncryptedData $EncryptedText2
        This is unencrypted text.  It also contains UTF8 characters like £ and ¢
        PS C:\> ConvertFrom-EncryptedData -key $EncryptionKey -EncryptedData $EncryptedText2
        This is unencrypted text.  It also contains UTF8 characters like £ and ¢
    .INPUTS
        [system.array] (bytes)
        [system.string]
    .OUTPUTS
        [system.string]
    .NOTES
        This is based on this article:
        http://get-powershell.com/post/2008/12/13/Encrypting-and-Decrypting-Strings-with-a-Key-in-PowerShell.aspx
    #>
    [cmdletbinding(DefaultParameterSetName = 'byKey')]
    param(
        [parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = 'The byte array for the input key to use in encrypting the data', ParameterSetName = 'byKey')]
        [array]$key,

        [parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = 'The plain text key to use for encrypting the string', ParameterSetName = 'byString')]
        [string]$KeyString,

        [parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = 'The string data to encrypt')]
        [string]$PlainText
    )

    if ($PSCmdlet.ParameterSetName -eq 'byString') {
        $key = New-EncryptionKey -KeyString $KeyString
    }

    $SecureString = [System.Security.SecureString]::new()
    $Chars = $PlainText.ToCharArray()

    foreach ($Char in $Chars) {
        $SecureString.AppendChar($Char)
    }

    $EncryptedData = ConvertFrom-SecureString -SecureString $SecureString -Key $key
    $EncryptedData
}
