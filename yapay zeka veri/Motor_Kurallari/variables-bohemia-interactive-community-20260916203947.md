# Variables - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/Variables#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

Category: [Category:Scripting Topics](https://community.bistudio.com/wiki/Category:Scripting_Topics)

A variable is a "storage container" or "named placeholder" for data. You can read and modify the data once this container is created.
 Its "name" is referenced as [Identifier](https://community.bistudio.com/wiki/Identifier).

## Requirements[Link](https://community.bistudio.com/wiki/Variables#Requirements)

The following links guide to the basics to understand this article:

- [Introduction to Arma Scripting](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting)
- [Identifier](https://community.bistudio.com/wiki/Identifier)

## Initialisation[Link](https://community.bistudio.com/wiki/Variables#Initialisation)

The first thing to do to create a variable is to find its name, also called [Identifier](https://community.bistudio.com/wiki/Identifier); this name must be speaking to the reader - keep in mind that code is meant to be read by *human beings* (see [Code Best Practices](https://community.bistudio.com/wiki/Code_Best_Practices#Variable_format)).

Once a proper name is found, it can be used to **declare** (or **initialise**) the variable:

Copy code to clipboard

myVariable [=](https://community.bistudio.com/wiki/a_=_b) 0;

Before [Category:Arma 2](https://community.bistudio.com/wiki/Category:Arma_2), querying undefined (or uninitialised) variables returns [nil](https://community.bistudio.com/wiki/nil) (undefined value); from [Category:Arma 2](https://community.bistudio.com/wiki/Category:Arma_2) and later, it returns an "Error Undefined variable in expression" error.

ⓘ

An undefined ([nil](https://community.bistudio.com/wiki/nil)) variable converted to [String](https://community.bistudio.com/wiki/String) with [str](https://community.bistudio.com/wiki/str) will return [scalar bool array string 0xe0ffffef](https://community.bistudio.com/wiki/scalar_bool_array_string_0xe0ffffef) (in [Category:ArmA: Armed Assault](https://community.bistudio.com/wiki/Category:ArmA:_Armed_Assault)) and [scalar bool array string 0xfcffffef](https://community.bistudio.com/wiki/scalar_bool_array_string_0xfcffffef) (in [Category:Operation Flashpoint](https://community.bistudio.com/wiki/Category:Operation_Flashpoint)).
 Unless trying to emulate [isNil](https://community.bistudio.com/wiki/isNil), **always** declare your variable before trying to access it.

## Deletion[Link](https://community.bistudio.com/wiki/Variables#Deletion)

Once created, variables take up space in the computer's memory.
 This is not drastic for small variables, but if a big number of very large variables is used, it is recommended to undefine the unneeded ones in order to free up memory.

Variable deletion is done by setting its value to [nil](https://community.bistudio.com/wiki/nil):

Copy code to clipboard

HugeVariable [=](https://community.bistudio.com/wiki/a_=_b) [nil](https://community.bistudio.com/wiki/nil);

ⓘ

Local variables are automatically freed (deleted from memory) when their scope is exited, avoiding the need to manually deallocate them.

## Scopes[Link](https://community.bistudio.com/wiki/Variables#Scopes)

Variables are only visible in certain scopes of the game. This prevents name conflicts between different variables in different [Script File](https://community.bistudio.com/wiki/Script_File).

There are two main scopes:

### Global Scope[Link](https://community.bistudio.com/wiki/Variables#Global_Scope)

A global variable is visible from all scripts on the computer on which it was defined. Names given to units in the [Mission Editor](https://community.bistudio.com/wiki/Mission_Editor) are also global variables pointing to those units, which may not be redefined or modified.

⚠

a global variable can be different from one machine to another! To ensure the global variable's proper broadcast, see

[publicVariable](https://community.bistudio.com/wiki/publicVariable)

,

[publicVariableServer](https://community.bistudio.com/wiki/publicVariableServer)

and

[publicVariableClient](https://community.bistudio.com/wiki/publicVariableClient)

.

If the value changes, the broadcast must be reapplied. e.g:

Copy code to clipboard

GlobalVariable [=](https://community.bistudio.com/wiki/a_=_b) 33; [publicVariable](https://community.bistudio.com/wiki/publicVariable) "GlobalVariable"; GlobalVariable [=](https://community.bistudio.com/wiki/a_=_b) 42; // GlobalVariable is now 42 on the current machine but still 33 on the others [publicVariable](https://community.bistudio.com/wiki/publicVariable) "GlobalVariable"; // updates the value to 42 for everyone

### Local Scope[Link](https://community.bistudio.com/wiki/Variables#Local_Scope)

A local variable is only visible in the [Script File](https://community.bistudio.com/wiki/Script_File), [Function](https://community.bistudio.com/wiki/Function) or [Control Structures](https://community.bistudio.com/wiki/Control_Structures) in which it was defined.

ⓘ

A local variable cannot be broadcast. In order to broadcast a local variable's

*value*

, it must be assigned to a global variable first:

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _myLocalVariable [=](https://community.bistudio.com/wiki/a_=_b) 33; [publicVariable](https://community.bistudio.com/wiki/publicVariable) "_myLocalVariable"; // incorrect GlobalVariable [=](https://community.bistudio.com/wiki/a_=_b) _myLocalVariable; [publicVariable](https://community.bistudio.com/wiki/publicVariable) "GlobalVariable"; // correct

### Local Variables Scope[Link](https://community.bistudio.com/wiki/Variables#Local_Variables_Scope)

⚠

Local variables in [call](https://community.bistudio.com/wiki/call) code (e.g [Arma 3: Functions Library](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)) should be scoped using the [private](https://community.bistudio.com/wiki/private)/[privateAll](https://community.bistudio.com/wiki/privateAll) commands, otherwise you may modify local variables of the [call](https://community.bistudio.com/wiki/call) script that are visible in the function.

Copy code to clipboard

// Since Arma 3 v1.54 [private](https://community.bistudio.com/wiki/private) _myLocalVariable [=](https://community.bistudio.com/wiki/a_=_b) 0; // From Arma 2 until Arma 3 v1.54 [local](https://community.bistudio.com/wiki/local) _myLocalVariable [=](https://community.bistudio.com/wiki/a_=_b) 0; // Before Arma 2 [private](https://community.bistudio.com/wiki/private) "_myLocalVariable"; _myLocalVariable [=](https://community.bistudio.com/wiki/a_=_b) 0; // Alternative method to private multiple local variables at the same time [private](https://community.bistudio.com/wiki/private) ["_myLocalVariable1", "_myLocalVariable2"]; _myLocalVariable1 [=](https://community.bistudio.com/wiki/a_=_b) 1; _myLocalVariable2 [=](https://community.bistudio.com/wiki/a_=_b) 2;

If a [private](https://community.bistudio.com/wiki/private) variable is initialised within a [Control Structures](https://community.bistudio.com/wiki/Control_Structures) (i.e. [if](https://community.bistudio.com/wiki/if), [for](https://community.bistudio.com/wiki/for), [switch](https://community.bistudio.com/wiki/switch), [while](https://community.bistudio.com/wiki/while)), its existence will be limited to it and its sub-structures - the variable does not exist outside of the structure and will be seen as undefined.

| Variables lifespan | Variables lifespan | Variables lifespan | Variables lifespan | Variables lifespan | Variables lifespan | Variables lifespan | Variables lifespan | Variables lifespan | Code |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |  | **BEGINNING OF FILE** - e.g Copy code to clipboard[execVM](https://community.bistudio.com/wiki/execVM) "script.sqf"; |
|  |  |  |  |  |  |  |  |  | **TAG_GlobalVariable** = "Global variable"; // Global variable is accessible from any scope |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  | [private](https://community.bistudio.com/wiki/private) **_myVariable** = 0; |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  | [if](https://community.bistudio.com/wiki/if) (**_condition**) [then](https://community.bistudio.com/wiki/then) |  |  |  |  |  |  |  |
|  |  | { |  |  |  |  |  |  |  |
|  |  | **_myVariable** = 1; |  |  |  |  |  |  |  |
|  |  |  | [private](https://community.bistudio.com/wiki/private) **_myVariable** = 2; |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  | **_myVariable** = 3; |  |  |  |  |  |  |  |
|  |  |  | } [else](https://community.bistudio.com/wiki/else) { |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  | **_myVariable** = 4; |  |  |  |  |  |  |  |
|  |  | [private](https://community.bistudio.com/wiki/private) **_anotherVariable** = 10; |  |  |  |  |  |  |  |
|  |  | }; |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  | [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) **_myVariable**; // if **_condition** is [true](https://community.bistudio.com/wiki/true), **_myVariable'**s value is **1**; |  |  |  |  |  |  |  |
|  |  | // if **_condition** is [false](https://community.bistudio.com/wiki/false), **_myVariable'**s value is **4**. |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  | 0 [call](https://community.bistudio.com/wiki/call) { |  |  |  |  |  |  |  |
|  |  | [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) **_myVariable**; // works, as [call](https://community.bistudio.com/wiki/call) code runs in the same scope |  |  |  |  |  |  |  |
|  |  | }; |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  | [**_myVariable**] [spawn](https://community.bistudio.com/wiki/spawn) { |  |  |  |  |  |  |  |
|  |  |  | [hint](https://community.bistudio.com/wiki/hint) **TAG_GlobalVariable**; // works |  |  |  |  |  |  |
|  |  |  | [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) _myVariable; // throws an [Debugging Techniques](https://community.bistudio.com/wiki/Debugging_Techniques#Common_errors), |  |  |  |  |  |  |
|  |  |  | // as **_myVariable** does **not** exist in this new script |  |  |  |  |  |  |
|  |  |  | }; |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |
|  |  | // trying to use **_anotherVariable** here would result in an [Debugging Techniques](https://community.bistudio.com/wiki/Debugging_Techniques#Common_errors), |  |  |  |  |  |  |  |
|  |  | // **_anotherVariable** being only scoped in the [else](https://community.bistudio.com/wiki/else) block. |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  | **END OF FILE** - **TAG_GlobalVariable** keeps on living in [missionNamespace](https://community.bistudio.com/wiki/missionNamespace) |  |

| Correct | Incorrect |
| --- | --- |
| Copy code to clipboard [private](https://community.bistudio.com/wiki/private) _living [=](https://community.bistudio.com/wiki/a_=_b) [false](https://community.bistudio.com/wiki/false); [if](https://community.bistudio.com/wiki/if) ([alive](https://community.bistudio.com/wiki/alive) [player](https://community.bistudio.com/wiki/player)) [then](https://community.bistudio.com/wiki/then) { _living [=](https://community.bistudio.com/wiki/a_=_b) [true](https://community.bistudio.com/wiki/true); }; [hint](https://community.bistudio.com/wiki/hint) [format](https://community.bistudio.com/wiki/format) ["%1", _living]; // returns true | Copy code to clipboard // - [if](https://community.bistudio.com/wiki/if) ([alive](https://community.bistudio.com/wiki/alive) [player](https://community.bistudio.com/wiki/player)) [then](https://community.bistudio.com/wiki/then) { [private](https://community.bistudio.com/wiki/private) _living [=](https://community.bistudio.com/wiki/a_=_b) [true](https://community.bistudio.com/wiki/true); }; // throws an error since the private variable was // not initialised outside of the if control structure. [hint](https://community.bistudio.com/wiki/hint) [format](https://community.bistudio.com/wiki/format) ["%1", _living]; |

## Data Types[Link](https://community.bistudio.com/wiki/Variables#Data_Types)

Variables may store values of a certain [Category:Data Types](https://community.bistudio.com/wiki/Category:Data_Types) ([String](https://community.bistudio.com/wiki/String), [Number](https://community.bistudio.com/wiki/Number), etc). The kind of the value specifies the *type* of the variable. Different [Operators](https://community.bistudio.com/wiki/Operators) and [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands) require variables to be of different types.

A variable is not strongly typed and changes its type according to the new data:

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) "_myVariable"; // nil _myVariable [=](https://community.bistudio.com/wiki/a_=_b) 1; // 1 (Number) _myVariable [=](https://community.bistudio.com/wiki/a_=_b) "test"; // "test" (String)

## Multiplayer Considerations[Link](https://community.bistudio.com/wiki/Variables#Multiplayer_Considerations)

Storing functions (or any callable code) into global variables without securing them with [compileFinal](https://community.bistudio.com/wiki/compileFinal) (since Arma 3) is a **very** bad practice in multiplayer. The biggest security risk would be to see it being overridden by a malicious usage of [publicVariable](https://community.bistudio.com/wiki/publicVariable), setting potentially dangerous code in it.

The best option is to declare your function in [Arma 3: Functions Library](https://community.bistudio.com/wiki/Arma_3:_Functions_Library) so the engine secures it for you.

If you want to manually create a global function anyway, the best practice is the following:

Copy code to clipboard

TAG_MyGlobalVariableFunction [=](https://community.bistudio.com/wiki/a_=_b) [compileFinal](https://community.bistudio.com/wiki/compileFinal) [preprocessFileLineNumbers](https://community.bistudio.com/wiki/preprocessFileLineNumbers) "functionFile.sqf";

ⓘ

You should ideally run this code locally on every machine. Using [publicVariable](https://community.bistudio.com/wiki/publicVariable) on a "final" global function (created with [compileFinal](https://community.bistudio.com/wiki/compileFinal)) will indeed broadcast the variable **and** make it final on other clients as well, but the network can quickly become saturated from sending big pieces of code.

## See also[Link](https://community.bistudio.com/wiki/Variables#See_also)

- [Introduction to Arma Scripting](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting)
- [Identifier](https://community.bistudio.com/wiki/Identifier)
- [Category:Data Types](https://community.bistudio.com/wiki/Category:Data_Types)
- [Control Structures](https://community.bistudio.com/wiki/Control_Structures)
- [Magic Variables](https://community.bistudio.com/wiki/Magic_Variables)
- [private](https://community.bistudio.com/wiki/private)/[privateAll](https://community.bistudio.com/wiki/privateAll) (Arma 3)
- [local](https://community.bistudio.com/wiki/local) (Arma 2)

Retrieved from "[https://community.bistudio.com/wiki?title=Variables&oldid=376701](https://community.bistudio.com/wiki?title=Variables&oldid=376701)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Topics](https://community.bistudio.com/wiki/Category:Scripting_Topics)