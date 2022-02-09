---
external help file: PSUnless-help.xml
Module Name: PSUnless
online version:
schema: 2.0.0
---

# Assert-UnlessArguments

## SYNOPSIS
Assert that "unless" arguments have been provided correctly. Not intended for use outside this module.

## SYNTAX

```
Assert-UnlessArguments [[-Arguments] <Array>]
```

## DESCRIPTION
Confirms that the arguments passed in match the syntax passed into "unless". Parsing rules below (by position):

1st     - Must be a \[bool\] or evaluate to one.

2nd     - Must be a \[scriptblock\].

3rd     - Optional "keyword". Must be a \[string\] of 'else', 'elseif', or 'elseunless'.

4th     - If 3rd is 'else', must be a \[scriptblock\] and the final argument. Otherwise, this must be a \[bool\] condition.

5th     - If 3rd is 'elseif', or 'elseunless', this must be a \[scriptblock\].\

Repeat 3-5 when dealing with chained conditionals

This is not necessarily how the logic needs to work for the parser, but the above is expected to be the end result. For example, this doesn't need to validate bools, because any value can be represented as a bool, even $null. Since this could be any data type anything passed in should be considered valid, so no check is performed. If it is due to a malformed command, one of the subsequent checks should raise an error.

## EXAMPLES

### Example 1
```powershell
PS C:\> Assert-UnlessArguments $args
```

## PARAMETERS

### -Arguments

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
