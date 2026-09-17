# Introduction to Arma Scripting - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

Categories: [Category:To-do](https://community.bistudio.com/wiki/Category:To-do)[Category:Arma Scripting Tutorials](https://community.bistudio.com/wiki/Category:Arma_Scripting_Tutorials)

Scripting is one of the most powerful and most versatile tools available in the Arma sandbox. Unfortunately, it is also one of the most complex and unforgiving aspects of addon (i.e. mod) and mission creation.

All Arma games from Arma: Cold War Assault to Arma 3 use a scripting language called [SQF Syntax](https://community.bistudio.com/wiki/SQF_Syntax). Its predecessor [SQS Syntax](https://community.bistudio.com/wiki/SQS_Syntax) has been considered deprecated since Armed Assault (2006) and is no longer used. As of Arma Reforger (2022), SQF has been succeeded by [Category:Arma Reforger/Modding/Scripting/Guidelines](https://community.bistudio.com/wiki/Category:Arma_Reforger/Modding/Scripting/Guidelines). This document only considers SQF.

## Scripting Topics[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Scripting_Topics)

There is a plethora of topics to learn about in the context of Arma scripting (see the table below). Fortunately, there is no need to acquire detailed knowledge about all of these things in order to get started with scripting. To aid with prioritisation, this page provides three selections of topics, each relevant to beginner, intermediate and advanced scripters respectively.

| [Real Virtuality](https://community.bistudio.com/wiki/Real_Virtuality) Scripting | [Real Virtuality](https://community.bistudio.com/wiki/Real_Virtuality) Scripting | [Real Virtuality](https://community.bistudio.com/wiki/Real_Virtuality) Scripting |
| --- | --- | --- |
| Terminology | Terminology | [Argument](https://community.bistudio.com/wiki/Argument) ● [Identifier](https://community.bistudio.com/wiki/Identifier) ● [Expression](https://community.bistudio.com/wiki/Expression) ● [Operand](https://community.bistudio.com/wiki/Operand) ● [Operators](https://community.bistudio.com/wiki/Operators) ● [Parameter](https://community.bistudio.com/wiki/Parameter) ● [Statement](https://community.bistudio.com/wiki/Statement) ● [Variables](https://community.bistudio.com/wiki/Variables) ● [Magic Variables](https://community.bistudio.com/wiki/Magic_Variables) ● [Function](https://community.bistudio.com/wiki/Function) |
| Syntax | Syntax | [SQF Syntax](https://community.bistudio.com/wiki/SQF_Syntax) ● [SQS Syntax](https://community.bistudio.com/wiki/SQS_Syntax) ● [Order of Precedence](https://community.bistudio.com/wiki/Order_of_Precedence) ● [Control Structures](https://community.bistudio.com/wiki/Control_Structures) |
| Tutorials | Tutorials | Introduction to Arma Scripting ● [Code Best Practices](https://community.bistudio.com/wiki/Code_Best_Practices) ● [Category:Example Code](https://community.bistudio.com/wiki/Category:Example_Code) ● [Code Optimisation](https://community.bistudio.com/wiki/Code_Optimisation) ● [Mission Optimisation](https://community.bistudio.com/wiki/Mission_Optimisation) ● [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting) ● [SQS to SQF conversion](https://community.bistudio.com/wiki/SQS_to_SQF_conversion) |
| Data Types | General | [Array](https://community.bistudio.com/wiki/Array) ● [Boolean](https://community.bistudio.com/wiki/Boolean) ● [Code](https://community.bistudio.com/wiki/Code) ● [Config](https://community.bistudio.com/wiki/Config) ● [Control](https://community.bistudio.com/wiki/Control) ● [Diary Record](https://community.bistudio.com/wiki/Diary_Record) ● [Display](https://community.bistudio.com/wiki/Display) ● [Eden Entity](https://community.bistudio.com/wiki/Eden_Entity) ● [Eden ID](https://community.bistudio.com/wiki/Eden_ID) ● [Editor Object](https://community.bistudio.com/wiki/Editor_Object) ● [Group](https://community.bistudio.com/wiki/Group) ● [HashMap](https://community.bistudio.com/wiki/HashMap) ● [Location](https://community.bistudio.com/wiki/Location) ● [Namespace](https://community.bistudio.com/wiki/Namespace) ● [Number](https://community.bistudio.com/wiki/Number) ● [Object](https://community.bistudio.com/wiki/Object) ● [Script Handle](https://community.bistudio.com/wiki/Script_Handle) [Side](https://community.bistudio.com/wiki/Side) ● [String](https://community.bistudio.com/wiki/String) ● [Structured Text](https://community.bistudio.com/wiki/Structured_Text) ● [Task](https://community.bistudio.com/wiki/Task) ● [Team](https://community.bistudio.com/wiki/Team) ● [Team Member](https://community.bistudio.com/wiki/Team_Member) ● [NaN](https://community.bistudio.com/wiki/NaN) ● [Anything](https://community.bistudio.com/wiki/Anything) ● [Nothing](https://community.bistudio.com/wiki/Nothing) ● [Void](https://community.bistudio.com/wiki/Void) ● [Switch Type](https://community.bistudio.com/wiki/Switch_Type) ● [While Type](https://community.bistudio.com/wiki/While_Type) ● [With Type](https://community.bistudio.com/wiki/With_Type) ● [For Type](https://community.bistudio.com/wiki/For_Type) ● [If Type](https://community.bistudio.com/wiki/If_Type) |
| Data Types |  |  |
| Special Arrays | [Array of Eden Entities](https://community.bistudio.com/wiki/Array_of_Eden_Entities) ● [Color](https://community.bistudio.com/wiki/Color) ● [Date](https://community.bistudio.com/wiki/Date) ● [ParticleArray](https://community.bistudio.com/wiki/ParticleArray) ● [Position](https://community.bistudio.com/wiki/Position) ● [Unit Loadout Array](https://community.bistudio.com/wiki/Unit_Loadout_Array) ● [Vector3D](https://community.bistudio.com/wiki/Vector3D) ● [Waypoint](https://community.bistudio.com/wiki/Waypoint) |  |
| Scripting Commands | Scripting Commands | [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands) ● [Category:Scripting Commands by Functionality](https://community.bistudio.com/wiki/Category:Scripting_Commands_by_Functionality) |
| Scripting Functions | Scripting Functions | [Category:Functions](https://community.bistudio.com/wiki/Category:Functions) ● [Category:Functions by Functionality](https://community.bistudio.com/wiki/Category:Functions_by_Functionality) |
| Debugging | Debugging | [Category:Common Scripting Errors](https://community.bistudio.com/wiki/Category:Common_Scripting_Errors) ● [Debugging Techniques](https://community.bistudio.com/wiki/Debugging_Techniques) ● [Exception handling](https://community.bistudio.com/wiki/Exception_handling) |
| Advanced | Advanced | [Event Scripts](https://community.bistudio.com/wiki/Event_Scripts) ● [Category:Event Handlers](https://community.bistudio.com/wiki/Category:Event_Handlers) ● [PreProcessor Commands](https://community.bistudio.com/wiki/PreProcessor_Commands) ● [Initialisation Order](https://community.bistudio.com/wiki/Initialisation_Order) ● [Performance Profiling](https://community.bistudio.com/wiki/Performance_Profiling) |

## Beginner Scripting[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Beginner_Scripting)

🚧

**[Category:To-do](https://community.bistudio.com/wiki/Category:To-do):**

- Using existing functions

### Variables[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Variables)

[Variables](https://community.bistudio.com/wiki/Variables) are a fundamental building block of scripting (and programming in general). Like in mathematics, they serve as placeholders for values. A few examples:

- Copy code to clipboardA [=](https://community.bistudio.com/wiki/a_=_b) 1; The variable A now has the value 1.
- Copy code to clipboardB [=](https://community.bistudio.com/wiki/a_=_b) 2; The variable B now has the value 2.
- Copy code to clipboardC [=](https://community.bistudio.com/wiki/a_=_b) "Hello World!"; The variable C now has the value "Hello World!".

A variable always has a [Data Types](https://community.bistudio.com/wiki/Data_Types). In the example above, the variables A and B both have the data type [Number](https://community.bistudio.com/wiki/Number), while C has the data type [String](https://community.bistudio.com/wiki/String). The data type of a variable is not fixed and changes automatically based on the current value of the variable.

### Commands and Operators[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Commands_and_Operators)

Two other basic tools of scripting are commands and [Operators](https://community.bistudio.com/wiki/Operators). In fact, they are so basic that the examples in the [Variables](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Variables) section above already had to make use of an operator: The equals sign (Copy code to clipboard[=](https://community.bistudio.com/wiki/a_=_b)) serves as the assignment operator, assigning values to variables. Similarly, symbols such as Copy code to clipboard[+](https://community.bistudio.com/wiki/+), Copy code to clipboard[-](https://community.bistudio.com/wiki/-), Copy code to clipboard[*](https://community.bistudio.com/wiki/a_*_b) and Copy code to clipboard[/](https://community.bistudio.com/wiki/a_/_b) are also operators. Using operators is quite simple:

Copy code to clipboard

A [=](https://community.bistudio.com/wiki/a_=_b) 1.5; B [=](https://community.bistudio.com/wiki/a_=_b) -2 [*](https://community.bistudio.com/wiki/a_*_b) A; C [=](https://community.bistudio.com/wiki/a_=_b) A [+](https://community.bistudio.com/wiki/+) B [+](https://community.bistudio.com/wiki/+) 3.5; // Result: C is 2

Commands are often more versatile and complex than operators and can sometimes be used to interact with the game in some way. For instance, the [setPosATL](https://community.bistudio.com/wiki/setPosATL) command can be used to change the position of an object in the game world, the [damage](https://community.bistudio.com/wiki/damage) command returns the amount of damage an object has suffered and the [systemChat](https://community.bistudio.com/wiki/systemChat) command can be used to display a message in the system chat.

While operators are usually fairly intuitive to use, commands are often more complicated. As such, every single command (and every single operator) has a dedicated [Main Page](https://community.bistudio.com/wiki/Main_Page) page documenting it. This makes the Community Wiki an essential resource for scripting as it can be consulted whenever an unfamiliar command is encountered or needs to be used. The documentation commonly includes information about the behaviour and effect of the command, its return value and the purpose and data types of its parameters.

ⓘ

Commands List can be found here: [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands).

### Control Structures, Conditions and Booleans[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Control_Structures,_Conditions_and_Booleans)

[Control Structures](https://community.bistudio.com/wiki/Control_Structures) allow scripts to accomplish complex tasks. See the following:

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) ([damage](https://community.bistudio.com/wiki/damage) [player](https://community.bistudio.com/wiki/player) [>](https://community.bistudio.com/wiki/a_greater_b) 0.5) [then](https://community.bistudio.com/wiki/then) { [player](https://community.bistudio.com/wiki/player) [setDamage](https://community.bistudio.com/wiki/setDamage) 0; [systemChat](https://community.bistudio.com/wiki/systemChat) "The player has been healed."; } [else](https://community.bistudio.com/wiki/else) { [systemChat](https://community.bistudio.com/wiki/systemChat) "The player is fine."; };

This code behaves differently depending on the damage status of the player. The [systemChat](https://community.bistudio.com/wiki/systemChat) output and whether or not the player is healed changes dynamically based on how much health the player has when the code is executed.

#### Conditions[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Conditions)

In the example above, the condition is Copy code to clipboard[damage](https://community.bistudio.com/wiki/damage) [player](https://community.bistudio.com/wiki/player) [>](https://community.bistudio.com/wiki/a_greater_b) 0.5. Like all conditions, it results in a [Boolean](https://community.bistudio.com/wiki/Boolean) value when evaluated:

1. First, Copy code to clipboard[damage](https://community.bistudio.com/wiki/damage) [player](https://community.bistudio.com/wiki/player) is evaluated and returns a number.
2. Then, the Copy code to clipboard[>](https://community.bistudio.com/wiki/a_greater_b) operator compares that number to 0.5:
  - If the number is greater than 0.5, the Copy code to clipboard[>](https://community.bistudio.com/wiki/a_greater_b) operator returns [true](https://community.bistudio.com/wiki/true).
  - If the number is less than or equal to 0.5, the Copy code to clipboard[>](https://community.bistudio.com/wiki/a_greater_b) operator returns [false](https://community.bistudio.com/wiki/false).

#### Booleans[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Booleans)

The data type [Boolean](https://community.bistudio.com/wiki/Boolean) only has two possible values: [true](https://community.bistudio.com/wiki/true) and [false](https://community.bistudio.com/wiki/false).

##### Boolean Operations[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Boolean_Operations)

There are three basic operations that can be performed on Boolean values:

| Operation | Description | SQF Operator | SQF Command |
| --- | --- | --- | --- |
| NOT (Negation) | Inverts the input value. | Copy code to clipboard[!](https://community.bistudio.com/wiki/!_a) | [not](https://community.bistudio.com/wiki/not) |
| AND (Conjunction) | Combines two Booleans into one. Only returns [true](https://community.bistudio.com/wiki/true) if both input values are [true](https://community.bistudio.com/wiki/true). | Copy code to clipboard[&&](https://community.bistudio.com/wiki/a_&&_b) | [and](https://community.bistudio.com/wiki/and) |
| OR (Disjunction) | Combines two Booleans into one. Returns [true](https://community.bistudio.com/wiki/true) if at least one of the input values is [true](https://community.bistudio.com/wiki/true). | Copy code to clipboard[\|\|](https://community.bistudio.com/wiki/a_or_b) | [or](https://community.bistudio.com/wiki/or) |

Both the input and the output of these operations are Boolean values. Their behaviour is defined as follows:

| \| NOT \| NOT \| \| --- \| --- \| \| Expression \| Result \| \| Copy code to clipboard[!](https://community.bistudio.com/wiki/!_a)[true](https://community.bistudio.com/wiki/true) \| [false](https://community.bistudio.com/wiki/false) \| \| Copy code to clipboard[!](https://community.bistudio.com/wiki/!_a)[false](https://community.bistudio.com/wiki/false) \| [true](https://community.bistudio.com/wiki/true) \| | \| AND \| AND \| \| --- \| --- \| \| Expression \| Result \| \| Copy code to clipboard[true](https://community.bistudio.com/wiki/true) [&&](https://community.bistudio.com/wiki/a_&&_b) [true](https://community.bistudio.com/wiki/true) \| [true](https://community.bistudio.com/wiki/true) \| \| Copy code to clipboard[true](https://community.bistudio.com/wiki/true) [&&](https://community.bistudio.com/wiki/a_&&_b) [false](https://community.bistudio.com/wiki/false) \| [false](https://community.bistudio.com/wiki/false) \| \| Copy code to clipboard[false](https://community.bistudio.com/wiki/false) [&&](https://community.bistudio.com/wiki/a_&&_b) [true](https://community.bistudio.com/wiki/true) \| [false](https://community.bistudio.com/wiki/false) \| \| Copy code to clipboard[false](https://community.bistudio.com/wiki/false) [&&](https://community.bistudio.com/wiki/a_&&_b) [false](https://community.bistudio.com/wiki/false) \| [false](https://community.bistudio.com/wiki/false) \| | \| OR \| OR \| \| --- \| --- \| \| Expression \| Result \| \| Copy code to clipboard[true](https://community.bistudio.com/wiki/true) [\\|\\|](https://community.bistudio.com/wiki/a_or_b) [true](https://community.bistudio.com/wiki/true) \| [true](https://community.bistudio.com/wiki/true) \| \| Copy code to clipboard[true](https://community.bistudio.com/wiki/true) [\\|\\|](https://community.bistudio.com/wiki/a_or_b) [false](https://community.bistudio.com/wiki/false) \| [true](https://community.bistudio.com/wiki/true) \| \| Copy code to clipboard[false](https://community.bistudio.com/wiki/false) [\\|\\|](https://community.bistudio.com/wiki/a_or_b) [true](https://community.bistudio.com/wiki/true) \| [true](https://community.bistudio.com/wiki/true) \| \| Copy code to clipboard[false](https://community.bistudio.com/wiki/false) [\\|\\|](https://community.bistudio.com/wiki/a_or_b) [false](https://community.bistudio.com/wiki/false) \| [false](https://community.bistudio.com/wiki/false) \| |
| --- | --- | --- |
| NOT | NOT |  |
| Expression | Result |  |
| Copy code to clipboard[!](https://community.bistudio.com/wiki/!_a)[true](https://community.bistudio.com/wiki/true) | [false](https://community.bistudio.com/wiki/false) |  |
| Copy code to clipboard[!](https://community.bistudio.com/wiki/!_a)[false](https://community.bistudio.com/wiki/false) | [true](https://community.bistudio.com/wiki/true) |  |
| AND | AND |  |
| Expression | Result |  |
| Copy code to clipboard[true](https://community.bistudio.com/wiki/true) [&&](https://community.bistudio.com/wiki/a_&&_b) [true](https://community.bistudio.com/wiki/true) | [true](https://community.bistudio.com/wiki/true) |  |
| Copy code to clipboard[true](https://community.bistudio.com/wiki/true) [&&](https://community.bistudio.com/wiki/a_&&_b) [false](https://community.bistudio.com/wiki/false) | [false](https://community.bistudio.com/wiki/false) |  |
| Copy code to clipboard[false](https://community.bistudio.com/wiki/false) [&&](https://community.bistudio.com/wiki/a_&&_b) [true](https://community.bistudio.com/wiki/true) | [false](https://community.bistudio.com/wiki/false) |  |
| Copy code to clipboard[false](https://community.bistudio.com/wiki/false) [&&](https://community.bistudio.com/wiki/a_&&_b) [false](https://community.bistudio.com/wiki/false) | [false](https://community.bistudio.com/wiki/false) |  |
| OR | OR |  |
| Expression | Result |  |
| Copy code to clipboard[true](https://community.bistudio.com/wiki/true) [\|\|](https://community.bistudio.com/wiki/a_or_b) [true](https://community.bistudio.com/wiki/true) | [true](https://community.bistudio.com/wiki/true) |  |
| Copy code to clipboard[true](https://community.bistudio.com/wiki/true) [\|\|](https://community.bistudio.com/wiki/a_or_b) [false](https://community.bistudio.com/wiki/false) | [true](https://community.bistudio.com/wiki/true) |  |
| Copy code to clipboard[false](https://community.bistudio.com/wiki/false) [\|\|](https://community.bistudio.com/wiki/a_or_b) [true](https://community.bistudio.com/wiki/true) | [true](https://community.bistudio.com/wiki/true) |  |
| Copy code to clipboard[false](https://community.bistudio.com/wiki/false) [\|\|](https://community.bistudio.com/wiki/a_or_b) [false](https://community.bistudio.com/wiki/false) | [false](https://community.bistudio.com/wiki/false) |  |

#### Complex Conditions[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Complex_Conditions)

Boolean operations can be used to create complex conditions by combining multiple conditions into one.

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) (([alive](https://community.bistudio.com/wiki/alive) VIP_1 [&&](https://community.bistudio.com/wiki/a_&&_b) [triggerActivated](https://community.bistudio.com/wiki/triggerActivated) VIP_1_Task_Complete) [||](https://community.bistudio.com/wiki/a_or_b) ([alive](https://community.bistudio.com/wiki/alive) VIP_2 [&&](https://community.bistudio.com/wiki/a_&&_b) [triggerActivated](https://community.bistudio.com/wiki/triggerActivated) VIP_2_Task_Complete)) [then](https://community.bistudio.com/wiki/then) { [systemChat](https://community.bistudio.com/wiki/systemChat) "At least one VIP has been rescued."; };

ⓘ

Beginners sometimes write conditions such as

Copy code to clipboard[if](https://community.bistudio.com/wiki/if) (Condition [==](https://community.bistudio.com/wiki/a_==_b) [true](https://community.bistudio.com/wiki/true))

or

Copy code to clipboard[if](https://community.bistudio.com/wiki/if) (Condition [==](https://community.bistudio.com/wiki/a_==_b) [false](https://community.bistudio.com/wiki/false))

.

While doing so is not a real error, it is unnecessary because [Control Structures](https://community.bistudio.com/wiki/Control_Structures) (and [Trigger](https://community.bistudio.com/wiki/Trigger)) always implicitly compare the condition to [true](https://community.bistudio.com/wiki/true).

The correct (as in faster, more common and more readable) way to write such conditions is

Copy code to clipboard[if](https://community.bistudio.com/wiki/if) (Condition)

and

Copy code to clipboard[if](https://community.bistudio.com/wiki/if) ([!](https://community.bistudio.com/wiki/!_a)Condition)

respectively.

### Arrays[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Arrays)

An [Array](https://community.bistudio.com/wiki/Array) is a [Category:Data Types](https://community.bistudio.com/wiki/Category:Data_Types) that can be seen as a list of items. This list can hold none to multiple elements of different types:

Copy code to clipboard

[] // an empty array [[true](https://community.bistudio.com/wiki/true)] // an array of 1 element (Boolean) [0, 10, 20, 30, 40, 50] // an array of 6 elements of Number type ["John Doe", 32, [true](https://community.bistudio.com/wiki/true)] // an array of 3 elements of different types (String, Number, Boolean)

An array is a useful way to keep data together and is used for example to store positions.

#### Positions[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Positions)

[Position](https://community.bistudio.com/wiki/Position) are represented as 2D or 3D [Array](https://community.bistudio.com/wiki/Array) of [Number](https://community.bistudio.com/wiki/Number) (usually in the format Copy code to clipboard[X, Y] or Copy code to clipboard[X, Y, Z]) where X represents West-East, Y represents South-North and Z represents altitude. However, there are some important caveats and distinctions one should be aware of - for instance, the positions Copy code to clipboard[0, 0, 0] ASL (**A**bove **S**ea **L**evel) and Copy code to clipboard[0, 0, 0] AGL (**A**bove **G**round **L**evel) are not necessarily equivalent. It is therefore highly recommended to read the [Position](https://community.bistudio.com/wiki/Position) page before working with positions.

### Script Files[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Script_Files)

Scripts are usually placed in [Script File](https://community.bistudio.com/wiki/Script_File). It is of course possible and sometimes even necessary to use short pieces of code in the Editor (e.g. in the *On Activation* expression of a [Trigger](https://community.bistudio.com/wiki/Trigger)), but scripts can become long and complex, and then working with them is far easier when they are properly placed in script files. Additionally, some features are only accessible through the use of script files ([Event Scripts](https://community.bistudio.com/wiki/Event_Scripts) for example).

Script files are basically just text files with a certain filename extension. For script files, that file extension is .sqf (or .sqs), but in the broader context of Arma scripting, modification, configuration and mission design, more file extensions can be encountered: .ext, .hpp, .cpp and .cfg to mention the most common ones.

#### File Creation[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#File_Creation)

Unfortunately, Windows does not make the creation of blank files with a desired file extension easily accessible.

For instance, a common pitfall when trying to use [Description.ext](https://community.bistudio.com/wiki/Description.ext) (a file that is used to configure certain mission features such as the respawn settings) for the first time is (unknowingly) creating Description.ext.txt instead of Description.ext because the Windows File Explorer hides file extensions by default. Obviously, Description.ext.txt will not work and will not have any of the desired effects on the mission because the game does not recognize it as Description.ext, but identifying a wrong file extension as the root cause of an issue when troubleshooting is notoriously difficult as one is usually looking for errors in the code and not in the filename.

While there are many different ways to create a blank text file with a specific file extension, the easiest method using native Windows tools is probably this:

- Preparation (only needs to be done once):

1. Open the File Explorer
2. Open the *View* tab at the top
3. Tick the *File name extensions* checkbox

- File Creation:

1. Navigate to the location where you want to create a new script file
2. Right-click
3. Go to *New*
4. Click on *Text Document*
5. Rename New Text Document.txt to what you need

ⓘ

It is also possible to bypass Notepad's automatic addition of the .txt extension by wrapping the file name in quote, e.g "description.ext".

#### File Locations[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#File_Locations)

In the context of mission creation, script files generally need to be placed in the corresponding *scenario folder* (often also called the *mission root folder*). Every mission has its own scenario folder, it is created by the Editor when saving the scenario for the first time. By default it only contains a single file called [mission.sqm](https://community.bistudio.com/wiki/Mission.sqm); this file mostly stores data regarding Editor-placed entities and does not need to be touched when scripting.

[Description.ext](https://community.bistudio.com/wiki/Description.ext) and [Event Scripts](https://community.bistudio.com/wiki/Event_Scripts) have to be placed directly in the root of the scenario folder (i.e. next to mission.sqm), but all other files can be placed in subfolders of the scenario folder. A well-structured scenario folder could look like this:

```
Apex%20Protocol.Tanoa/
├── functions/
│   ├── fn_myFirstFunction.sqf
│   └── fn_mySecondFunction.sqf
├── scripts/
│   ├── myFirstScript.sqf
│   └── mySecondScript.sqf
├── description.ext
├── initPlayerLocal.sqf
├── initServer.sqf
└── mission.sqm
```

Each scenario folder is stored in either the missions or the mpmissions subfolder of the folder containing the [Profile](https://community.bistudio.com/wiki/Profile) that was used to create the scenario. For instance, the path to the scenario folder from the example above could be:

```
C:\Users\Scott Miller\Documents\Arma 3 - Other Profiles\Keystone\missions\Apex%20Protocol.Tanoa
```

The Editor uses [percent-encoding](https://en.wikipedia.org/wiki/Percent-encoding) for scenario folder names, that is why whitespaces in the scenario name are replaced with %20.

ⓘ

The [Category:Eden Editor](https://community.bistudio.com/wiki/Category:Eden_Editor) provides a useful shortcut to quickly open a mission's scenario folder in the Windows File Explorer: With the mission open in the Editor, go to *Scenario* in the top left and then click on *Open Scenario Folder*.

**See Also:**

- [2D Editor: External](https://community.bistudio.com/wiki/2D_Editor:_External)
- [Eden Editor: Scenario Folder](https://community.bistudio.com/wiki/Eden_Editor:_Scenario_Folder)
- [Profile](https://community.bistudio.com/wiki/Profile) (the possible profile folder paths are listed there)

#### Editing Script Files[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Editing_Script_Files)

Because script files are essentially plain text files, they can be edited with just about any text editor. For instance, the native Windows Notepad can be used, but working with it is not very comfortable. As such, regular scripters typically use more versatile applications such as [Notepad++](https://notepad-plus-plus.org/) or [Visual Studio Code](https://code.visualstudio.com/), usually in combination with plugins that add additional support for SQF. One feature commonly provided by these plugins is *syntax highlighting*, and for good reason: Syntax highlighting makes code significantly more readable and helps recognizing and avoiding basic syntax errors. Consequently, it is highly recommended to use syntax highlighting.

See [Category:Community Tools](https://community.bistudio.com/wiki/Category:Community_Tools#Code_Edition) for a selection of community-made applications and plugins for Arma Scripting.

#### Script Execution[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Script_Execution)

The [execVM](https://community.bistudio.com/wiki/execVM) command is used to execute script files.

For instance, myFirstScript.sqf from the [File Locations](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#File_Locations) example above can simply be executed like so:

Copy code to clipboard

[execVM](https://community.bistudio.com/wiki/execVM) "scripts\myFirstScript.sqf";

This can be done anywhere: Within another script, from the [Arma 3: Debug Console](https://community.bistudio.com/wiki/Arma_3:_Debug_Console), in the *On Activation* or *On Deactivation* expression of a [Trigger](https://community.bistudio.com/wiki/Trigger) or in the init field of an [Eden Editor: Object](https://community.bistudio.com/wiki/Eden_Editor:_Object) in the Editor.

## Intermediate Scripting[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Intermediate_Scripting)

🚧

**[Category:To-do](https://community.bistudio.com/wiki/Category:To-do):**

- [Category:Functions](https://community.bistudio.com/wiki/Category:Functions)
- [Namespace](https://community.bistudio.com/wiki/Namespace), [Variables](https://community.bistudio.com/wiki/Variables#Scopes)
- [Category:Event Handlers](https://community.bistudio.com/wiki/Category:Event_Handlers)
- [HashMap](https://community.bistudio.com/wiki/HashMap)

## Advanced Scripting[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Advanced_Scripting)

🚧

**[Category:To-do](https://community.bistudio.com/wiki/Category:To-do):**

- [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting)
- [GUI Tutorial](https://community.bistudio.com/wiki/GUI_Tutorial)
- [Code Optimisation](https://community.bistudio.com/wiki/Code_Optimisation)
- [Debugging Techniques](https://community.bistudio.com/wiki/Debugging_Techniques)

## Miscellaneous[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Miscellaneous)

ⓘ

This section contains content from an old version of this page which is due to be updated.

## Before anything[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Before_anything)

Is your idea necessary?
: Will players even notice or use what you want to script? Just because you can does not mean you should. Sometimes less is more!

Is it possible to do this in the editor?
: The

[Category:Eden Editor](https://community.bistudio.com/wiki/Category:Eden_Editor)

is a powerful tool and with it alone one can achieve a lot of things without writing a single line of code.
: Poorly written scripts are a frequent cause of poor performance, both in singleplayer and multiplayer scenarios.

Can it be scripted using SQF?
: This question might be hard to answer. Try to get as much information about what you want to do and what

[Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands)

and

[Category:Functions](https://community.bistudio.com/wiki/Category:Functions)

there are before spending time on writing a script, just to find out that what you hoped to achieve is not possible after all.

ⓘ

Scripting is not the solution for everything!

### Terms[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Terms)

The following is a collection of terms frequently encountered when talking or reading about scripting.

Game Engine
: The core program of the game which executes your scripting commands at run time.

Script / Script File
: Scripts are usually placed in

[Script File](https://community.bistudio.com/wiki/Script_File)

. Script files contain code.

Syntax
: See

[SQF Syntax](https://community.bistudio.com/wiki/SQF_Syntax)

(Arma, Arma 2, Arma 3).
: See

[SQS Syntax](https://community.bistudio.com/wiki/SQS_Syntax)

(Operation Flashpoint, Arma).

Variables
: A

[Variables](https://community.bistudio.com/wiki/Variables)

is a named storage container for data.
: The name of a variable is called its

[Identifier](https://community.bistudio.com/wiki/Identifier)

.

Data Types
: The

[Category:Data Types](https://community.bistudio.com/wiki/Category:Data_Types)

of a variable specifies which kind of data that variable can contain.

Operators
: See

[Operators](https://community.bistudio.com/wiki/Operators)

Control Structures
: See

[Control Structures](https://community.bistudio.com/wiki/Control_Structures)

Functions
: See

[Function](https://community.bistudio.com/wiki/Function)

### Must-Read Articles[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Must-Read_Articles)

#### Best Practices[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Best_Practices)

See [Code Best Practices](https://community.bistudio.com/wiki/Code_Best_Practices)

#### Debugging[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Debugging)

- [Debugging Techniques](https://community.bistudio.com/wiki/Debugging_Techniques)
- [Category:Community Tools](https://community.bistudio.com/wiki/Category:Community_Tools#Debug_Console.2FSystem)

#### Optimisation[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Optimisation)

- [Code Optimisation](https://community.bistudio.com/wiki/Code_Optimisation)
- [Mission Optimisation](https://community.bistudio.com/wiki/Mission_Optimisation)

### Useful Links[Link](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting#Useful_Links)

These pages cover further aspects of scripting:

- [Category:Example Code](https://community.bistudio.com/wiki/Category:Example_Code)
- [Control Structures](https://community.bistudio.com/wiki/Control_Structures)
- [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting)
- [Exception handling](https://community.bistudio.com/wiki/Exception_handling)
- [Script File](https://community.bistudio.com/wiki/Script_File)
- [Function](https://community.bistudio.com/wiki/Function)
- [SQS to SQF conversion](https://community.bistudio.com/wiki/SQS_to_SQF_conversion)

Consider the following resources for more general learning:

- [6thSense.eu Editing Guide](https://community.bistudio.com/wiki/6thSense.eu/EG)
- *Fockers Arma 3 Scripting Guide* (dead link)
- *Mr-Murray's Armed Assault Editing Guide - Deluxe Edition* (dead link)
- [Excellent German SQF tutorial (YouTube)](https://youtu.be/WmEBN-RbK44)

Retrieved from "[https://community.bistudio.com/wiki?title=Introduction_to_Arma_Scripting&oldid=371144](https://community.bistudio.com/wiki?title=Introduction_to_Arma_Scripting&oldid=371144)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:To-do](https://community.bistudio.com/wiki/Category:To-do)
- [Category:Arma Scripting Tutorials](https://community.bistudio.com/wiki/Category:Arma_Scripting_Tutorials)