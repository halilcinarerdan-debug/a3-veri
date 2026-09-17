# targetKnowledge - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/targetKnowledge#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

[Category:Introduced with Arma 3 version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.50)[Category:Introduced with Arma 3 version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.50)

Hover & click on the images for description

### Description[Link](https://community.bistudio.com/wiki/targetKnowledge#Description)

Description:
: Returns unit's knowledge about target.
Groups:
: [Category:Command Group: Object Detection](https://community.bistudio.com/wiki/Category:Command_Group:_Object_Detection)

### Syntax[Link](https://community.bistudio.com/wiki/targetKnowledge#Syntax)

Syntax:
: unit

targetKnowledge

target
Parameters:
: unit:

[Object](https://community.bistudio.com/wiki/Object)
: target:

[Object](https://community.bistudio.com/wiki/Object)
Return Value:
: [Array](https://community.bistudio.com/wiki/Array)

with [knownByGroup, knownByUnit, lastSeen, lastThreat, side, errorMargin, position, ignoreTarget]

- knownByGroup: [Boolean](https://community.bistudio.com/wiki/Boolean) - target known by group
- knownByUnit: [Boolean](https://community.bistudio.com/wiki/Boolean) - target known by the unit
- lastSeen: [Number](https://community.bistudio.com/wiki/Number) - last time the target was seen by the unit
- lastThreat: [Number](https://community.bistudio.com/wiki/Number) - last time the target endangered the unit
- side: [Side](https://community.bistudio.com/wiki/Side) - target side
- errorMargin: [Number](https://community.bistudio.com/wiki/Number) - position error
- position: [Position](https://community.bistudio.com/wiki/Position) - target position
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) ignoreTarget: [Boolean](https://community.bistudio.com/wiki/Boolean) - target is ignored ([ignoreTarget](https://community.bistudio.com/wiki/ignoreTarget))

### Examples[Link](https://community.bistudio.com/wiki/targetKnowledge#Examples)

Example 1:
: Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _allInfo [=](https://community.bistudio.com/wiki/a_=_b) _soldierOne targetKnowledge _jeepOne; _allInfo [params](https://community.bistudio.com/wiki/params) ["_knownByGroup", "_knownByUnit", "_lastSeen", "_lastThreat", "_side", "_errorMargin", "_position", "_ignoreTarget"];
Example 2:
: Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _posError [=](https://community.bistudio.com/wiki/a_=_b) (_soldierOne targetKnowledge _jeepOne) [select](https://community.bistudio.com/wiki/select) 5;

### Additional Information[Link](https://community.bistudio.com/wiki/targetKnowledge#Additional_Information)

See also:
: [knowsAbout](https://community.bistudio.com/wiki/knowsAbout)

[targets](https://community.bistudio.com/wiki/targets)

[targetsQuery](https://community.bistudio.com/wiki/targetsQuery)

[nearTargets](https://community.bistudio.com/wiki/nearTargets)

[targetsAggregate](https://community.bistudio.com/wiki/targetsAggregate)

[reveal](https://community.bistudio.com/wiki/reveal)

[forgetTarget](https://community.bistudio.com/wiki/forgetTarget)

[setTargetAge](https://community.bistudio.com/wiki/setTargetAge)

[getHideFrom](https://community.bistudio.com/wiki/getHideFrom)

[ignoreTarget](https://community.bistudio.com/wiki/ignoreTarget)

### Notes[Link](https://community.bistudio.com/wiki/targetKnowledge#Notes)

: Report bugs on the

[Arma 3 Feedback Tracker](https://report.bistudio.com/projects/arma-3/general-arma-3)

and/or discuss them on the

[Arma Discord](https://discord.gg/arma)

.

**Only post proven facts here!**

[Add Note](https://community.bistudio.com/wiki?title=targetKnowledge&action=edit&section=new&preload=Template:Preload/Base&preloadparams%5B%5D=%7B%7Bsubst%3APreload%2FNote%7C1%3D%0D%0A%3C%21--%0D%0A%2A%20Write%20your%20comment%20here%20%28remove%20both%20%22arrows%22%20top%20and%20bottom%29%0D%0A%2A%20Pipe%20signs%20%22%7C%22%20MUST%20be%20written%20%7B%7B%21%7D%7D%0D%0A%2A%20New%20lines%20can%20be%20forced%20with%20%3Cbr%3E%0D%0A%2A%20Please%20-PREVIEW%20YOUR%20ADDITION%20BEFORE%20SAVING-%0D%0A%0D%0A%2A%20Video%20Tutorial%3A%20https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DNtOl1gLz3Fo%0D%0A--%3E%0D%0A%7D%7D&preloadtitle=&summary=New+note&nosummary=true)

Retrieved from "[https://community.bistudio.com/wiki?title=targetKnowledge&oldid=377833](https://community.bistudio.com/wiki?title=targetKnowledge&oldid=377833)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [Category:Introduced with Arma 3 version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.50)
- [Category:Arma 3: New Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_New_Scripting_Commands)
- [Category:Arma 3: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands)
- [Category:Command Group: Object Detection](https://community.bistudio.com/wiki/Category:Command_Group:_Object_Detection)

Hidden category:

- [Category:Maintenance/RV](https://community.bistudio.com/wiki/Category:Maintenance/RV)