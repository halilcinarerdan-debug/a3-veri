# createUnit - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/createUnit#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

[Category:Introduced with Operation Flashpoint version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Operation_Flashpoint_version_1.34)[Category:Introduced with Operation Flashpoint version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Operation_Flashpoint_version_1.34)[Category:Introduced with Operation Flashpoint: Elite version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Operation_Flashpoint:_Elite_version_1.00)[Category:Introduced with Operation Flashpoint: Elite version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Operation_Flashpoint:_Elite_version_1.00)[Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00)[Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00)[Category:Introduced with Arma 2 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2_version_1.00)[Category:Introduced with Arma 2 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2_version_1.00)[Category:Introduced with Arma 2: Operation Arrowhead version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2:_Operation_Arrowhead_version_1.50)[Category:Introduced with Arma 2: Operation Arrowhead version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2:_Operation_Arrowhead_version_1.50)[Category:Introduced with Take On Helicopters version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Take_On_Helicopters_version_1.00)[Category:Introduced with Take On Helicopters version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Take_On_Helicopters_version_1.00)[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)

Hover & click on the images for description

### Description[Link](https://community.bistudio.com/wiki/createUnit#Description)

Description:
: Create a unit of the provided

[Category:CfgVehicles](https://community.bistudio.com/wiki/Category:CfgVehicles)

class.

⚠

The unit will not be created if the passed group does not exist (a.k.a [grpNull](https://community.bistudio.com/wiki/grpNull)); this can happen if [createGroup](https://community.bistudio.com/wiki/createGroup) fails because the **group limit has been reached** (see [createGroup](https://community.bistudio.com/wiki/createGroup) for respective game limits).

|  | [Syntax 1](https://community.bistudio.com/wiki/createUnit#Syntax_1) | [Syntax 2](https://community.bistudio.com/wiki/createUnit#Syntax_2) |
| --- | --- | --- |
| Group's locality | the provided group *can* be non-[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality), but a warning will be logged | the provided group **must** be [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality) |
| Unit's [side](https://community.bistudio.com/wiki/side) | using a classname from a different side than the provided group will result in the unit itself being of a (config-defined) side inside a group of another side - see [Example 6](https://community.bistudio.com/wiki/createUnit#Example_6) for more information | using a classname from a different side than the provided group will result in the unit being of the same side as the provided group |
| Other | the unit's init code will execute after a slight delay if the provided group is not local | this syntax does **not** return a reference to the created unit (see [Example 7](https://community.bistudio.com/wiki/createUnit#Example_7)) |

[Armed Assault](https://community.bistudio.com/wiki/Category:ArmA:_Armed_Assault)

[Category:Introduced with Operation Flashpoint version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Operation_Flashpoint_version_1.34)[Category:Introduced with Operation Flashpoint version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Operation_Flashpoint_version_1.34) [Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00)[Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00) This command was sometimes bugged in Operation Flashpoint or Armed Assault; an additional [join](https://community.bistudio.com/wiki/join) may solve the problem.
 However, some commands such as [setUnitPos](https://community.bistudio.com/wiki/setUnitPos) only work if run before the [join](https://community.bistudio.com/wiki/join).
Multiplayer:
: It is recommended to create the unit where the group is

**[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)**

- use

[remoteExec](https://community.bistudio.com/wiki/remoteExec)

if needed.
Groups:
: [Category:Command Group: Object Manipulation](https://community.bistudio.com/wiki/Category:Command_Group:_Object_Manipulation)

### Syntax[Link](https://community.bistudio.com/wiki/createUnit#Syntax)

Syntax:
: group

createUnit

[type, position, markers, placement, special]
Parameters:
: group:

[Group](https://community.bistudio.com/wiki/Group)

- existing group new unit will join; if the group is not

[local](https://community.bistudio.com/wiki/local)

, a warning will be logged
: type:

[String](https://community.bistudio.com/wiki/String)

- classname of unit to be created as per

[CfgVehicles](https://community.bistudio.com/wiki/CfgVehicles)
: position:

[Object](https://community.bistudio.com/wiki/Object)

,

[Group](https://community.bistudio.com/wiki/Group)

or

[Position](https://community.bistudio.com/wiki/Position)

or

[Position](https://community.bistudio.com/wiki/Position#Introduction)

- location where to create the unit. In case of

[Group](https://community.bistudio.com/wiki/Group)

, the

[group](https://community.bistudio.com/wiki/group)

[leader](https://community.bistudio.com/wiki/leader)

's position is used. The Z component of the position is ignored and the unit is always placed on the surface.
: markers:

[Array](https://community.bistudio.com/wiki/Array)

- placement markers
: placement:

[Number](https://community.bistudio.com/wiki/Number)

- placement radius
: special:

[String](https://community.bistudio.com/wiki/String)

- unit placement special, one of:

- "NONE" - The unit will be created at the first available free position nearest to given position
- "FORM" - Not implemented, currently functions the same as "NONE"
- "CAN_COLLIDE" - The unit will be created exactly at the provided position
- "CARGO" - The unit will be created in cargo of the group's vehicle, regardless of the passed position (see [Example 5](https://community.bistudio.com/wiki/createUnit#Example_5)). If group has no vehicle or there is no cargo space available, the unit will be placed according to "NONE". "CARGO" placement excludes cargo positions with personal FFV turrets. To check available cargo space use:

| [Category:Introduced with Arma 3 version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.34)[Category:Introduced with Arma 3 version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.34) FFV | Copy code to clipboard [private](https://community.bistudio.com/wiki/private) _hasCargo [=](https://community.bistudio.com/wiki/a_=_b) { [isNull](https://community.bistudio.com/wiki/isNull) ([_x](https://community.bistudio.com/wiki/Magic_Variables#x) [select](https://community.bistudio.com/wiki/select) 0) } [count](https://community.bistudio.com/wiki/count) ([fullCrew](https://community.bistudio.com/wiki/fullCrew) [_veh, "cargo", [true](https://community.bistudio.com/wiki/true)]) [>](https://community.bistudio.com/wiki/a_greater_b) 0; |
| --- | --- |
| before | Copy code to clipboard _hasCargo [=](https://community.bistudio.com/wiki/a_=_b) _veh [emptyPositions](https://community.bistudio.com/wiki/emptyPositions) "CARGO" [>](https://community.bistudio.com/wiki/a_greater_b) 0; |
Return Value:
: [Object](https://community.bistudio.com/wiki/Object)

- the created unit

### Alternative Syntax[Link](https://community.bistudio.com/wiki/createUnit#Alternative_Syntax)

Syntax:
: type

createUnit

[position, group, init, skill, rank]
Parameters:
: type:

[String](https://community.bistudio.com/wiki/String)

- classname of unit to be created as per

[CfgVehicles](https://community.bistudio.com/wiki/CfgVehicles)
: position:

[Object](https://community.bistudio.com/wiki/Object)

,

[Group](https://community.bistudio.com/wiki/Group)

or

[Position](https://community.bistudio.com/wiki/Position)

or

[Position](https://community.bistudio.com/wiki/Position#Introduction)

- location at which the unit is created. In case of

[Group](https://community.bistudio.com/wiki/Group)

position of the

[group](https://community.bistudio.com/wiki/group)

[leader](https://community.bistudio.com/wiki/leader)

is used
: group:

[Group](https://community.bistudio.com/wiki/Group)

- existing group the new unit will join
: init:

[String](https://community.bistudio.com/wiki/String)

- (Optional, default "") unit init statement, similar to unit init field in the editor. The code placed in unit init will run upon unit creation for every client on network, present and future. The code itself receives the reference to the created unit via local variable

[Magic Variables](https://community.bistudio.com/wiki/Magic_Variables#this_2)

.

⚠

- Do not use global effect commands in a unit's *init* as it runs on every client (local effect ones are OK, e.g [setIdentity](https://community.bistudio.com/wiki/setIdentity)).
- Do not use local variables inside the init code as they are not available in multiplayer.
: skill:

[Number](https://community.bistudio.com/wiki/Number)

- (Optional, default 0.5) unit

[skill](https://community.bistudio.com/wiki/skill)
: rank:

[String](https://community.bistudio.com/wiki/String)

- (Optional, default "PRIVATE") unit

[rank](https://community.bistudio.com/wiki/rank)
Return Value:
: ⚠

**[Nothing](https://community.bistudio.com/wiki/Nothing)** - this syntax does **not** return a unit reference! See [Example 7](https://community.bistudio.com/wiki/createUnit#Example_7) for a workaround.

### Examples[Link](https://community.bistudio.com/wiki/createUnit#Examples)

Example 1:
: Copy code to clipboard

_unit [=](https://community.bistudio.com/wiki/a_=_b) [group](https://community.bistudio.com/wiki/group) [player](https://community.bistudio.com/wiki/player) createUnit ["B_RangeMaster_F", [position](https://community.bistudio.com/wiki/position) [player](https://community.bistudio.com/wiki/player), [], 0, "NONE"];
Example 2:
: Copy code to clipboard

"B_RangeMaster_F" createUnit [[position](https://community.bistudio.com/wiki/position) [player](https://community.bistudio.com/wiki/player), [group](https://community.bistudio.com/wiki/group) [player](https://community.bistudio.com/wiki/player)];
Example 3:
: Copy code to clipboard

"B_RangeMaster_F" createUnit [[getMarkerPos](https://community.bistudio.com/wiki/getMarkerPos) "barracks", _groupAlpha];
Example 4:
: Copy code to clipboard

"B_RangeMaster_F" createUnit [ [getMarkerPos](https://community.bistudio.com/wiki/getMarkerPos) "marker_1", _groupAlpha, "loon1 = this; this addWeapon 'BAF_L85A2_RIS_SUSAT'", 0.6, "corporal" ];
Example 5:
: Copy code to clipboard

_veh [=](https://community.bistudio.com/wiki/a_=_b) "O_Quadbike_01_F" [createVehicle](https://community.bistudio.com/wiki/createVehicle) ([player](https://community.bistudio.com/wiki/player) [getRelPos](https://community.bistudio.com/wiki/getRelPos) [10, 0]); _grp [=](https://community.bistudio.com/wiki/a_=_b) [createVehicleCrew](https://community.bistudio.com/wiki/createVehicleCrew) _veh; _unit [=](https://community.bistudio.com/wiki/a_=_b) _grp createUnit [[typeOf](https://community.bistudio.com/wiki/typeOf) [driver](https://community.bistudio.com/wiki/driver) _veh, _grp, [], 0, "CARGO"];
Example 6:
: Creating a unit from a different side may lead to issues:

Copy code to clipboard

_grp [=](https://community.bistudio.com/wiki/a_=_b) [createGroup](https://community.bistudio.com/wiki/createGroup) [east](https://community.bistudio.com/wiki/east); [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) [side](https://community.bistudio.com/wiki/side) _grp; // EAST _ap [=](https://community.bistudio.com/wiki/a_=_b) _grp createUnit ["C_man_p_beggar_F", [position](https://community.bistudio.com/wiki/position) [player](https://community.bistudio.com/wiki/player), [], 0, "NONE"]; [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) [side](https://community.bistudio.com/wiki/side) _ap; // CIV, not EAST // workaround [_ap] [joinSilent](https://community.bistudio.com/wiki/joinSilent) _grp; [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) [side](https://community.bistudio.com/wiki/side) _ap; // EAST
Example 7:
: Reference the created unit through a global variable:

Copy code to clipboard

_myUnit [=](https://community.bistudio.com/wiki/a_=_b) "B_RangeMaster_F" createUnit [[position](https://community.bistudio.com/wiki/position) [player](https://community.bistudio.com/wiki/player), [group](https://community.bistudio.com/wiki/group) [player](https://community.bistudio.com/wiki/player)]; // wrong - this syntax does not return a reference "B_RangeMaster_F" createUnit [[position](https://community.bistudio.com/wiki/position) [player](https://community.bistudio.com/wiki/player), [group](https://community.bistudio.com/wiki/group) [player](https://community.bistudio.com/wiki/player), "myUnit = this"]; // correct - the unit is myUnit (NOT _myUnit!)

### Additional Information[Link](https://community.bistudio.com/wiki/createUnit#Additional_Information)

See also:
: [createCenter](https://community.bistudio.com/wiki/createCenter)

[createGroup](https://community.bistudio.com/wiki/createGroup)

[createVehicle](https://community.bistudio.com/wiki/createVehicle)

[setVehiclePosition](https://community.bistudio.com/wiki/setVehiclePosition)

[create3DENEntity](https://community.bistudio.com/wiki/create3DENEntity)

### Notes[Link](https://community.bistudio.com/wiki/createUnit#Notes)

: Report bugs on the

[Arma 3 Feedback Tracker](https://report.bistudio.com/projects/arma-3/general-arma-3)

and/or discuss them on the

[Arma Discord](https://discord.gg/arma)

.

**Only post proven facts here!**

[Add Note](https://community.bistudio.com/wiki?title=createUnit&action=edit&section=new&preload=Template:Preload/Base&preloadparams%5B%5D=%7B%7Bsubst%3APreload%2FNote%7C1%3D%0D%0A%3C%21--%0D%0A%2A%20Write%20your%20comment%20here%20%28remove%20both%20%22arrows%22%20top%20and%20bottom%29%0D%0A%2A%20Pipe%20signs%20%22%7C%22%20MUST%20be%20written%20%7B%7B%21%7D%7D%0D%0A%2A%20New%20lines%20can%20be%20forced%20with%20%3Cbr%3E%0D%0A%2A%20Please%20-PREVIEW%20YOUR%20ADDITION%20BEFORE%20SAVING-%0D%0A%0D%0A%2A%20Video%20Tutorial%3A%20https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DNtOl1gLz3Fo%0D%0A--%3E%0D%0A%7D%7D&preloadtitle=&summary=New+note&nosummary=true)

[User:OOKexOo](https://community.bistudio.com/wiki/User:OOKexOo) - [Special:Contributions/oOKexOo](https://community.bistudio.com/wiki/Special:Contributions/oOKexOo)
: Posted on Dec 08, 2018 - 21:57 (UTC)

[§](https://community.bistudio.com/wiki/createUnit#usernote20181208215700)
: Since

[Category:Introduced with Arma 3 version 1.86](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.86)[Category:Introduced with Arma 3 version 1.86](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.86)

: If you want to place a module with

createUnit

, you have to ensure that the module gets activated automatically by setting

**[BIS fnc initModules](https://community.bistudio.com/wiki/BIS_fnc_initModules)_disableAutoActivation**

to

[false](https://community.bistudio.com/wiki/false)

,

*e.g*

:

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _grp [=](https://community.bistudio.com/wiki/a_=_b) [createGroup](https://community.bistudio.com/wiki/createGroup) [sideLogic](https://community.bistudio.com/wiki/sideLogic); "ModuleSmokeWhite_F" createUnit [ [getPos](https://community.bistudio.com/wiki/getPos) [player](https://community.bistudio.com/wiki/player), _grp, "this setVariable ['BIS_fnc_initModules_disableAutoActivation', false, true];" ];

[User:Killzone Kid](https://community.bistudio.com/wiki/User:Killzone_Kid) - [Special:Contributions/Killzone Kid](https://community.bistudio.com/wiki/Special:Contributions/Killzone_Kid)
: Posted on Mar 18, 2019 - 19:31 (UTC)

[§](https://community.bistudio.com/wiki/createUnit#usernote20190318193100)
: Alt Syntax is the older syntax and differs in functionality from the main, newer syntax. The main difference is that the older syntax

**does not**

return unit reference. This is because the unit created with Alt Syntax is created strictly where passed

[group](https://community.bistudio.com/wiki/group)

is

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)

. This means that if the group is remote the unit will be created on the different client than the one the command was executed on and therefore it is not possible to return created unit reference immediately. In contrast, the newer syntax allows creating units in remote groups while returning unit reference immediately, which could be unsafe and the appropriate warning is logged into

*.rpt*

file:

Warning: Adding units to a remote group is not safe. Please use [setGroupOwner](https://community.bistudio.com/wiki/setGroupOwner) to change the group owner first.

Another very important difference is that the older syntax (Alt Syntax) will create unit of the same

[side](https://community.bistudio.com/wiki/side)

as the side of the

[group](https://community.bistudio.com/wiki/group)

passed as argument. For example, if the group is WEST and the unit faction is OPFOR of type, say

"O_Soldier_GL_F"

, the unit created will be on the WEST side as well. In contrast, newer syntax will create the same unit on the EAST side in the WEST group, which will be treated as hostile by other group members and eliminated.

⚠

Beware that in MP if unit is created in remote group with older syntax, the unit init will execute on calling client sometime in the future, after the unit is created on remote client, therefore the following code will fail:

Copy code to clipboard

// real example of the bad code "O_Soldier_AR_F" createUnit [[position](https://community.bistudio.com/wiki/position) [player](https://community.bistudio.com/wiki/player), someRemoteGroup, "thisUnit = this"]; [publicVariable](https://community.bistudio.com/wiki/publicVariable) "thisUnit"; [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) [isNil](https://community.bistudio.com/wiki/isNil) "thisUnit"; // true! // the unit reference is nil because init statement has not been executed on this client yet

[User:Fusselwurm](https://community.bistudio.com/wiki/User:Fusselwurm) - [Special:Contributions/fusselwurm](https://community.bistudio.com/wiki/Special:Contributions/fusselwurm)
: Posted on Jun 19, 2020 - 10:13 (UTC)

[§](https://community.bistudio.com/wiki/createUnit#usernote20200619101300)
: [Category:Introduced with Arma 3 version 1.98](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.98)[Category:Introduced with Arma 3 version 1.98](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.98)

note that even when setting the

*placement special*

parameter to "NONE", 3DEN-placed objects are being ignored when looking for a free position. In other words: units will spawn within editor-placed rocks or under houses.

Retrieved from "[https://community.bistudio.com/wiki?title=createUnit&oldid=377516](https://community.bistudio.com/wiki?title=createUnit&oldid=377516)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [Category:Introduced with Operation Flashpoint version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Operation_Flashpoint_version_1.34)
- [Category:Operation Flashpoint: New Scripting Commands](https://community.bistudio.com/wiki/Category:Operation_Flashpoint:_New_Scripting_Commands)
- [Category:Operation Flashpoint: Scripting Commands](https://community.bistudio.com/wiki/Category:Operation_Flashpoint:_Scripting_Commands)
- [Category:Operation Flashpoint: Elite: Scripting Commands](https://community.bistudio.com/wiki/Category:Operation_Flashpoint:_Elite:_Scripting_Commands)
- [Category:ArmA: Armed Assault: Scripting Commands](https://community.bistudio.com/wiki/Category:ArmA:_Armed_Assault:_Scripting_Commands)
- [Category:Arma 2: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_2:_Scripting_Commands)
- [Category:Arma 2: Operation Arrowhead: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_2:_Operation_Arrowhead:_Scripting_Commands)
- [Category:Take On Helicopters: Scripting Commands](https://community.bistudio.com/wiki/Category:Take_On_Helicopters:_Scripting_Commands)
- [Category:Arma 3: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands)
- [Category:Command Group: Object Manipulation](https://community.bistudio.com/wiki/Category:Command_Group:_Object_Manipulation)
- [Category:Scripting Commands: Global Effect](https://community.bistudio.com/wiki/Category:Scripting_Commands:_Global_Effect)

Hidden category:

- [Category:Maintenance/RV](https://community.bistudio.com/wiki/Category:Maintenance/RV)