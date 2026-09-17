# vectorModelToWorld - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/vectorModelToWorld#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

[Category:Introduced with Arma 3 version 1.72](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.72)[Category:Introduced with Arma 3 version 1.72](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.72)

Hover & click on the images for description

### Description[Link](https://community.bistudio.com/wiki/vectorModelToWorld#Description)

Description:
: Converts vector direction from model to world space.

⚠

For [setObjectScale](https://community.bistudio.com/wiki/setObjectScale), the resulting vector's [vectorMagnitude](https://community.bistudio.com/wiki/vectorMagnitude) will also be [vectorMultiply](https://community.bistudio.com/wiki/vectorMultiply) by the object scale.
Groups:
: [Category:Command Group: Math - Vectors](https://community.bistudio.com/wiki/Category:Command_Group:_Math_-_Vectors)

### Syntax[Link](https://community.bistudio.com/wiki/vectorModelToWorld#Syntax)

Syntax:
: object

vectorModelToWorld

modelDir
Parameters:
: object:

[Object](https://community.bistudio.com/wiki/Object)
: modelDir:

[Vector3D](https://community.bistudio.com/wiki/Vector3D)

- vector direction in model space in format [x,y,z]
Return Value:
: [Vector3D](https://community.bistudio.com/wiki/Vector3D)

- vector direction in world space

### Examples[Link](https://community.bistudio.com/wiki/vectorModelToWorld#Examples)

Example 1:
: Convert model space vector [0,-10,4] to world space; vector gets rotated according to _airplane:

Copy code to clipboard

_airplane vectorModelToWorld [0,-10,4];

### Additional Information[Link](https://community.bistudio.com/wiki/vectorModelToWorld#Additional_Information)

See also:
: [vectorDir](https://community.bistudio.com/wiki/vectorDir)

[modelToWorld](https://community.bistudio.com/wiki/modelToWorld)

[addForce](https://community.bistudio.com/wiki/addForce)

[addTorque](https://community.bistudio.com/wiki/addTorque)

[vectorModelToWorldVisual](https://community.bistudio.com/wiki/vectorModelToWorldVisual)

[vectorWorldToModel](https://community.bistudio.com/wiki/vectorWorldToModel)

[vectorWorldToModelVisual](https://community.bistudio.com/wiki/vectorWorldToModelVisual)

[matrixMultiply](https://community.bistudio.com/wiki/matrixMultiply)

[matrixTranspose](https://community.bistudio.com/wiki/matrixTranspose)

### Notes[Link](https://community.bistudio.com/wiki/vectorModelToWorld#Notes)

: Report bugs on the

[Arma 3 Feedback Tracker](https://report.bistudio.com/projects/arma-3/general-arma-3)

and/or discuss them on the

[Arma Discord](https://discord.gg/arma)

.

**Only post proven facts here!**

[Add Note](https://community.bistudio.com/wiki?title=vectorModelToWorld&action=edit&section=new&preload=Template:Preload/Base&preloadparams%5B%5D=%7B%7Bsubst%3APreload%2FNote%7C1%3D%0D%0A%3C%21--%0D%0A%2A%20Write%20your%20comment%20here%20%28remove%20both%20%22arrows%22%20top%20and%20bottom%29%0D%0A%2A%20Pipe%20signs%20%22%7C%22%20MUST%20be%20written%20%7B%7B%21%7D%7D%0D%0A%2A%20New%20lines%20can%20be%20forced%20with%20%3Cbr%3E%0D%0A%2A%20Please%20-PREVIEW%20YOUR%20ADDITION%20BEFORE%20SAVING-%0D%0A%0D%0A%2A%20Video%20Tutorial%3A%20https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DNtOl1gLz3Fo%0D%0A--%3E%0D%0A%7D%7D&preloadtitle=&summary=New+note&nosummary=true)

Retrieved from "[https://community.bistudio.com/wiki?title=vectorModelToWorld&oldid=378448](https://community.bistudio.com/wiki?title=vectorModelToWorld&oldid=378448)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [Category:Introduced with Arma 3 version 1.72](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.72)
- [Category:Arma 3: New Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_New_Scripting_Commands)
- [Category:Arma 3: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands)
- [Category:Command Group: Math - Vectors](https://community.bistudio.com/wiki/Category:Command_Group:_Math_-_Vectors)

Hidden category:

- [Category:Maintenance/RV](https://community.bistudio.com/wiki/Category:Maintenance/RV)