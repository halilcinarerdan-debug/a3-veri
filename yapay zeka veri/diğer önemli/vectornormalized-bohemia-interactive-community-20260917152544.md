# vectorNormalized - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/vectorNormalized#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

[Category:Introduced with Arma 3 version 1.26](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.26)[Category:Introduced with Arma 3 version 1.26](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.26)

Hover & click on the images for description

### Description[Link](https://community.bistudio.com/wiki/vectorNormalized#Description)

Description:
: Returns normalised vector (unit vector,

[vectorMagnitude](https://community.bistudio.com/wiki/vectorMagnitude)

== 1) of given vector. If given vector is 0 result is a 0 vector as well.

ⓘ

- [Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14) any count of numbers is valid
- [Category:Introduced with Arma 3 version 2.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.00)[Category:Introduced with Arma 3 version 2.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.00) now supports [Vector2D](https://community.bistudio.com/wiki/Vector2D) (z defaulted to 0)
- [Category:Introduced with Arma 3 version 1.26](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.26)[Category:Introduced with Arma 3 version 1.26](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.26) command introduction, only works with [Vector3D](https://community.bistudio.com/wiki/Vector3D)
Groups:
: [Category:Command Group: Math - Vectors](https://community.bistudio.com/wiki/Category:Command_Group:_Math_-_Vectors)

### Syntax[Link](https://community.bistudio.com/wiki/vectorNormalized#Syntax)

Syntax:
: vectorNormalized

vector
Parameters:
: vector:

[Array](https://community.bistudio.com/wiki/Array)

of

[Number](https://community.bistudio.com/wiki/Number)
Return Value:
: [Vector3D](https://community.bistudio.com/wiki/Vector3D)

### Examples[Link](https://community.bistudio.com/wiki/vectorNormalized#Examples)

Example 1:
: Copy code to clipboard

vectorNormalized [12345,7890,38383]; // [0.300481,0.192045,0.934254] [vectorMagnitude](https://community.bistudio.com/wiki/vectorMagnitude) [0.300481,0.192045,0.934254]; // 1

### Additional Information[Link](https://community.bistudio.com/wiki/vectorNormalized#Additional_Information)

See also:
: [vectorDiff](https://community.bistudio.com/wiki/vectorDiff)

[vectorCrossProduct](https://community.bistudio.com/wiki/vectorCrossProduct)

[vectorDotProduct](https://community.bistudio.com/wiki/vectorDotProduct)

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

[vectorFromTo](https://community.bistudio.com/wiki/vectorFromTo)

[matrixMultiply](https://community.bistudio.com/wiki/matrixMultiply)

[matrixTranspose](https://community.bistudio.com/wiki/matrixTranspose)

### Notes[Link](https://community.bistudio.com/wiki/vectorNormalized#Notes)

: Report bugs on the

[Arma 3 Feedback Tracker](https://report.bistudio.com/projects/arma-3/general-arma-3)

and/or discuss them on the

[Arma Discord](https://discord.gg/arma)

.

**Only post proven facts here!**

[Add Note](https://community.bistudio.com/wiki?title=vectorNormalized&action=edit&section=new&preload=Template:Preload/Base&preloadparams%5B%5D=%7B%7Bsubst%3APreload%2FNote%7C1%3D%0D%0A%3C%21--%0D%0A%2A%20Write%20your%20comment%20here%20%28remove%20both%20%22arrows%22%20top%20and%20bottom%29%0D%0A%2A%20Pipe%20signs%20%22%7C%22%20MUST%20be%20written%20%7B%7B%21%7D%7D%0D%0A%2A%20New%20lines%20can%20be%20forced%20with%20%3Cbr%3E%0D%0A%2A%20Please%20-PREVIEW%20YOUR%20ADDITION%20BEFORE%20SAVING-%0D%0A%0D%0A%2A%20Video%20Tutorial%3A%20https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DNtOl1gLz3Fo%0D%0A--%3E%0D%0A%7D%7D&preloadtitle=&summary=New+note&nosummary=true)

[User:Ffur2007slx2 5](https://community.bistudio.com/wiki/User:Ffur2007slx2_5) - [Special:Contributions/ffur2007slx2 5](https://community.bistudio.com/wiki/Special:Contributions/ffur2007slx2_5)
: Posted on Jul 19, 2014 - 15:13 (UTC)

[§](https://community.bistudio.com/wiki/vectorNormalized#usernote20140719151300)
: [Category:Introduced with Arma 3 version 1.26](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.26)[Category:Introduced with Arma 3 version 1.26](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.26)

Algorithm:

Copy code to clipboard

_vector [=](https://community.bistudio.com/wiki/a_=_b) [x,y,z]; _result [=](https://community.bistudio.com/wiki/a_=_b) [x [/](https://community.bistudio.com/wiki/a_/_b) ([sqrt](https://community.bistudio.com/wiki/sqrt) (x [^](https://community.bistudio.com/wiki/a_%5E_b) 2 [+](https://community.bistudio.com/wiki/+) y [^](https://community.bistudio.com/wiki/a_%5E_b) 2 [+](https://community.bistudio.com/wiki/+) z [^](https://community.bistudio.com/wiki/a_%5E_b) 2)), y [/](https://community.bistudio.com/wiki/a_/_b) ([sqrt](https://community.bistudio.com/wiki/sqrt) (x [^](https://community.bistudio.com/wiki/a_%5E_b) 2 [+](https://community.bistudio.com/wiki/+) y [^](https://community.bistudio.com/wiki/a_%5E_b) 2 [+](https://community.bistudio.com/wiki/+) z [^](https://community.bistudio.com/wiki/a_%5E_b) 2)), z [/](https://community.bistudio.com/wiki/a_/_b) ([sqrt](https://community.bistudio.com/wiki/sqrt) (x [^](https://community.bistudio.com/wiki/a_%5E_b) 2 [+](https://community.bistudio.com/wiki/+) y [^](https://community.bistudio.com/wiki/a_%5E_b) 2 [+](https://community.bistudio.com/wiki/+) z [^](https://community.bistudio.com/wiki/a_%5E_b) 2))];

In mathematics, a unit vector in a normed vector space is a vector whose length is 1.

Retrieved from "[https://community.bistudio.com/wiki?title=vectorNormalized&oldid=378403](https://community.bistudio.com/wiki?title=vectorNormalized&oldid=378403)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [Category:Introduced with Arma 3 version 1.26](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.26)
- [Category:Arma 3: New Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_New_Scripting_Commands)
- [Category:Arma 3: Scripting Commands](https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands)
- [Category:Command Group: Math - Vectors](https://community.bistudio.com/wiki/Category:Command_Group:_Math_-_Vectors)

Hidden category:

- [Category:Maintenance/RV](https://community.bistudio.com/wiki/Category:Maintenance/RV)