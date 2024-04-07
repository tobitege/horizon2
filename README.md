# Development

The sections below detail various steps and methods when developing for Horizon2, along with the general style guides and principles when developing Lua code for Dual Universe.

Please take some time to familiarize yourself with the guidelines before beginning development

## General Guidelines

When developing DU Lua code, please observe the following guidelines:

- [Lua Class Guide](Class-Guidelines)
- [Horizon Module Guide](HorizonModule-Guidelines)

If you are uncertain about the correct way to implement something, you should always consult a senior member of the research department.

## Development Environment

### Visual Studio Code

If you do not already have VSCode installed, you can [download it here](https://code.visualstudio.com/download). Once downloaded, install it and open the `Horizon2.code-workspace` with VSCode.

#### Setup

To be able to build Horizon2 correctly, you need to clone the Horizon-2 from the git (https://git.internal.st/dual-universe/horizon-2) this will save a copy on your local drive. Once you have done this, you need to clone the following libaries from the git into their respective directories within the Horizon-2 clone on your local drive.
- [DUBuild] (https://git.internal.st/dual-universe/dubuild) ../horizon-2/DUBuild
- [DUnit] (https://git.internal.st/dual-universe/dunit) ../horizon-2/DUnit
- [DataLib] (https://git.internal.st/dual-universe/datalib) ../horizon-2/Libs/Data
- [SlotDetector] (https://git.internal.st/dual-universe/slotdetector) ../horizon-2/Libs/SlotDetector
- [UtilityLibrary] (https://git.internal.st/dual-universe/utility-library) ../horizon-2/Libs/Utils

#### Extensions

In order to build on save, you need to install the [Trigger Task on Save](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.triggertaskonsave) extension.
If you want to have IntelliSense support you should install [Lua by sumneko](https://marketplace.visualstudio.com/items?itemName=sumneko.lua). Additional recommended extensions are [vscode-lua](https://marketplace.visualstudio.com/items?itemName=trixnz.vscode-lua), [Lua](https://marketplace.visualstudio.com/items?itemName=keyring.Lua), and [Lua Debug](https://marketplace.visualstudio.com/items?itemName=actboy168.lua-debug).

Once those are installed you can verify that the project builds correctly by opening, for example, `Main_StandardBuild.lua` and hitting `ctrl+s` or `ctrl+shift+b`. A window should appear at the bottom of the IDE with the build progress.

Once the build finishes, it will produce the following:

- JSON files for each of the main builds in the `./bin/` directory
- Your clipboard will contain the `StandardBuild` JSON
- The `testresults` directory will contain the test results, provided the test run succeeded.

#### Troubleshooting

Here you will find some common issues when first attempting to start Horizon2 development, and ways to remedy them.

> build.ps1 is not digitally signed. The script will not execute on the system.

If you get this error, run VSCode as Administrator and attempt to build. Subsequent runs without Administrator rights should not cause the error to reappear.

## Submitting Code

As a general rule, every changeset **must be on its own branch**. Generally, the branch would encompass one full feature or one [issue](https://git.internal.st/dual-universe/horizon-2/-/issues).

Once you are satisfied with your changes, you push the branch to `origin` and create a merge request. You can do so by opening [the repository](https://git.internal.st/) in a web browser. A notification should appear at the top prompting you to create a merge request for the branch you just pushed.

You **must** add at least two senior developers as Reviewers to your merge request. Do not merge it until it is approved by at least two senior members. Be it the ones assigned by reviewers or otherwise.

> ❗ Always add at least **two** senior developers to the Reviewers list

> ❗ Never push directly to the `master` or `development` branches

If you are unsure about how to do something - ask a senior developer for advice.

## DUBuild

### DUBuild Syntax

#### --@class

This attribute should be the first one applied in a file. It designates which class is contained within the file for DUBuild to properly assemble its dependency tree.

The `--@class` attribute should be followed by the class name.

Example usage:

```lua
--@class MyClass
function MyClass()
  --- ...
end
```

#### --@require

This attribute should be applied to classes that depend on other classes/utilities.

The `--@require` attribute should be followed by a _single_ class name. If you require multiple classes, you should include multiple `--@require` attributes.

Example usage:

```lua
--@class MyClass
--@require MyOtherClass
--@require YetAnotherClass

function MyClass()
  --- ...
end
```

#### --@keybind

### Configuring a build manifest

#### Creating a Main file

##### Adding modules

# Deployment
