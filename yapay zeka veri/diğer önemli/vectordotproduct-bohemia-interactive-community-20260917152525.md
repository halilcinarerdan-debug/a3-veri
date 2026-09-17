# vectorDotProduct - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/vectorDotProduct#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

[Category:Introduced with Arma 3 version 1.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.22)[Category:Introduced with Arma 3 version 1.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.22)

Hover & click on the images for description

### Description[Link](https://community.bistudio.com/wiki/vectorDotProduct#Description)

Description:
: Dot product of two 3D vectors.

[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)

Since [Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14) any count of numbers is valid, but both arrays must be same length.
 Before [Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14), the first argument had to be vector 3D, or [Category:Introduced with Arma 3 version 2.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.00)[Category:Introduced with Arma 3 version 2.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.00) 2D (With z coordinate defaulted to 0)
Groups:
: [Category:Command Group: Math - Vectors](https://community.bistudio.com/wiki/Category:Command_Group:_Math_-_Vectors)

### Syntax[Link](https://community.bistudio.com/wiki/vectorDotProduct#Syntax)

Syntax:
: vector1

vectorDotProduct

vector2
Parameters:
: vector1:

[Array](https://community.bistudio.com/wiki/Array)

of

[Number](https://community.bistudio.com/wiki/Number)
: vector2:

[Array](https://community.bistudio.com/wiki/Array)

of

[Number](https://community.bistudio.com/wiki/Number)
Return Value:
: [Number](https://community.bistudio.com/wiki/Number)

### Examples[Link](https://community.bistudio.com/wiki/vectorDotProduct#Examples)

Example 1:
: Copy code to clipboard

_dot [=](https://community.bistudio.com/wiki/a_=_b) [1,0,1] vectorDotProduct [0,0,2];

### Additional Information[Link](https://community.bistudio.com/wiki/vectorDotProduct#Additional_Information)

See also:
: [vectorAdd](https://community.bistudio.com/wiki/vectorAdd)

[vectorDiff](https://community.bistudio.com/wiki/vectorDiff)

[vectorCrossProduct](https://community.bistudio.com/wiki/vectorCrossProduct)

[vectorCos](https://community.bistudio.com/wiki/vectorCos)

[vectorMagnitude](https://community.bistudio.com/wiki/vectorMagnitude)

[vectorMagnitudeSqr](https://community.bistudio.com/wiki/vectorMagnitudeSqr)

[vectorMultiply](https://community.bistudio.com/wiki/vectorMultiply)

[vectorDistance](https://community.bistudio.com/wiki/vectorDistance)

[vectorDistanceSqr](https://community.bistudio.com/wiki/vectorDistanceSqr)

[vectorDir](https://community.bistudio.com/wiki/vectorDir)

[vectorUp](https://community.bistudio.com/wiki/vectorUp)

[setVectorDir](https://community.bistudio.com/wiki/setVectorDir)

[setVectorUp](https://community.bistudio.com/wiki/setVectorUp)

[setVectorDirAndUp](https://community.bistudio.com/wiki/setVectorDirAndUp)

[vectorNormalized](https://community.bistudio.com/wiki/vectorNormalized)

[vectorFromTo](https://community.bistudio.com/wiki/vectorFromTo)

[matrixMultiply](https://community.bistudio.com/wiki/matrixMultiply)

[matrixTranspose](https://community.bistudio.com/wiki/matrixTranspose)

### Notes[Link](https://community.bistudio.com/wiki/vectorDotProduct#Notes)

: Report bugs on the

[Arma 3 Feedback Tracker](https://report.bistudio.com/projects/arma-3/general-arma-3)

and/or discuss them on the

[Arma Discord](https://discord.gg/arma)

.

**Only post proven facts here!**

[Add Note](https://community.bistudio.com/wiki?title=vectorDotProduct&action=edit&section=new&preload=Template:Preload/Base&preloadparams%5B%5D=%7B%7Bsubst%3APreload%2FNote%7C1%3D%0D%0A%3C%21--%0D%0A%2A%20Write%20your%20comment%20here%20%28remove%20both%20%22arrows%22%20top%20and%20bottom%29%0D%0A%2A%20Pipe%20signs%20%22%7C%22%20MUST%20be%20written%20%7B%7B%21%7D%7D%0D%0A%2A%20New%20lines%20can%20be%20forced%20with%20%3Cbr%3E%0D%0A%2A%20Please%20-PREVIEW%20YOUR%20ADDITION%20BEFORE%20SAVING-%0D%0A%0D%0A%2A%20Video%20Tutorial%3A%20https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DNtOl1gLz3Fo%0D%0A--%3E%0D%0A%7D%7D&preloadtitle=&summary=New+note&nosummary=true)

: Posted on 28 Jun, 2014
[User:Ffur2007slx2 5](https://community.bistudio.com/wiki/User:Ffur2007slx2_5)
: [Category:Introduced with Arma 3 version 1.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.22)[Category:Introduced with Arma 3 version 1.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.22)

Algorithm:

Copy code to clipboard

Vector1 [=](https://community.bistudio.com/wiki/a_=_b) [x1,y1,z1]; Vector2 [=](https://community.bistudio.com/wiki/a_=_b) [x2,y2,z2]; Result [=](https://community.bistudio.com/wiki/a_=_b) (x1 [*](https://community.bistudio.com/wiki/a_*_b) x2) [+](https://community.bistudio.com/wiki/+) (y1 [*](https://community.bistudio.com/wiki/a_*_b) y2) [+](https://community.bistudio.com/wiki/+) (z1 [*](https://community.bistudio.com/wiki/a_*_b) z2);

It is recommended to use

vectorDotProduct

instead of

[BIS fnc dotProduct](https://community.bistudio.com/wiki/BIS_fnc_dotProduct)

.

Retrieved from "[https://community.bistudio.com/wiki?title=vectorDotProduct&oldid=373021](https://community.bistudio.com/wiki?title=vectorDotProduct&oldid=373021)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [Category:Introduced with Arma 3 version 1.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.22)
- [Category:Arma 3: New Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_New_Scripting_Commands)
- [Category:Arma 3: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands)
- [Category:Command Group: Math - Vectors](https://community.bistudio.com/wiki/Category:Command_Group:_Math_-_Vectors)

Hidden category:

- [Category:Maintenance/RV](https://community.bistudio.com/wiki/Category:Maintenance/RV)