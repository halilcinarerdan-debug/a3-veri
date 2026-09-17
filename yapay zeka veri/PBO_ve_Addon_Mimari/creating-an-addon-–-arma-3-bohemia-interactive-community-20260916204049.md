# Creating an Addon – Arma 3 - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

Categories: [Category:Stubs](https://community.bistudio.com/wiki/Category:Stubs)[Category:Arma 3: Tutorials](https://community.bistudio.com/wiki/Category:Arma_3:_Tutorials)

This page explains the steps required to create an addon ([PBO File Format](https://community.bistudio.com/wiki/PBO_File_Format) file).

## Prerequisites[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Prerequisites)

- An addon making tool such as:
- [Category:Arma 3: Official Tools](https://community.bistudio.com/wiki/Category:Arma_3:_Official_Tools)
- [Mikero's Tools](https://mikero.bytex.digital/)
- [HEMTT](https://hemtt.dev/) ([GitHub](https://github.com/BrettMayson/HEMTT))
- A text editor, such as Notepad++ or Visual Studio Code.

## Preparing the Addon[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Preparing_the_Addon)

Place all required files (scripts, textures, fonts, models, etc.) in an empty folder, which hereafter will be referred to as the **Addon folder**.
 It is recommended to organise the files into subfolders to avoid clutter.

In order to make this addon fully functional, at least two additional steps are required, which are explained in further detail in the subsequent sections:

- A file named [config.cpp](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Config.cpp) should be created in the root of the Addon Folder for the game to be able to recognise the addon contents.
- Paths to all files in the addon, such as script paths, model paths, etc. should be adjusted with respect to the [Addon Prefix](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Addon_Prefix).

## Addon Prefix[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Addon_Prefix)

In simple terms, Addon Prefix is a virtual (in-game) path to the root folder of an addon. The game uses the addon prefix to find the files in the addon. This virtual path should preferably be unique to prevent collision with other addon files. The addon prefix is added to the [PBO File Format](https://community.bistudio.com/wiki/PBO_File_Format#Arma_PBO) by the packing tool.

The addon prefix is typically a single word:

```
Addon_Name
```

It is also possible to use a directory-like prefix (where each pseudo-directory is separated by \). This prefix format is typically used by mods that contain several addons:

```
Mod_Name\Addon_Name\Category\...
```

For example:

```
My_Faction_Mod\Faction_Name\Vehicles
```

It is also possible to use the same Addon Prefix in multiple addons (for example, to split an addon into smaller ones) However, note that their class names in [CfgPatches](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Config.cpp) must be different.

Once the addon prefix is set, the path to addon files will be as follows:

```
Addon_Prefix\Folder\File.format
```

For example, assume a file called **car.p3d** exists in the Addon Folder as follows:

```
Addon_Folder	// Addon folder
|__models		// A folder in Addon Folder called "models"
   |__car.p3d	// A p3d (3D model) file
```

Let's assume we've set the addon prefix to "My_Awesome_Car_Mod". In **config.cpp**, the model path should be:

```
model = "My_Awesome_Car_Mod\models\car.p3d";
```

In other words, instead of using Addon_Folder, every path should now start from the Addon Prefix.

⚠

The addon prefix can only contain **English letters**, **numbers**, **underscore (_)** and backslash (\). Note that **spaces are not allowed**!

### Setting the Addon prefix[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Setting_the_Addon_prefix)

There are several ways to set the addon prefix, depending on the packing tool used. The instructions for two commonly used tools, namely [Addon Builder](https://community.bistudio.com/wiki/Addon_Builder), Mikero's Tools, and HEMTT, are explained.

#### Using Addon Builder[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Using_Addon_Builder)

To set the addon prefix using [Addon Builder](https://community.bistudio.com/wiki/Addon_Builder), simply navigate to "Options" and modify the "Addon prefix" edit box.

#### Using Mikero's pboProject[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Using_Mikero's_pboProject)

To set the addon prefix using Mikero's pboProject, create a text file called $PBOPREFIX$.txt in the root of the addon folder, and type the addon prefix in the file.

#### Using HEMTT[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Using_HEMTT)

To set the addon prefix using HEMTT, create a text file called $PBOPREFIX$ in the root of the addon folder, and type the addon prefix in the file. For more information on using HEMTT, see the ["HEMTT Book"](https://hemtt.dev/).

## Config.cpp[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Config.cpp)

When the game loads an addon, it looks for a file called **config.cpp** to determine how to process the addon contents. Without this file, the addon will be ignored by the game. In other words, **config.cpp** is the hub through which **all of the addon contents** (such as vehicles, weapons, sounds, functions, etc.) will be processed and applied to the game.

This file should be created in the root of the Addon Folder. It is also possible to place additional **config.cpp** files in the subfolders of the addon, in which case the subfolders will be treated as separate addons by the game.

At the bare minimum, the **config.cpp** file requires a [CfgPatches](https://community.bistudio.com/wiki/CfgPatches) class. This will allow the game to determine what external addons are required by this addon, what objects/weapons are being added, as well as miscellaneous information about the addon such as the author, version, etc.

All added/patched classes should be added to this file in order to be recognised and configured by the game.

### Config Modifications[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Config_Modifications)

To add new content or modify existing ones, you typically need to create a sub-class into designated classes for that type of content.

For example, to add a new vehicle or modify an existing one, a new sub-class is created under CfgVehicles:

```cpp
// CfgVehicles is a special class that contains all object classes that are meant for AI/player interaction, such as Vehicles, Buildings, etc.
class CfgVehicles
{
	// Forward-declaration of class Car
	// This tells the game that this class is an existing class in CfgVehicles and we're just importing it to use it in our own config
	class Car;

	// Inherit the class Car
	// Note that if MyNewVehicle already exists, instead of creating a new one, we just end up modifying (i.e. patching) it
	class MyNewVehicle : Car
	{
		// All properties of MyNewVehicle will be identical to Car, except for the model property which we just modified
		model = "...";
	};
};
```

The above config is just an example for demonstration purposes. For more details on how to create vehicles, weapons, etc. please refer to the existing documentations and the [Arma 3: Asset Samples](https://community.bistudio.com/wiki/Arma_3:_Asset_Samples) (available on Steam).

ⓘ

Visit [Class Inheritance](https://community.bistudio.com/wiki/Class_Inheritance) to learn more about config classes.

All added/modified config classes, such as [CfgVehicles](https://community.bistudio.com/wiki/CfgVehicles) (objects, backpacks), [CfgWeapons](https://community.bistudio.com/wiki/CfgWeapons) (weapons, weapon attachments, uniforms, vests, etc.), [CfgMagazines (page does not exist)](https://community.bistudio.com/wiki?title=CfgMagazines&action=edit&redlink=1) (magazines, grenades, mines, etc.), [CfgAmmo](https://community.bistudio.com/wiki/CfgAmmo) (projectiles, submunition, etc.), [CfgFunctions](https://community.bistudio.com/wiki/CfgFunctions) (registered scripts), [CfgCloudlets (page does not exist)](https://community.bistudio.com/wiki?title=CfgCloudlets&action=edit&redlink=1) (particles), [GUI Tutorial](https://community.bistudio.com/wiki/GUI_Tutorial), etc. need to be added to this file.
 If the config.cpp file gets too big (which happens a lot with large mods), it is recommended to split it into separate files (e.g. CfgFunctions.hpp for CfgFunctions, etc.), and [PreProcessor Commands](https://community.bistudio.com/wiki/PreProcessor_Commands#.23include) them in the **config.cpp** file:

```cpp
// All addons must have this class
class CfgPatches
{
	// ...
};
// These files are sitting next to config.cpp in the current folder
#include "cfgFunctions.hpp"
#include "cfgVehicles.hpp"
#include "some_other_file.hpp"
// This file is in the folder "ui"
#include "ui\gui.hpp"
// etc.
```

### Scripts[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Scripts)

ⓘ

It is recommended to register your scripts as functions in the [Arma 3: Functions Library](https://community.bistudio.com/wiki/Arma_3:_Functions_Library) class, especially if they are expected to be executed many times during the mission.

Scripts can be executed through appropriate classes in **config.cpp**. There are several ways to execute scripts, depending on when the execution take place.

For example, scripts that need to be executed upon the start of the mission can be added to the [Arma 3: Functions Library](https://community.bistudio.com/wiki/Arma_3:_Functions_Library) class with an init flag, such as `preInit = 1`.

Scripts that need to be executed when a certain event takes place (e.g. object creation, death, bullet impact, damage, etc.) can use [Arma 3: Event Handlers](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers), if applicable. Vehicles, weapons, projectiles, etc. can use configs to add event handlers once the object is created. It is also possible to add event handlers using scripts at a later point in the game.

In the case of scenarios (i.e. missions), scripts can be executed using [Event Scripts](https://community.bistudio.com/wiki/Event_Scripts) (e.g. init.sqf), using object init fields in 3DEN, triggers and waypoint statements, or CfgFunctions similar to addons (except instead of config.cpp, the classes are placed in [Description.ext](https://community.bistudio.com/wiki/Description.ext))

Some community modifications, such as **Community Base Addons 3 (CBA)**, add more ways to execute scripts, such as executing a script every time a unit is created (object init event handlers)

## Signing the Addon (optional)[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Signing_the_Addon_(optional))

Signing an addon allows it to be used in multiplayer servers that check for addon signatures. A private key is required for signing the addon.

### Keys and Signatures[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Keys_and_Signatures)

There are two types of keys involved in signing addon: **Private** keys and **Public** keys.

#### Private Key[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Private_Key)

A private key is a file in .biprivatekey format. It is used by the mod publisher to sign their addons.

⚠

The private keys, as the name suggests, should never be given to the public!

#### Public Key[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Public_Key)

A public key is a file in .bikey format. It is used by the server to check the addon signatures.
 It is safe to give these files to the public (typically published with the mod itself; see [Mod Folder Structure](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Mod_Folder_Structure)).

#### Signature[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Signature)

A signature is a file placed next to the PBO file, to verify its contents.
 They are named as addon_name.pbo.key_name.bisign

### Creating the Keys[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Creating_the_Keys)

To create the private and public keys, use the [DSUtils](https://community.bistudio.com/wiki/DSUtils) program in Arma 3 Tools.

ⓘ

There is no need to create a new key with every version of an addon. That would require all servers using the addon to update the key after every update, which can be inconvenient.

> *This article is a [Category:Stubs](https://community.bistudio.com/wiki/Category:Stubs). You can help BI Community Wiki by [expanding it](https://community.bistudio.com/wiki?title=Arma_3:_Creating_an_Addon&action=edit).*

## Building the Addon[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Building_the_Addon)

### Addon Builder[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Addon_Builder)

**Main interface**

[Folder Setup in Addon Builder](https://community.bistudio.com/wiki/File:Addon_Builder_Folder_Setup.png)

- **Addon source directory:** Should be the path to the Addon folder
- **Destination directory or filename:** The output folder which will contain the PBO file, as well as the signature (if "Sign output PBO" is checked)
- **Sign Output PBO:** See [Signing the Addon](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Signing_the_Addon_(optional))
- **Binarize:** Binarised configs are loaded faster by the game. They will also be checked for syntax errors during the packing process.

**Options**

- **List of files to copy directly:** By default, only **.cpp** files are included in the addon. If other files need to be copied to the addon (e.g. scripts, models, etc.), add them to the list, separated by ; or ,. It is also possible to use the wildcard character * instead of the file names/formats. For example:

```
*.p3d;*.paa;*.sqf;*.fxy;*.xml;*.bisurf;*.rvmat;*.h
```

All files will be copied in their original folder structure with respect to the Addon Folder.

ⓘ

When the "Binarize" option is checked, all [PreProcessor Commands](https://community.bistudio.com/wiki/PreProcessor_Commands#.23include) **.hpp** files in **config.cpp** will be added to **config.bin** file. Therefore there is no need to add ***.hpp** to the list of files to add (unless they're used elsewhere in the mod, such as scripts)

- **Addon Prefix:** See [Addon Prefix](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Addon_Prefix)
- **Path to private key file:** Set this path to the private key file (if "Sign output PBO" is checked)

Other options can be left at their default values.

Finally, click on "Pack" to start the packing process.

### Mikero's pboProject[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Mikero's_pboProject)

Simply set the paths and click on Crunch. If the [Addon Prefix](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Addon_Prefix) is not defined, it will be set the same as the input folder name by default
 Note that pboProject requires all files referenced in the config to be physically present in the P drive, even if they come from other mods. (for example, if you use a vanilla asset in your addon, such as A3\Data_F\Something.format, you must copy that file to P drive: P:\A3\Data_F\Something.format)

### HEMTT[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#HEMTT)

[HEMTT](https://github.com/BrettMayson/HEMTT) is a build system for addons. It has the great advantage of handling multiple addons at once as well as being able to be used in CLI environments like [GitHub Actions](https://github.com/arma-actions/hemtt). The [Category:Arma 3: Official Tools](https://community.bistudio.com/wiki/Category:Arma_3:_Official_Tools) have to be installed for it to binarise files. After installing hemtt you can get information about the usage with hemtt help. For a basic setup follow these steps:

In the command line enter the following command:

```
hemtt init
```

If you get an error that hemtt was not found make sure that the executable is in the project folder or the hemtt directory is part of your %PATH% variable. Fill out the prompts. Then create a folder called "addons". Inside of this folder create another folder called "main". Then create the following files:

- [PBOPREFIX](https://community.bistudio.com/wiki/PBOPREFIX)

```
\z\prefix\addons\main
```

- config.cpp

```cpp
#include "script_component.hpp"

class CfgPatches
{
	class ADDON
	{
		name = CSTRING(component);
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = { "CBA_main" };
		author = "You";
		url = "https://community.bistudio.com/wiki";
		VERSION_CONFIG;
	};
};
```

- script_component.hpp

```cpp
#define COMPONENT main
#include "script_mod.hpp"

#ifdef DEBUG_ENABLED_MAIN
	#define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_MAIN
	#define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

#include "script_macros.hpp"
```

- script_mod.hpp

The MAINPREFIX defaults to "z", the PREFIX is the one you entered during setup.

```cpp
#define MAINPREFIX z
#define PREFIX prefix

#include "script_version.hpp"

#define VERSION MAJOR.MINOR.PATCH
#define VERSION_AR MAJOR,MINOR,PATCH

#define REQUIRED_VERSION 1.88
```

- script_macros.hpp

This will add CBA as a dependency.

```cpp
#include "\x\cba\addons\main\script_macros_common.hpp"
```

- script_version.hpp

Keep track of your mod's version in this file. Follows [semantic versioning](https://semver.org/lang/de/).

```cpp
#define MAJOR 0
#define MINOR 0
#define PATCH 0
```

Now you should be able to run

```
hemtt build
```

The pbos are placed in the "addons" folder.

For more advanced setups and more examples check [CBA's git repository](https://github.com/CBATeam/CBA_A3) as well as [hemtt's GitHub](https://github.com/BrettMayson/HEMTT) page for documentation.

1. Numbered list item

## Mod Folder Structure[Link](https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon#Mod_Folder_Structure)

The mod folder contents should be in a certain structure to be correctly recognised by the game, as well as when uploaded to the Steam Workshop using the Publisher tool.
 The following tree list shows the general folder structure. Notice that some of these files/folders are optional, such as .bikey and .bisign files. It is possible to ship other contents in the mod folder as well, such as documentation and changelog files.

```
@My_Mod									// Mod folder. The @ sign is not required, but it helps distinguish mods from official content.
|__Addons								// Addons folder, containing all addons and their signatures (if signed)
|  |__addon_name.pbo
|  |__addon_name.pbo.key_name.bisign
|  |__other_addon.pbo
|  |__other_addon.pbo.key_name.bisign
|
|__Keys									// Keys folder (if the mod is signed)
|  |__key_name.bikey
|
|__mod.cpp								// (Optional) mod.cpp contains the mod description, icon, hover icon, etc.
|__mod.paa								// (Optional) mod icon
|__my_extension.dll						// (Optional) extension that was created as part of the mod, if any
|__my_mod_readme.pdf					// (optional) Documentation file (not loaded by the game)
```

Retrieved from "[https://community.bistudio.com/wiki?title=Arma_3:_Creating_an_Addon&oldid=378926](https://community.bistudio.com/wiki?title=Arma_3:_Creating_an_Addon&oldid=378926)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Stubs](https://community.bistudio.com/wiki/Category:Stubs)
- [Category:Arma 3: Tutorials](https://community.bistudio.com/wiki/Category:Arma_3:_Tutorials)