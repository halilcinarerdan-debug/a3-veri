# waypoints - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/waypoints#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

[Category:Introduced with Armed Assault version 1.05](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.05)[Category:Introduced with Armed Assault version 1.05](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.05)[Category:Introduced with Arma 2 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2_version_1.00)[Category:Introduced with Arma 2 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2_version_1.00)[Category:Introduced with Arma 2: Operation Arrowhead version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2:_Operation_Arrowhead_version_1.50)[Category:Introduced with Arma 2: Operation Arrowhead version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2:_Operation_Arrowhead_version_1.50)[Category:Introduced with Take On Helicopters version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Take_On_Helicopters_version_1.00)[Category:Introduced with Take On Helicopters version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Take_On_Helicopters_version_1.00)[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)

Hover & click on the images for description

### Description[Link](https://community.bistudio.com/wiki/waypoints#Description)

Description:
: Returns an array of waypoints for the specified unit/group.
Groups:
: [Category:Command Group: Waypoints](https://community.bistudio.com/wiki/Category:Command_Group:_Waypoints)

### Syntax[Link](https://community.bistudio.com/wiki/waypoints#Syntax)

Syntax:
: waypoints

groupName
Parameters:
: groupName:

[Group](https://community.bistudio.com/wiki/Group)

or

[Object](https://community.bistudio.com/wiki/Object)
Return Value:
: [Array](https://community.bistudio.com/wiki/Array)

of

[Waypoint](https://community.bistudio.com/wiki/Waypoint)

### Examples[Link](https://community.bistudio.com/wiki/waypoints#Examples)

Example 1:
: Copy code to clipboard

waypoints [player](https://community.bistudio.com/wiki/player);
Example 2:
: Copy code to clipboard

_wPosArray [=](https://community.bistudio.com/wiki/a_=_b) waypoints group10; // returns e.g [[EAST 1-1-A,0],[EAST 1-1-A,1],[EAST 1-1-A,2]]

### Additional Information[Link](https://community.bistudio.com/wiki/waypoints#Additional_Information)

See also:
: [deleteWaypoint](https://community.bistudio.com/wiki/deleteWaypoint)

[copyWaypoints](https://community.bistudio.com/wiki/copyWaypoints)

[setCurrentWaypoint](https://community.bistudio.com/wiki/setCurrentWaypoint)

[setWaypointBehaviour](https://community.bistudio.com/wiki/setWaypointBehaviour)

[setWaypointCombatMode](https://community.bistudio.com/wiki/setWaypointCombatMode)

[setWaypointCompletionRadius](https://community.bistudio.com/wiki/setWaypointCompletionRadius)

[setWaypointDescription](https://community.bistudio.com/wiki/setWaypointDescription)

[setWaypointFormation](https://community.bistudio.com/wiki/setWaypointFormation)

[setWaypointHousePosition](https://community.bistudio.com/wiki/setWaypointHousePosition)

[setWaypointPosition](https://community.bistudio.com/wiki/setWaypointPosition)

[setWaypointScript](https://community.bistudio.com/wiki/setWaypointScript)

[setWaypointSpeed](https://community.bistudio.com/wiki/setWaypointSpeed)

[setWaypointStatements](https://community.bistudio.com/wiki/setWaypointStatements)

[setWaypointTimeout](https://community.bistudio.com/wiki/setWaypointTimeout)

[setWaypointType](https://community.bistudio.com/wiki/setWaypointType)

[setWaypointVisible](https://community.bistudio.com/wiki/setWaypointVisible)

[waypointAttachVehicle](https://community.bistudio.com/wiki/waypointAttachVehicle)

[waypointAttachedVehicle](https://community.bistudio.com/wiki/waypointAttachedVehicle)

[setWaypointLoiterRadius](https://community.bistudio.com/wiki/setWaypointLoiterRadius)

[waypointLoiterRadius](https://community.bistudio.com/wiki/waypointLoiterRadius)

[addWaypoint](https://community.bistudio.com/wiki/addWaypoint)

[setWaypointLoiterType](https://community.bistudio.com/wiki/setWaypointLoiterType)

[waypointSpeed](https://community.bistudio.com/wiki/waypointSpeed)

[setWPPos](https://community.bistudio.com/wiki/setWPPos)

[waypointName](https://community.bistudio.com/wiki/waypointName)

### Notes[Link](https://community.bistudio.com/wiki/waypoints#Notes)

: Report bugs on the

[Arma 3 Feedback Tracker](https://report.bistudio.com/projects/arma-3/general-arma-3)

and/or discuss them on the

[Arma Discord](https://discord.gg/arma)

.

**Only post proven facts here!**

[Add Note](https://community.bistudio.com/wiki?title=waypoints&action=edit&section=new&preload=Template:Preload/Base&preloadparams%5B%5D=%7B%7Bsubst%3APreload%2FNote%7C1%3D%0D%0A%3C%21--%0D%0A%2A%20Write%20your%20comment%20here%20%28remove%20both%20%22arrows%22%20top%20and%20bottom%29%0D%0A%2A%20Pipe%20signs%20%22%7C%22%20MUST%20be%20written%20%7B%7B%21%7D%7D%0D%0A%2A%20New%20lines%20can%20be%20forced%20with%20%3Cbr%3E%0D%0A%2A%20Please%20-PREVIEW%20YOUR%20ADDITION%20BEFORE%20SAVING-%0D%0A%0D%0A%2A%20Video%20Tutorial%3A%20https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DNtOl1gLz3Fo%0D%0A--%3E%0D%0A%7D%7D&preloadtitle=&summary=New+note&nosummary=true)

Retrieved from "[https://community.bistudio.com/wiki?title=waypoints&oldid=347556](https://community.bistudio.com/wiki?title=waypoints&oldid=347556)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [Category:Introduced with Armed Assault version 1.05](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.05)
- [Category:ArmA: Armed Assault: New Scripting Commands](https://community.bistudio.com/wiki/Category:ArmA:_Armed_Assault:_New_Scripting_Commands)
- [Category:ArmA: Armed Assault: Scripting Commands](https://community.bistudio.com/wiki/Category:ArmA:_Armed_Assault:_Scripting_Commands)
- [Category:Arma 2: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_2:_Scripting_Commands)
- [Category:Arma 2: Operation Arrowhead: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_2:_Operation_Arrowhead:_Scripting_Commands)
- [Category:Take On Helicopters: Scripting Commands](https://community.bistudio.com/wiki/Category:Take_On_Helicopters:_Scripting_Commands)
- [Category:Arma 3: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands)
- [Category:Command Group: Waypoints](https://community.bistudio.com/wiki/Category:Command_Group:_Waypoints)

Hidden category:

- [Category:Maintenance/RV](https://community.bistudio.com/wiki/Category:Maintenance/RV)