# PSUnless

A dumb module I created for some reason that adds an `unless` function to PowerShell, which feels like a keyword in practice.

Logically similar to the `if` keyword, but checks for a `$false` result instead of `$true`. Also supports chaining evaluations with `else`-style clauses.

# Installation
Currently you need to clone this repo and run `Import-Module` against `PSUnless.psm1` in order to import it.

Once imported, `unless` is available for use from the current PowerShell session.

`PSUnless` is intended to work with **Windows PowerShell** and **PowerShell Core**. 

# Basic Usage

Basically, use `unless` where you would use `if`, but for negative conditions instead. For example:

```powershell
$name = 'Mandark'

unless( $name -eq 'Susan' ) {
    'My name is not Susan'
}
```

It also supports chaining `else`-style clauses like `else`, `elseif`, and `elseunless`. More information on the `unless` function is located in [docs/Function-Unless.md](docs/Function-Unless.md).

You can also view the same information in PowerShell with `Get-Help unless`.

# Build Docs

To build the docs you need to make sure to install the [PlatyPS](https://github.com/PowerShell/platyPS) PowerShell module.

Edit the `.md` files directly with a text editor, but make sure to follow the [schema](https://github.com/PowerShell/platyPS/blob/master/platyPS.schema.md). The markdown has to be formatted in a  particular way.

To generate the MAML files, run the following command from the repo root:

```powershell
New-ExternalHelp -Path ./docs -OutputPath ./en-US -Force
```

This will generate [en-US/PSUnless-help.xml](en-US/PSUnless-help.xml). If the markdown in the source files violates the schema, `New-ExternalHelp` will throw a related error.

# Issues

Report any issues to the [issue tracker](https://github.com/codewario/PSUnless).