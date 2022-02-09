# PSUnless

A dumb module I created for some reason that adds an `unless` function to PowerShell, which feels like a keyword in practice.

Logically similar to the `if` keyword, but checks for a `$false` result instead of `$true`. Also supports chaining evaluations with `else`-style clauses.

# Installation
Currently you need to clone this repo and run `Import-Module` against `PSUnless.psm1` in order to import it.

Once imported, `unless` is available for use from the current PowerShell session.

`PSUnless` is intended to work with **Windows PowerShell** and **PowerShell Core**. 

# Basic Usage

Basically, use `unless` where you would use `if`, but for negative conditions instead. For example:

    $name = 'Mandark'

    unless( $name -eq 'Susan' ) {
        'My name is not Susan'
    }

It also supports chaining `else`-style clauses like `else`, `elseif`, and `elseunless`. More information on the `unless` function is located in [docs/Function-Unless.md](docs/Function-Unless.md).

You can also view the same information in PowerShell with `Get-Help unless`.