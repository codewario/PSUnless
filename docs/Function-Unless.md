---
external help file: PSUnless-help.xml
Module Name: PSUnless
online version:
schema: 2.0.0
---

# unless

## SYNOPSIS
A `function` to test for negative conditions. Designed to feel like a language keyword.

## SYNTAX

### Functional Syntax (default)
```
unless ( $conditional ) { RunIfFalseCondition }
    [ elseunless ( $conditional3 ) { RunIfFalseCondition } ] ...
    [ elseif ( $conditional2 ) { RunIfTrueCondition } ] ...
    [ else { RunIfNothingElseDid } ]
```

### Actual Signature
```powershell
unless [<CommonParameters>] [[-Arguments] <Array>]
```

## DESCRIPTION
PowerShell function to test for negative conditions. Runs the *RunIfFalseCondition* `[ScriptBlock]` if the condition is not satisfied. Supports standalone evaluations as well as chaining conditionals with `else`-style clauses. This `function` was designed to feel like a language keyword when using it.

See **Functional Syntax (default)** under the [Syntax](#syntax) section for proper usage syntax. Understanding the actual `function` signature is not useful in this regard, though this is included in the same section for informational purposes.

**Basic Usage**

Basically, use `unless` where you would use `if`, but for negative conditions instead. For example:

    $name = 'Mandark'

    unless( $name -eq 'Susan' ) {
        'My name is not Susan'
    }


Technically, the parentheses are not required for the condition, but they are needed when using any operators. Because of this, and the fact that PowerShell's built-in `if` statement already requires the use of parentheses in all cases, it is recommended to pass conditionals in as a group-expression out of idiomacy.

**A Note on `[ScriptBlock]` Placement**
Because this is not a true language keyword, if you prefer to start your code blocks on the following line of code you would need to escape the last character of the previous line with a backtick:

    $name = 'Mandark'

    unless( $name -eq 'Susan' ) ` # <======= Added a backtick before the newline
    {
        'My name is not Susan'
    }


Otherwise, the expression ends at the new line and PowerShell will error out. It's an unfortunate side-effect, but unavoidable outside of implementing as a proper keyword. If you have a problem with using backticks for multi-line statements, it is recommended to start your `[ScriptBlock]` on the same line of code as the previous condition, and end the block on the same line as a following `else`-style clause.

**Else Clauses**
`unless` supports the optional chaining of `else`-style clauses as well, such as when adding `else` or `elseif` clauses to an `if` statement. They are used by appending one of the `keywords` after a preceeding `[ScriptBlock]`. With the exception of `else` itself, all other `else`-style clauses may be specified multiple times. In general, the `elseif` and `elseunless` clauses will execute their `[ScriptBlock]` if their condition is satisfied, while the `else` clause will only execute its `[ScriptBlock]` if none of the preceeding blocks were run.

There are three supported `else`-style clauses:

- elseunless
  - *Usage:* `elseunless ( $conditional ) { RunIfFalseCondition }`
  - *Description:* Tests for a negative condition, and runs the proceeding *RunIfFalseCondition* `[ScriptBlock]` if the condition is satisfied. Made to function similarly to the built-in `elseif" clause.
  - *Rules:* If used, it must come immediately after a `[ScriptBlock]`, and provide a [ScriptBlock] of its own to run. 

- elseif
  - *Usage:* `elseif ( $conditional ) { RunIfTrueCondition }`
  - *Description:* Tests for an affirmative condition, and runs the proceeding *RunIfTrueCondition* `[ScriptBlock]` if the condition is satisfied. Made to function similarly to built-in `elseif` clauses. May be used multiple times when chaining clauses.
  - *Rules:* If used, it must come immediately after a `[ScriptBlock]`, and provide a `[ScriptBlock]` of its own to run.

- else
  - *Usage:* `else { RunIfNothingElseDid }`
  - *Description:* Runs the *RunIfNothingElseDid* `[ScriptBlock]` if all previous conditional clauses in the chain did not evaluate favorably. It may only be used once in a chain as the last item. Additional clauses after `else` will throw an error.
  - *Rules:* If used, it must come immediately after a `[ScriptBlock]`, and provide a `[ScriptBlock]` of its own to run.

**Chaining**

Below is an example of using "unless" with each available chained clause. This example tests for a negative $condition,
followed by additional conditions if each previous clause did not evaluate favorably.

    unless ( $condition ) {
        'Do this thing if $condition is $false'
    } elseif ( $condition2 ) {
        'Do this thing if $condition2 is $true'
    } elseunless ( $condition3 ) {
        'Do this thing if $condition3 is $false'
    } else {
        'Do this thing if none of the other conditional clauses ran'
    }

## EXAMPLES

### 1. Basic usage example

Output a string stating a name is not "Susan", unless the name is "Susan"

```powershell
$name = 'Mandark'

unless( $name -eq 'Susan' ) {
    'My name is not Susan'
}
```

### 2. Test for truthiness

Write a warning to the console unless msedge is running

```powershell
# "-EA 0" is shorthand for -ErrorAction SilentlyContinue
unless( Get-Process msedge -EA 0 ) {
  Write-Warning 'msedge is not currently running'
}
```

### 3. Else chaining

Example of chaining multiple conditions together with `else`-style clauses

```powershell
unless ( $condition ) {
    'Do this thing if $condition is $false'
} elseif ( $condition2 ) {
    'Do this thing if $condition2 is $true'
} elseunless ( $condition3 ) {
    'Do this thing if $condition3 is $false'
} else {
    'Do this thing if none of the other conditional clauses ran'
}
```

## PARAMETERS

### -Arguments
All arguments to be passed to `unless`. Essentially replaces the usage of `$args` within the `function` code itself.

The use of this parameter itself is not particularly useful, but understanding the arguments which are passed in is.  You should never need to specify `-Arguments` as a named parameter as this `function` is designed to take all inputs positionally.

Please read the [Description](#description) for full usage information, and read the [Inputs](#inputs) and [Outputs](#outputs) sections for a less verbose explanation of what goes in and gets returned from this `function`.

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

### CommonParameters
This `cmdlet` supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

This `function` was not designed to be a proper `cmdlet`, its status as one is a side-effect of a parameter attribute. But the availability of common parameters should not cause any problems. If anything, they *should* be a no-op most cases. If the use of common parameters causes problems, this should be reported to the [issue tracker](https://github.com/codewario/PSUnless/issues).

## INPUTS

### System.Array
The first two arguments are required in order:

**Position 1:** The `[bool]` condition to evaluate
**Position 2:** `[ScriptBlock]` to run if the preceeding condition returns `$false`

The next three arguments are optional and can be repeated in sequence, but all are required together in order for chaining `else`-logic unless otherwise noted:

**Position 3:** Chaining operator, must be one of `else`, `elseif`, or `elseunless`.
**Position 4:** A `[bool]` condition to evaluate, unless **Position 3** was `else` in which case skip to **Position 5**.
**Position 5:** `[ScriptBlock]` to run if the preceeding condition was favorably evaluated. If **Position 3** was `else`, this `[ScriptBlock]` must be the last argument.

3, 4, and 5 can be repeated as many times as you need to chain an additional `else`-style evaluation.

## OUTPUTS

### System.Object
This `function` does not output anything on its own, aside from emitting error information. However, since the caller must provide their own `[ScriptBlock]`, that code may return an `[object]` of some type.

## NOTES
Implementation Notes for the Curious

This function was inspired by languages such as `ruby` which have negation keywords in addition to `if` statements and negation operators. It was fun to write even if this would be better served as a language keyword.

This `function` does not implement idiomatic PowerShell parameter handling to preserve the "keyword" feel of its invocation. Negation of the initial condition is simple, but allowing chained `else` clauses made things more difficult, since those parameters may repeat. PowerShell does not support repeating parameters within `param()`, and prefers to steer developers toward array-based arguments instead. Normally this is a good design choice, but was incompatible with the experience I was seeking for this particular `function`. There may be a solution to be had in `DynamicParam`, but `DynamicParam` blocks are difficult to debug, and the end result when running `Get-Help` with some dynamic parameters left much to be desired.

`unless` was not intended to have `cmdlet` status, but there were some inconsistencies with using the `$args` array when compared to other collections. Defining the `-Arguments` parameter essentially removed any issues experienced, but as **ValueFromRemainingArguments** was needed to preserve the keyword feel during invocation, this bumps the `function` to **Advanced Function** status, a `cmdlet` in script form.

`elseif` feels a bit strange for an `unless` function if you aren't used to calling negative evaluators like this, but this was included since other languages which support a native `unless` statement do support chaining `elseif` clauses, just as their `if` statements support `elseunless` logic. Unfortunately, a module can't change the behavior of the `if` keyword, so you can't use the `elseunless` clause with a proper `if` statement.

## RELATED LINKS
