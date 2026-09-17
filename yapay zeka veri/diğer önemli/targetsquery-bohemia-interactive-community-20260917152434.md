# targetsQuery - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/targetsQuery#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

[Category:Introduced with Arma 2 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2_version_1.00)[Category:Introduced with Arma 2 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2_version_1.00)[Category:Introduced with Arma 2: Operation Arrowhead version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2:_Operation_Arrowhead_version_1.50)[Category:Introduced with Arma 2: Operation Arrowhead version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2:_Operation_Arrowhead_version_1.50)[Category:Introduced with Take On Helicopters version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Take_On_Helicopters_version_1.00)[Category:Introduced with Take On Helicopters version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Take_On_Helicopters_version_1.00)[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)

Hover & click on the images for description

### Description[Link](https://community.bistudio.com/wiki/targetsQuery#Description)

Description:
: Returns sorted array of targets,

**known**

to the enquirer (including own troops), where the accuracy coefficient reflects how close the result matches the query. This command could be CPU intensive.
Groups:
: [Category:Command Group: Object Detection](https://community.bistudio.com/wiki/Category:Command_Group:_Object_Detection)

### Syntax[Link](https://community.bistudio.com/wiki/targetsQuery#Syntax)

Syntax:
: enquirer

targetsQuery

[targetIgnore, targetSide, targetType, targetPosition, targetMaxAge]
Parameters:
: enquirer:

[Object](https://community.bistudio.com/wiki/Object)

- for whom the query will be made
: targetIgnore:

[Object](https://community.bistudio.com/wiki/Object)

- target object to exclude from results.

[objNull](https://community.bistudio.com/wiki/objNull)

- return every target
: targetSide:

[Side](https://community.bistudio.com/wiki/Side)

- desired side of the target.

[sideUnknown](https://community.bistudio.com/wiki/sideUnknown)

- any side
: targetType:

[String](https://community.bistudio.com/wiki/String)

- desired target

[typeOf](https://community.bistudio.com/wiki/typeOf)

. "" - any type
: targetPosition:

[Position](https://community.bistudio.com/wiki/Position#Introduction)

or

[Position](https://community.bistudio.com/wiki/Position#Introduction)

- desired target position (only [x,y] is considered). Position tolerance is 200m from the actual position of the target. [] - any position
: targetMaxAge:

[Number](https://community.bistudio.com/wiki/Number)

- desired max age of the target. This will limit returned results to the targets younger than specified age. 0 - any age
Return Value:
: [Array](https://community.bistudio.com/wiki/Array)

of

[Array](https://community.bistudio.com/wiki/Array)

with [accuracy, target, targetSide, targetType, targetPosition, targetAge]

- accuracy: [Number](https://community.bistudio.com/wiki/Number) in range 0..1 - a coefficient, which reflects how close the returned result to the query filter. (1 - best match)
- target: [Object](https://community.bistudio.com/wiki/Object) - the actual target object
- targetSide: [Side](https://community.bistudio.com/wiki/Side) - side of the target
- targetType: [String](https://community.bistudio.com/wiki/String) - target [typeOf](https://community.bistudio.com/wiki/typeOf)
- targetPosition: [Array](https://community.bistudio.com/wiki/Array) - [x,y] of the target
- targetAge: [Number](https://community.bistudio.com/wiki/Number) - the actual target age in seconds (can be negative)

### Examples[Link](https://community.bistudio.com/wiki/targetsQuery#Examples)

Example 1:
: Return all known targets for player:

Copy code to clipboard

_targets [=](https://community.bistudio.com/wiki/a_=_b) [player](https://community.bistudio.com/wiki/player) targetsQuery [[objNull](https://community.bistudio.com/wiki/objNull), [sideUnknown](https://community.bistudio.com/wiki/sideUnknown), "", [], 0];
Example 2:
: Prioritise all known OPFOR targets and return targets less than 10 seconds old:

Copy code to clipboard

_targets [=](https://community.bistudio.com/wiki/a_=_b) [player](https://community.bistudio.com/wiki/player) targetsQuery [[objNull](https://community.bistudio.com/wiki/objNull), [east](https://community.bistudio.com/wiki/east), "", [], 10];

### Additional Information[Link](https://community.bistudio.com/wiki/targetsQuery#Additional_Information)

See also:
: [targets](https://community.bistudio.com/wiki/targets)

[nearTargets](https://community.bistudio.com/wiki/nearTargets)

[targetsAggregate](https://community.bistudio.com/wiki/targetsAggregate)

[targetKnowledge](https://community.bistudio.com/wiki/targetKnowledge)

[knowsAbout](https://community.bistudio.com/wiki/knowsAbout)

[reveal](https://community.bistudio.com/wiki/reveal)

[forgetTarget](https://community.bistudio.com/wiki/forgetTarget)

[setTargetAge](https://community.bistudio.com/wiki/setTargetAge)

[getHideFrom](https://community.bistudio.com/wiki/getHideFrom)

### Notes[Link](https://community.bistudio.com/wiki/targetsQuery#Notes)

: Report bugs on the

[Arma 3 Feedback Tracker](https://report.bistudio.com/projects/arma-3/general-arma-3)

and/or discuss them on the

[Arma Discord](https://discord.gg/arma)

.

**Only post proven facts here!**

[Add Note](https://community.bistudio.com/wiki?title=targetsQuery&action=edit&section=new&preload=Template:Preload/Base&preloadparams%5B%5D=%7B%7Bsubst%3APreload%2FNote%7C1%3D%0D%0A%3C%21--%0D%0A%2A%20Write%20your%20comment%20here%20%28remove%20both%20%22arrows%22%20top%20and%20bottom%29%0D%0A%2A%20Pipe%20signs%20%22%7C%22%20MUST%20be%20written%20%7B%7B%21%7D%7D%0D%0A%2A%20New%20lines%20can%20be%20forced%20with%20%3Cbr%3E%0D%0A%2A%20Please%20-PREVIEW%20YOUR%20ADDITION%20BEFORE%20SAVING-%0D%0A%0D%0A%2A%20Video%20Tutorial%3A%20https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DNtOl1gLz3Fo%0D%0A--%3E%0D%0A%7D%7D&preloadtitle=&summary=New+note&nosummary=true)

Retrieved from "[https://community.bistudio.com/wiki?title=targetsQuery&oldid=377711](https://community.bistudio.com/wiki?title=targetsQuery&oldid=377711)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [Category:Introduced with Arma 2 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_2_version_1.00)
- [Category:Arma 2: New Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_2:_New_Scripting_Commands)
- [Category:Arma 2: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_2:_Scripting_Commands)
- [Category:Arma 2: Operation Arrowhead: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_2:_Operation_Arrowhead:_Scripting_Commands)
- [Category:Take On Helicopters: Scripting Commands](https://community.bistudio.com/wiki/Category:Take_On_Helicopters:_Scripting_Commands)
- [Category:Arma 3: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands)
- [Category:Command Group: Object Detection](https://community.bistudio.com/wiki/Category:Command_Group:_Object_Detection)

Hidden category:

- [Category:Maintenance/RV](https://community.bistudio.com/wiki/Category:Maintenance/RV)