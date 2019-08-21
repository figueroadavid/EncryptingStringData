function New-EncryptionKey {
    <#
    .SYNOPSIS
        Generates a new encryption key for use in the Convert(To|From)-EncryptedData functions
    .DESCRIPTION
        Takes a plaintext UTF8 input string and converts it to a Byte Array suitable for use in the ConvertTo- and ConvertFrom-
    .EXAMPLE
        PS C:\> (New-EncryptionKey -KeyString 'This is a long key' ) -join ','
        84,104,105,115,32,105,115,32,97,32,108,111,110,103,32,107,101,121,48,48,48,48,48,48,48,48,48,48,48,48,48,48
    .EXAMPLE
        PS C:> (New-EncryptionKey -KeyString 'This is a UTF8 key £') -join ','
        84,104,105,115,32,105,115,32,97,32,85,84,70,56,32,107,101,121,32,194,163,48,48,48,48,48,48,48,48,48,48,48,48
    .PARAMETER KeyString
        This is the string that is converted to an array of bytes to be used as the encryption key.  The string must be a minimum
        of 16 characters, and a maximum of 32 characters.  If the string is less than 32 characters, it is padded with zeroes (0)
        at the end to lengthen the key to a full 32 characters.
    .INPUTS
        [system.string]
    .OUTPUTS
        [system.array]
    .NOTES
        This is based on this article:
        http://get-powershell.com/post/2008/12/13/Encrypting-and-Decrypting-Strings-with-a-Key-in-PowerShell.aspx
        I converted it to use [System.Text.UTF8Encoding] instead of [System.Text.ASCIIEncoding] since the ASCII encoding can lose
        data if the string uses characters outside of the normal ASCII range.

        Also, be aware that higher decimal value UTF8 characters may be double-byte size, so a single character may be 2 bytes long.
        A perfect example is the English pound character (£) - the decimal value for the character is 931 (0x3a3)

    #>
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = 'The string to use as the base for the encryption key, it must be between 16 & 32 bytes inclusive')]
        [string]$KeyString
    )

    $Encoding = [System.Text.UTF8Encoding]::new()
    $KeyLength = $Encoding.GetByteCount($KeyString)

    if ($KeyLength -ge 16 -and $KeyLength -le 32) {
        Write-Verbose -Message 'The length of the KeyString is in the appropriate range'
    }
    elseif ($KeyLength -lt 16) {
        throw ('The length of the KeyString is too short by {0} bytes' -f (32 - $KeyLength).ToString() )
    }
    elseif ($KeyLength -gt 32) {
        Throw ('The length of the KeyString is too long by {0} bytes' -f ($KeyLength - 32).ToString() )
    }

    $Padding = 32 - $KeyLength
    $NewKeyString = '{0}{1}' -f $KeyString, ('0' * $Padding)

    $Encoding = [System.Text.UTF8Encoding]::new()
    $Encoding.GetBytes( $NewKeyString )
}
