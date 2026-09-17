# createMarker - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/createMarker#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

[Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00)[Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00)[Category:Introduced with Arma 2 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2_version_1.00)[Category:Introduced with Arma 2 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2_version_1.00)[Category:Introduced with Arma 2: Operation Arrowhead version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2:_Operation_Arrowhead_version_1.50)[Category:Introduced with Arma 2: Operation Arrowhead version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2:_Operation_Arrowhead_version_1.50)[Category:Introduced with Take On Helicopters version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Take_On_Helicopters_version_1.00)[Category:Introduced with Take On Helicopters version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Take_On_Helicopters_version_1.00)[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)

Hover & click on the images for description

### Description[Link](https://community.bistudio.com/wiki/createMarker#Description)

Description:
: Creates a new map marker at the given position. The marker will be created for every connected player as well as all JIP players. The marker name has to be unique; the command will be ignored if a marker with the given name already exists.

⚠

The marker will be visible only once at least

[markerType](https://community.bistudio.com/wiki/markerType)

has been defined:

Copy code to clipboard

_marker [=](https://community.bistudio.com/wiki/a_=_b) createMarker ["markername", [player](https://community.bistudio.com/wiki/player)]; // Not visible yet. _marker [setMarkerType](https://community.bistudio.com/wiki/setMarkerType) "hd_dot"; // Visible.

ⓘ

If the marker position is given in 3D format, the z-coordinate is stored with the marker and will be used when the marker is passed to commands such as [createVehicle](https://community.bistudio.com/wiki/createVehicle), [createUnit](https://community.bistudio.com/wiki/createUnit), [createAgent](https://community.bistudio.com/wiki/createAgent), [createMine](https://community.bistudio.com/wiki/createMine) or [setVehiclePosition](https://community.bistudio.com/wiki/setVehiclePosition).
When a marker is manually placed in the editor, z is always 0, which means the marker is placed on the ground. But when the player places a marker on the map in game, it is placed at sea level, so the z-coordinate of that marker is Copy code to clipboard[-](https://community.bistudio.com/wiki/-)[getTerrainHeightASL](https://community.bistudio.com/wiki/getTerrainHeightASL) [markerPos](https://community.bistudio.com/wiki/markerPos) "userMarker";.
Multiplayer:
: ⓘ

**Multiplayer optimisation:** Global marker commands always broadcast the *entire* marker state over the network. As such, the number of network messages exchanged when creating or editing a marker can be reduced by performing all but the last operation using local marker commands, then using a global marker command for the last change (and subsequent global broadcast of all changes applied to the marker).
Problems:
: [setMarkerDrawPriority](https://community.bistudio.com/wiki/setMarkerDrawPriority)

sorts

[allMapMarkers](https://community.bistudio.com/wiki/allMapMarkers)

from least to most priority. Before

[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)

createMarker

/

[createMarkerLocal](https://community.bistudio.com/wiki/createMarkerLocal)

did

**not**

care about drawing priority and added the created marker to the end of the array, making it top priority. Running

[setMarkerDrawPriority](https://community.bistudio.com/wiki/setMarkerDrawPriority)

again sorted this issue.
Groups:
: [Category:Command Group: Markers](https://community.bistudio.com/wiki/Category:Command_Group:_Markers)

### Syntax[Link](https://community.bistudio.com/wiki/createMarker#Syntax)

Syntax:
: createMarker

[name, position, channel, creator]
Parameters:
: name:

[String](https://community.bistudio.com/wiki/String)

- the marker's name, used to reference the marker in scripts.
: position:

[Position](https://community.bistudio.com/wiki/Position#Introduction)

,

[Position](https://community.bistudio.com/wiki/Position#PositionAGL)

or

[Object](https://community.bistudio.com/wiki/Object)

- In case of an object, the object's model [0,0,0] is used.
since [Category:Introduced with Arma 3 version 2.02](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.02)[Category:Introduced with Arma 3 version 2.02](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.02)
: channel:

[Number](https://community.bistudio.com/wiki/Number)

- (Optional, default -1) the marker channel - see

[Channel IDs](https://community.bistudio.com/wiki/Channel_IDs)

(for multiplayer)
since [Category:Introduced with Arma 3 version 2.02](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.02)[Category:Introduced with Arma 3 version 2.02](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.02)
: creator:

[Object](https://community.bistudio.com/wiki/Object)

- (Optional, default

[objNull](https://community.bistudio.com/wiki/objNull)

) the marker creator (for multiplayer)
Return Value:
: [String](https://community.bistudio.com/wiki/String)

- the marker's name or empty string if the marker name is not unique.

### Examples[Link](https://community.bistudio.com/wiki/createMarker#Examples)

Example 1:
: Copy code to clipboard

_marker1 [=](https://community.bistudio.com/wiki/a_=_b) createMarker ["Marker1", [position](https://community.bistudio.com/wiki/position) [player](https://community.bistudio.com/wiki/player)];
Example 2:
: Copy code to clipboard

_marker2 [=](https://community.bistudio.com/wiki/a_=_b) createMarker ["Marker2", [player](https://community.bistudio.com/wiki/player)]; // since Arma 3 1.50

### Additional Information[Link](https://community.bistudio.com/wiki/createMarker#Additional_Information)

See also:
: [createMarkerLocal](https://community.bistudio.com/wiki/createMarkerLocal)

[deleteMarker](https://community.bistudio.com/wiki/deleteMarker)

[BIS fnc markerToString](https://community.bistudio.com/wiki/BIS_fnc_markerToString)

[BIS fnc stringToMarker](https://community.bistudio.com/wiki/BIS_fnc_stringToMarker)

### Notes[Link](https://community.bistudio.com/wiki/createMarker#Notes)

: Report bugs on the

[Arma 3 Feedback Tracker](https://report.bistudio.com/projects/arma-3/general-arma-3)

and/or discuss them on the

[Arma Discord](https://discord.gg/arma)

.

**Only post proven facts here!**

[Add Note](https://community.bistudio.com/wiki?title=createMarker&action=edit&section=new&preload=Template:Preload/Base&preloadparams%5B%5D=%7B%7Bsubst%3APreload%2FNote%7C1%3D%0D%0A%3C%21--%0D%0A%2A%20Write%20your%20comment%20here%20%28remove%20both%20%22arrows%22%20top%20and%20bottom%29%0D%0A%2A%20Pipe%20signs%20%22%7C%22%20MUST%20be%20written%20%7B%7B%21%7D%7D%0D%0A%2A%20New%20lines%20can%20be%20forced%20with%20%3Cbr%3E%0D%0A%2A%20Please%20-PREVIEW%20YOUR%20ADDITION%20BEFORE%20SAVING-%0D%0A%0D%0A%2A%20Video%20Tutorial%3A%20https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DNtOl1gLz3Fo%0D%0A--%3E%0D%0A%7D%7D&preloadtitle=&summary=New+note&nosummary=true)

[User:Soldia (page does not exist)](https://community.bistudio.com/wiki?title=User:Soldia&action=edit&redlink=1) - [Special:Contributions/Soldia](https://community.bistudio.com/wiki/Special:Contributions/Soldia)
: Posted on Sep 19, 2015 - 21:02 (UTC)

[§](https://community.bistudio.com/wiki/createMarker#usernote20150919210200)
: [Category:Introduced with Arma 3 version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.50)[Category:Introduced with Arma 3 version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.50)

createMarker accepts an object as position parameter as well . You could try this with the following code (both SP/MP)

Copy code to clipboard

_markerstr [=](https://community.bistudio.com/wiki/a_=_b) createMarker ["markername", [player](https://community.bistudio.com/wiki/player)]; _markerstr [setMarkerShape](https://community.bistudio.com/wiki/setMarkerShape) "RECTANGLE"; _markerstr [setMarkerSize](https://community.bistudio.com/wiki/setMarkerSize) [100, 100];

[User:X39](https://community.bistudio.com/wiki/User:X39) - [Special:Contributions/X39](https://community.bistudio.com/wiki/Special:Contributions/X39)
: Posted on May 28, 2018 - 11:57 (UTC)

[§](https://community.bistudio.com/wiki/createMarker#usernote20180528115700)
: In Arma 3, one can create markers which are deletable by the user by prefixing the name with

_USER_DEFINED

. Example:

Copy code to clipboard

createMarker "_USER_DEFINED someMarkerName"

[User:7erra](https://community.bistudio.com/wiki/User:7erra) - [Special:Contributions/7erra](https://community.bistudio.com/wiki/Special:Contributions/7erra)
: Posted on May 03, 2019 - 15:53 (UTC)

[§](https://community.bistudio.com/wiki/createMarker#usernote20190503155300)
: [Category:Introduced with Arma 3 version 1.92](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.92)[Category:Introduced with Arma 3 version 1.92](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.92)

There is a new function with which you can create a marker with all settings applied in one step: [BIS fnc stringToMarker](https://community.bistudio.com/wiki/BIS_fnc_stringToMarker) and [BIS fnc stringToMarkerLocal](https://community.bistudio.com/wiki/BIS_fnc_stringToMarkerLocal)

[User:Tirpitz](https://community.bistudio.com/wiki/User:Tirpitz) - [Special:Contributions/Tirpitz](https://community.bistudio.com/wiki/Special:Contributions/Tirpitz)
: Posted on Jan 26, 2021 - 22:42 (UTC)

[§](https://community.bistudio.com/wiki/createMarker#usernote20210126224200)
: When creating a marker with the name format: "_USER_DEFINED #n1/n2/n3". n1 can be used to set the owner, n2 I think is an incrementing index to ensure markers are unique, to this end also mangle some more characters onto the end of the string, and n3 is the channel ID the marker is in.

Copy code to clipboard

_markerName [=](https://community.bistudio.com/wiki/a_=_b) [format](https://community.bistudio.com/wiki/format) ["_USER_DEFINED #%1/%2/%3" , [clientOwner](https://community.bistudio.com/wiki/clientOwner),_index, _ChannelID]; _marker [=](https://community.bistudio.com/wiki/a_=_b) [createMarkerLocal](https://community.bistudio.com/wiki/createMarkerLocal) [_markerName, _pos];

[User:POLPOX](https://community.bistudio.com/wiki/User:POLPOX) - [Special:Contributions/POLPOX](https://community.bistudio.com/wiki/Special:Contributions/POLPOX)
: Posted on Jul 08, 2023 - 16:03 (UTC)

[§](https://community.bistudio.com/wiki/createMarker#usernote20230708160357)
: If you use the letter "/" in the name, it may break the channel visibilities (especially in MP). Possible reason is described above by Tirpitz, the engine may confuse which channel the marker belongs to after the "/".

[User:Leopard20](https://community.bistudio.com/wiki/User:Leopard20) - [Special:Contributions/Leopard20](https://community.bistudio.com/wiki/Special:Contributions/Leopard20)
: Posted on Jul 21, 2026 - 08:47 (UTC)

[§](https://community.bistudio.com/wiki/createMarker#usernote20260721084729)
: You can use a helper function if you intend to call createMarker with duplicate marker names. It doesn't necessarily guarantee that the marker has been created (e.g. it could fail not due to duplicate name, but due to maximum number of allowed markers reached)

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _fnc_createMarkerSafe [=](https://community.bistudio.com/wiki/a_=_b) { [private](https://community.bistudio.com/wiki/private) _marker [=](https://community.bistudio.com/wiki/a_=_b) [_this](https://community.bistudio.com/wiki/Magic_Variables#this)[#](https://community.bistudio.com/wiki/a_hash_b)0; createMarker [_this](https://community.bistudio.com/wiki/Magic_Variables#this); _marker }; [private](https://community.bistudio.com/wiki/private) _marker [=](https://community.bistudio.com/wiki/a_=_b) ["MyMarker", [0,0]] [call](https://community.bistudio.com/wiki/call) _fnc_createMarkerSafe; // will return "MyMarker"

Retrieved from "[https://community.bistudio.com/wiki?title=createMarker&oldid=378854](https://community.bistudio.com/wiki?title=createMarker&oldid=378854)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00)
- [Category:ArmA: Armed Assault: New Scripting Commands](https://community.bistudio.com/wiki/Category:ArmA:_Armed_Assault:_New_Scripting_Commands)
- [Category:ArmA: Armed Assault: Scripting Commands](https://community.bistudio.com/wiki/Category:ArmA:_Armed_Assault:_Scripting_Commands)
- [Category:Arma 2: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_2:_Scripting_Commands)
- [Category:Arma 2: Operation Arrowhead: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_2:_Operation_Arrowhead:_Scripting_Commands)
- [Category:Take On Helicopters: Scripting Commands](https://community.bistudio.com/wiki/Category:Take_On_Helicopters:_Scripting_Commands)
- [Category:Arma 3: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands)
- [Category:Command Group: Markers](https://community.bistudio.com/wiki/Category:Command_Group:_Markers)
- [Category:Scripting Commands: Global Effect](https://community.bistudio.com/wiki/Category:Scripting_Commands:_Global_Effect)

Hidden category:

- [Category:Maintenance/RV](https://community.bistudio.com/wiki/Category:Maintenance/RV)