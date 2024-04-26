# Horizon2

**Horizon2** is a LUA flight script for the game *Dual Universe* by Novaquark.  
Originally developed by the ingame organisation '*Shadow Templars*', the authors left the game but kindly
released the sources to the public in spring of 2024.

New maintainers on these repositories are working on updating the codebase to become compatible with the latest game version's LUA API.

> ❗ Horizon 2 is **NOT** a finished product, it was provided "as-is". It is **NOT** an elevator script!

## Development

### Updates

#### 2024-02-26 by @tobitege

* Codebase revised to fix deprecated DU API calls.
* Updated this README.md file.
* Updated links in .gitmodules file and referenced repositories.
* Renamed the original .gitlab file to .txt to avoid confusion.
* Added an interim "build_tobitege.bat" to run a build on the 2 main lua files (adapt paths to your env!).
* Added the "output" folder to the repository, which contains normal and minimized json files as of today.
* Status: script starts up without LUA errors, only basic HUD visible, mouse control active by default.
* Todo: need to identify what other HUD parts are not shown yet and make them visible.

## Introduction

The sections below detail various steps and methods when developing for Horizon2, along with the general style guides and principles when developing Lua code for Dual Universe.

Please take some time to familiarize yourself with the guidelines before beginning development.

Please visit the *Horizon Support* Discord server (original authors left Dual Universe, but maintainers may try to help): https://discord.gg/E2UEQhkzty

## General Guidelines

When developing DU Lua code, please observe the following guidelines:

- [Lua Class Guide](Class-Guidelines)
- [Horizon Module Guide](HorizonModule-Guidelines)

If you are uncertain about the correct way to implement something, you should always consult a senior member of the research department.

## Development Environment

### Visual Studio Code

If you do not already have VSCode installed, you can [download it here](https://code.visualstudio.com/download).  
Once downloaded, install it and either open the folder (or if it exists the `Horizon2.code-workspace` workspace file) with VSCode.

### Setup

To be able to build Horizon2 correctly, you need to clone the Horizon2 repository from the [Horizon2 repository](https://github.com/Otixa/horizon2/) with below command in a terminal window:  
`git clone --recursive https://github.com/Otixa/horizon2/`

This will clone the main repository along with all its sub-repositories.

If you have already cloned the main repository without the sub-repositories, you can fetch them later using the following commands (adapt the "cd" command accordingly):

`cd horizon2
git submodule init
git submodule update --recursive`

The git submodule init command initializes the sub-repository configuration, and the git submodule update --recursive command fetches and checks out the sub-repositories, that will show up in the "Libs" subfolder:

* [DataLib](https://github.com/Otixa/du-data-lib) ../horizon2/Libs/Data  
* [SlotDetector](https://github.com/Otixa/du-slot-detector) ../horizon2/Libs/SlotDetector  
* [UtilityLibrary](https://github.com/Otixa/du-utils) ../horizon2/Libs/Utils  

There are 2 special repositories, that need to be cloned separately:

* [DUBuild](https://github.com/Otixa/dubuild) ../horizon2/DUBuild  
This is the main tool to "package" all LUA sources into DU's json format.  
It will be called with parameters like source folder, main lua file and output folder.  
For an example see the "build_tobitege.bat" file in the root of this repository.

* [DUnit](https://github.com/Otixa/dunit) ../horizon2/DUnit
This is the main unit testing framework for Horizon2.  
It is used to run the tests defined in the "Tests" subfolder, but not required right
now in the master branch (see branch development!).

### Extensions

* In order to build on save, you need to install the [Trigger Task on Save](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.triggertaskonsave) extension.  
* If you want to have IntelliSense support you should install [Lua by sumneko](https://marketplace.visualstudio.com/items?itemName=sumneko.lua).  
* Additional recommended extensions are [vscode-lua](https://marketplace.visualstudio.com/items?itemName=trixnz.vscode-lua), [Lua](https://marketplace.visualstudio.com/items?itemName=keyring.Lua), and [Lua Debug](https://marketplace.visualstudio.com/items?itemName=actboy168.lua-debug).

Once those are installed you can verify that the project builds correctly by opening, for example, `Main_StandardBuild.lua` and hitting `ctrl+s` or `ctrl+shift+b`. A terminal window should appear at the bottom of the IDE with the build progress.
The dubuild repository may have in folder DUBuild\Properties a launchSettings.json as an example.

Once the build finishes, it should have produced the following:

* One or more JSON files for each of the main builds in the `./output/` directory
Optionally:
* Your clipboard should (will?) contain the `Standard` JSON (as specified in the Main_\*.lua file)
* The `testresults` directory will contain the test results, provided the tests ran successfully.

#### Troubleshooting

Here you will find some common issues when first attempting to start Horizon2 development, and ways to remedy them.  

* Depending on the branch, there might be a PowerShell file to start a build process like "build.ps1" (see development branch).

  > build.ps1 is not digitally signed. The script will not execute on the system.

  If you get this error, run VSCode as Administrator and attempt to build again. Subsequent runs without Administrator rights should not cause the error to reappear.

## Submitting Code

As a general rule, every changeset **must be on its own branch**. Generally, the branch would encompass one full feature or one [issue](https://github.com/Otixa/horizon2/issues).

Once you are satisfied with your changes, you push the branch to `origin` and create a merge request. You can do so by opening [the repository](https://github.com/Otixa/horizon2) in a web browser. A notification should appear at the top prompting you to create a merge request for the branch you just pushed.

> ❗ Never push directly to the `master` or `development` branches

If you are unsure about how to do something - ask an AI or a senior developer for advice.

## DUBuild System

This system requires to implement a structural template with a fixed name and following below rules, so that the "dubuild" application can work on it.
Please find and explore the examples in the [dubuild](https://github.com/Otixa/dubuild) repository!

### DUBuild Syntax

#### --@class

This attribute should be the first one applied in a file. It designates which *logical* class is contained within the file for DUBuild to properly assemble its dependency tree.  
It does not need to be an actual LUA class object, though, and can just include methods. The attribute "marks" this file like a bookmark so it can be referenced during the build process.

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

### Deployment

Copy the contents of a resulting JSON file to clipboard and in game paste it onto a remote controller or piloting element via right-mouse menu.
