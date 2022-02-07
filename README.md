# PSUnless

A dumb module I created for some reason that adds an `unless` function to PowerShell, which feels like a keyword in practice.

Logically similar to the `if` keyword, but checks for a `$false` result instead of `$true`. Also supports chaining evaluations with `else`-style clauses.

# Installation
Currently you need to clone this repo and run `Import-Module` against `PSUnless.psm1` in order to import it.

Once imported, `unless` is available for use from the current PowerShell session.

`PSUnless` is intended to work with **Windows PowerShell** and **PowerShell Core**. 

# Basic Usage

Use `unless` like how you would use `if`, but for negative conditions instead. Its basic usage is as follows:

- **unless**
  - *Usage:* `unless ( $conditional ) { RunIfFalseCondition }`
  - *Description:* PowerShell `function` to test for negative conditions. Runs the `RunIfFalseCondition` `[ScriptBlock]` if the condition is *not* satisfied. Supports standalone evaluations as well as chaining conditionals with `else`-style clauses.
  - *Example:*

    ```powershell
    $name = 'Mandark'

    unless( $name -eq 'Susan' ) {
        'My name is not Susan'
    }
    ```


Technically, the parentheses are optional when evaluating truthiness of a single variable, but the use of the **group-expression operator** `()` is needed when using any logical operators. Because of this, and the fact that PowerShell's built-in `if` statement already requires the use of parentheses, it is recommended to pass conditionals in as a **group-expression**.

## Else Clauses
`unless` supports the optional chaining of `else`-style clauses as well, such as when adding `else` or `elseif` clauses to an `if` statement. They are used by appending one of the "keywords" after a preceeding `[ScriptBlock]`. With the exception of `else` itself, all other `else`-style clauses may be specified multiple times. In general, the `elseif` and `elseunless` clauses will execute their `[Scriptblock]` if their condition is satisfied, while the `else` clause will only execute its `[ScriptBlock]`

There are three supported `else`-style clauses:

- **elseunless**
  - *Usage:* `elseunless ( $conditional ) { RunIfFalseCondition }`
  - *Description:* Tests for a **negative** condition, and runs the proceeding `RunIfFalseCondition` `[ScriptBlock]` if the condition is satisfied. Made to function similarly to the built-in `elseif` clause.
  - *Rules:* If used, it must come immediately after a `[ScriptBlock]`, and provide a `[ScriptBlock]` of its own to run. 

- **elseif**
  - *Usage:* `elseif ( $conditional ) { RunIfTrueCondition }`
  - *Description:* Tests for an **affirmative** condition, and runs the proceeding `RunIfTrueCondition` `[ScriptBlock]` if the condition is satisfied. Made to function similarly to built-in `elseif` clauses. May be used multiple times when chaining clauses.
  - *Rules:* If used, it must come immediately after a `[ScriptBlock]`, and provide a `[ScriptBlock]` of its own to run.

- **else**
  - *Usage:* `else { RunIfNothingElseDid }`
  - *Description:* Runs the `RunIfNothingElseDid` `[ScriptBlock]` if all previous conditional clauses in the chain did not evaluate favorably. It may only be used once in a chain as the last item. Additional clauses after `else` will throw an error.
  - *Rules:* If used, it must come immediately after a `[ScriptBlock]`, and provide a `[ScriptBlock]` of its own to run.

# Chaining Examples

Below is an example of using `unless` with each available chained clause. This example tests for a negative `$condition`, followed by additional conditions if each previous clause did not evaluate favorably.

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