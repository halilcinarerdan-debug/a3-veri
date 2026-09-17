# targets - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/targets#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

[Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70)[Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)

Hover & click on the images for description

### Description[Link](https://community.bistudio.com/wiki/targets#Description)

Description:
: Retrieves list of given unit targets matching specified filter. If the filter is not specified, all targets are returned.

ⓘ

If a unit is provided, the unit itself will be excluded from results. If a group is provided, its units will be excluded (even if renegades).
Groups:
: [Category:Command Group: Object Detection](https://community.bistudio.com/wiki/Category:Command_Group:_Object_Detection)

### Syntax[Link](https://community.bistudio.com/wiki/targets#Syntax)

Syntax:
: unitOrGroup

targets

[enemyOnly, maxDistance, sides, maxAge, alternateCenter]
Parameters:
: unitOrGroup:

[Object](https://community.bistudio.com/wiki/Object)

or

[Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12)[Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12)

[Group](https://community.bistudio.com/wiki/Group)

- unit or group which target knowledge is retrieved
: enemyOnly:

[Boolean](https://community.bistudio.com/wiki/Boolean)

- (Optional, default

[false](https://community.bistudio.com/wiki/false)

)

[true](https://community.bistudio.com/wiki/true)

to include only enemy targets,

[false](https://community.bistudio.com/wiki/false)

to include all targets
: maxDistance:

[Number](https://community.bistudio.com/wiki/Number)

- (Optional, default -1) maximum

**2D**

distance based on target's expected position; use 0 to ignore the filter
: sides:

[Array](https://community.bistudio.com/wiki/Array)

of

[Side](https://community.bistudio.com/wiki/Side)

- (Optional, default

[]

) array of accepted sides; use

[]

to ignore the side filter
: maxAge:

[Number](https://community.bistudio.com/wiki/Number)

- (Optional, default 0) max. target age, targets that are known to unit for longer than maxAge are ignored; use 0 to ignore the maxAge filter
: alternateCenter:

[Array](https://community.bistudio.com/wiki/Array)

- (Optional, default

*unitOrGroup*

's position) alternate (2D or 3D) position used for

**2D**

distance check
Return Value:
: [Array](https://community.bistudio.com/wiki/Array)

-

*unitOrGroup*

's targets matching the criteria

### Examples[Link](https://community.bistudio.com/wiki/targets#Examples)

Example 1:
: Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _targets [=](https://community.bistudio.com/wiki/a_=_b) _unit targets [[false](https://community.bistudio.com/wiki/false), 300, [[east](https://community.bistudio.com/wiki/east), [sideEnemy](https://community.bistudio.com/wiki/sideEnemy)]]; // all targets of east or renegade side in 300m
Example 2:
: Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _targets [=](https://community.bistudio.com/wiki/a_=_b) _unit targets [[true](https://community.bistudio.com/wiki/true), 300]; // enemy targets in 300m
Example 3:
: Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _targets [=](https://community.bistudio.com/wiki/a_=_b) _unit targets []; // all targets

### Additional Information[Link](https://community.bistudio.com/wiki/targets#Additional_Information)

See also:
: [targetsQuery](https://community.bistudio.com/wiki/targetsQuery)

[nearTargets](https://community.bistudio.com/wiki/nearTargets)

[targetsAggregate](https://community.bistudio.com/wiki/targetsAggregate)

[targetKnowledge](https://community.bistudio.com/wiki/targetKnowledge)

[knowsAbout](https://community.bistudio.com/wiki/knowsAbout)

[reveal](https://community.bistudio.com/wiki/reveal)

[forgetTarget](https://community.bistudio.com/wiki/forgetTarget)

[setTargetAge](https://community.bistudio.com/wiki/setTargetAge)

[getHideFrom](https://community.bistudio.com/wiki/getHideFrom)

[side](https://community.bistudio.com/wiki/side)

### Notes[Link](https://community.bistudio.com/wiki/targets#Notes)

: Report bugs on the

[Arma 3 Feedback Tracker](https://report.bistudio.com/projects/arma-3/general-arma-3)

and/or discuss them on the

[Arma Discord](https://discord.gg/arma)

.

**Only post proven facts here!**

[Add Note](https://community.bistudio.com/wiki?title=targets&action=edit&section=new&preload=Template:Preload/Base&preloadparams%5B%5D=%7B%7Bsubst%3APreload%2FNote%7C1%3D%0D%0A%3C%21--%0D%0A%2A%20Write%20your%20comment%20here%20%28remove%20both%20%22arrows%22%20top%20and%20bottom%29%0D%0A%2A%20Pipe%20signs%20%22%7C%22%20MUST%20be%20written%20%7B%7B%21%7D%7D%0D%0A%2A%20New%20lines%20can%20be%20forced%20with%20%3Cbr%3E%0D%0A%2A%20Please%20-PREVIEW%20YOUR%20ADDITION%20BEFORE%20SAVING-%0D%0A%0D%0A%2A%20Video%20Tutorial%3A%20https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DNtOl1gLz3Fo%0D%0A--%3E%0D%0A%7D%7D&preloadtitle=&summary=New+note&nosummary=true)

Retrieved from "[https://community.bistudio.com/wiki?title=targets&oldid=377208](https://community.bistudio.com/wiki?title=targets&oldid=377208)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70)
- [Category:Arma 3: New Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_New_Scripting_Commands)
- [Category:Arma 3: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands)
- [Category:Command Group: Object Detection](https://community.bistudio.com/wiki/Category:Command_Group:_Object_Detection)

Hidden category:

- [Category:Maintenance/RV](https://community.bistudio.com/wiki/Category:Maintenance/RV)