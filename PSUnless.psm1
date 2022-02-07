using namespace System
using namespace System.Text

New-Variable -Option ReadOnly -Name CURRENT_TOKEN_NEXT_TYPE -Value (
    [PSCustomObject]@{
        Boolean     = 'ScriptBlock'
        ScriptBlock = 'String'
        String      = 'Boolean'
    }
)

Function Assert-UnlessArguments {
    Param(
        [array]$Arguments
    )

    # Args count must be at least 2
    if ( $Arguments.Count -lt 2 ) {
        throw [ArgumentOutOfRangeException]::new(
            $null,
            $Arguments.Count,
            'The number of required arguments to ''unless'' is 2.'
        )
    }
    Remove-Variable isOdd -EA SilentlyContinue

    # Check each argument. By position (not index):
    #   1st     - Must be a [bool].
    #   2nd     - Must be a [scriptblock].
    #   3rd     - Optional "keyword". Must be a [string] of 'else', 'elseif', or 'elseunless'.
    #   4th     - If 3rd is 'else', must be a [scriptblock] and the final argument.
    #             Otherwise, this must be a [bool] condition.
    #   5th     - If 3rd is 'elseif', or 'elseunless', this must be a [scriptblock].
    #
    #   Repeat 3rd through 5th when dealing with chained conditionals

    $pos = 0
    $expectedTokenType = 'Boolean'
    $tokenType = 'Boolean'
    $foundElse = $false
    $noMoreArgs = $false

    # Use a real loop instead of a switch iteration to track the argument position
    foreach ( $arg in $Arguments ) {
        $pos++

        if ( $pos -gt 1 ) {

            switch ( $arg ) {

                # ASSERT: Cannot provide more arguments after the 'else' [scriptblock]
                { $noMoreArgs } {
                    throw [ArgumentException]::new('Not expecting further arguments, but found ''$arg''.')
                }

                # SKIP: We don't need to validate the boolean tokens
                { $expectedTokenType -eq 'Boolean' } {
                    $tokenType = 'Boolean'
                    break
                }

                # ASSERT: Arg must be non-null for non-boolean types
                { $null -eq $arg -and $expectedTokenType -ne 'Boolean' } {
                    throw [ArgumentNullException]::new(
                        $null,
                        "Expected '$expectedTokenType' at position $pos, but found $$null instead."
                    )
                }

                # SETUP: Get the arg type for non-null arguments
                $arg {
                    $tokenType = $arg.GetType().Name
                }

                # ASSERT: Token type must be what we are expecting
                { $tokenType -ne $expectedTokenType } {
                    throw [ArgumentException]::new("Expected '$expectedTokenType' at position $pos, but found '$tokenType' instead.")
                }

                # ASSERT: Allowed keyword values
                { $tokenType -eq 'String' -and $arg -notin 'else', 'elseif', 'elseunless' } {
                    throw [ArgumentException]::new("Expected 'else', 'elseif', or 'elseunless' in position $pos, but found '$arg' instead.")
                }

                # SETUP: Check for 'else' keyword
                { $tokenType -eq 'String' -and $arg -eq 'else' } {
                    $foundElse = $true
                    break
                }

                # SETUP: Set no more expected arguments after the final [scriptblock]
                { $foundElse -and $tokenType -eq 'ScriptBlock' } {
                    $noMoreArgs = $true
                }
            }
        }

        # Set the next expected token type
        $expectedTokenType = $CURRENT_TOKEN_NEXT_TYPE.$tokenType
    }

    # Check the final token type to make sure we did finish on a [scriptblock]
    if ( $tokenType -ne 'ScriptBlock' ) {
        throw [ArgumentException]::new("Expected the final argument to be a [scriptblock], but found [$tokenType] instead")
    }
}

Function unless {
    Param(
        [Parameter(ValueFromRemainingArguments)]
        [array]$Arguments
    )
    
    # Check the parameters and make sure the syntax is correct before actually evaluating anything
    Assert-UnlessArguments $Arguments

    # Generate a string to run the evaluation
    $sb = [StringBuilder]::new($Arguments.Count)

    # Start with first two since they are guaranteed (invoking this function would be the "keyword")
    $condition, $block, $remaining = $Arguments
    [void]$sb.AppendLine("if( !`$$condition ) {
        $block
    }")

    # Iterate over the rest
    $condition, $block = $null
    $keyword, $remaining = $remaining
    $newline = [string]::Empty

    while ( $keyword ) {

        # Determine the next tokens
        switch ( $keyword ) {
            
            'else' {

                # There is no condition for 'else'
                $condition = $null
                $block, $remaining = $remaining

                $newline = "else {
                    $block
                }"
                break
            }

            'elseif' {

                $condition, $block, $remaining = $remaining

                $newline = "elseif( `$$condition ) {
                    $block
                }"
                break
            }

            'elseunless' {

                $condition, $block, $remaining = $remaining

                $newline = "elseif( !`$$condition ) {
                    $block
                }"
                break
            }
        }

        # Generate this line of code
        [void]$sb.AppendLine($newline)

        # Set up the next iteration
        $keyword, $remaining = $remaining
    }

    # Create the [scriptblock] and run it
    $scriptBlock = [ScriptBlock]::Create($sb)
    & $scriptBlock
}