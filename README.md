# EncryptingStringData
Functions to create encrypted data out of secure strings and reverse the process

## Functions
This will eventually be converted to a module, but for now, there are 3 functions involved:
1. New-EncryptionKey
2. ConvertTo-EncryptedData
3. ConvertFrom-EncryptedData

### New-EncryptionKey
This function takes a string and generates a series of bytes to serve as an encryption key.  The kwy string needs to be between 16 & 32 bytes.  If it is less than 32 characters, it is padded with zeroes (0) at the end to make it 32 bytes.  The function is based on UTF8, so values outside of the ASCII range may use 2 bytes, and the function accounts for this.

### ConvertTo-EncryptedData
This function takes the key generated by New-EncryptionKey (or any 16, 24, or 32 byte key) and the string data to be encrypted, it converts it a secure string and outputs the encrypted data in a plaintext format. If the user has not created a key with New-EncryptionKey, a string can be supplied and the New-EncryptionKey function will be called to create the key

### ConvertFrom-EncryptedData
This function takes the encrypted data, and the key from above and decrypts it, returning the original unencrypted text.  Just like the ConvertTo-EncryptedData function, if the user does not have the original key, the string used to create the key can be supplied instead, and the New-EncryptionKey will be called and the key generated.

## Example:
(The word wrapping is artificial here, the function produces single string output)
```powershell
PS C:\>$utf8key = 'This key contains UTF8 £'

    PS C:\> $EncryptionKey = New-EncryptionKey -KeyString $utf8key
    PS C:\> $UnEncryptedText = 'This is unencrypted text.  It also contains UTF8 characters like £ and ¢'
    PS C:\> $EncryptedText = ConvertTo-EncryptedData -key $EncryptionKey -PlainText $UnEncryptedText
    PS C:\> $EncryptedText
    76492d1116743f0423413b16050a5345MgB8AEUAKwBJADEAbQBHAGEAYgBrAC8AQwBLADYAMgBXAHYAUwAwADkAawB3AFEAPQA9AHwAOAB
    lAGQAOQBkADgAZQA5ADEAZQA5ADMAYwBjAGUAMABhAGEAMQA4ADcAMQAxADEAYQBiADEAYwA3ADMAMABhADIANgA2ADUAZAA0ADQANAA3AD
    UAYwBjADkAMgAyADgAOQA0ADYAZAA3ADcAMgA0AGQANwBkAGMAZABkADEAYgAwADQANQBjAGYANgA1ADgAMQA4ADQANQBiAGYAMwBkAGMAN
    QA1ADUAMwA5ADMAOABiAGQAZgA3AGQAZQA4ADEAYQAxAGUAOABlAGEAMABiADUAYwBiADUAZgA5ADIAZQAyADgANwA3AGUAMwA2ADEAZgA3
    ADYAMAA2AGUAYwA2ADEANgA4ADUAYwAxAGEANwA5ADcAOQAzAGEAYwA1ADMAZQBlAGIAYwA4ADMAOQA4ADgAYQA4ADAAMwA1ADQAOABhAGU
    AZQBjAGUAMQBhADAAMQAxADcANwA5AGUAYwAyADAAMgBmAGUAYgBmADgAOABlAGIAZgBkADUAMgAzADIAZQA4ADkAMAA5ADIAZQA5AGUAYQ
    AzADcAOABiADgAMgAxADMAYQA4ADAAOAA1AGEAMQA3ADIAYgAzADgAOAA2AGYANABjADYANAA5AGUANgBlADkAYQA4ADAAMAA3AGIAYgA0A
    DIANABmADMANQAyADQAMgA4ADgAYgA5AGIAYgBkADkAMAAwAGEAOQA5AGIAMABhADkAYwBjAGEAMwBlAGEAOAA3ADQANAA2ADQAYwA2AGEA
    MwAwADUAMQBlADYAMQAyADIAOAAwAGIAYgBlAGQAZgAzAGUAYgAyAGIANgAxADIAMQA1ADIAYwBmAGIAYgAwAGIAMAA5ADgANwA4AA==
    PS C:\> $EncryptedText2 = ConvertTo-EncryptedData -KeyString $utf8key -PlainText $UnEncryptedText
    PS C:\> $EncryptedText2
    76492d1116743f0423413b16050a5345MgB8AHAAQwBrAFEASABVAFYAUgBHAGEASABGAHIAcQBnAHAASQBnAHgAUQBOAFEAPQA9AHwANgA
    xAGEANgBjADcANQA5ADkAOQBhADEAZAAwADAAMwAyADUAOAA1AGIANAA1AGQAMQBiAGYAMwA4ADYANwA5AGQAYwA0ADIAMQAwADcAYgA2AG
    MAYwA1AGIAMwAwAGQANABmAGQAZQAxAGMAZQAyADMANwA5AGYAMgA2ADUAYQBmADEAMQAxADEAMAAxADAAYwAwADQANQA3ADcAYQAxADMAZ
    gBiADUAMgBkAGQAYgBhADgANAA1ADkANAA1ADcAOQBjADEAOAAwAGEAYQAyADEAZABjAGIAOQBjAGMANAA3ADkAMQBkAGUANQBiAGEAMwA1
    ADEAZABkADYAYgAzADAAOQAzADYAZQAwADEAOQA0ADQAMAA2ADQAYgBiAGQANAA3AGQAOQA2ADMAOABlADEAZgBkAGIAMAAzAGYANQA5ADg
    ANABkADkAMQA1ADgANwA1AGYANQA0AGEAOABiADgAZQAzAGMAYwA1AGIAZgBmAGMAOQBhAGIAMgAzADMANgAyAGUANgAyAGEAZgA5ADQAYw
    AwAGEAOAAwAGEAMwBiAGUANABhADMAMgA2AGEAZABiAGYAYQA5AGUAYwA4AGYAYQAwAGUAYgA2AGIANgAyAGEAOAA5ADMANQBkAGEAOABiA
    GYAYQBjAGMAYQA2ADEAMwBmAGMANQAwAGIAMABkAGMAZQAwADYANAA3ADYAZQA3ADcAMQBkADMAMQBmADEAYgBjADgAMgBhAGMAYgBmADYA
    ZgAyADAAMAA3ADIAMAAyAGIAMgAxADAAYwAyADQAZgBkADIAZgBmADkANgAwAGUANQBiADAANgAwADgAOAA4AGEAYwA5ADgAYwAzAA==
    PS C:\> ConvertFrom-EncryptedData -key $EncryptionKey -EncryptedData $EncryptedText
    This is unencrypted text.  It also contains UTF8 characters like £ and ¢
    PS C:\> ConvertFrom-EncryptedData -KeyString $utf8key -EncryptedData $EncryptedText
    This is unencrypted text.  It also contains UTF8 characters like £ and ¢
    PS C:\> ConvertFrom-EncryptedData -KeyString $utf8key -EncryptedData $EncryptedText2
    This is unencrypted text.  It also contains UTF8 characters like £ and ¢
    PS C:\> ConvertFrom-EncryptedData -key $EncryptionKey -EncryptedData $EncryptedText2
    This is unencrypted text.  It also contains UTF8 characters like £ and ¢
    ```
