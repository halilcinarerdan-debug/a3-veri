# Control Structures - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/Control_Structures#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

Category: [Category:Syntax](https://community.bistudio.com/wiki/Category:Syntax)

**Control Structures** are [Statement](https://community.bistudio.com/wiki/Statement) which are used to control execution flow in the scripts. They are sequences of scripting code which help to control complex procedures. You can use control structures to define code which is only executed under certain conditions or repeated for a couple of times.

***Note for advanced readers:** in the [Virtual Reality](https://community.bistudio.com/wiki/Virtual_Reality) scripting language control structures are normal scripting commands, with no special handling compared to other commands. This is different from most imperative programming languages (like C), where control statements are implemented in the core language grammar. The "controlling" done by them is implemented by accepting [Code](https://community.bistudio.com/wiki/Code) as an argument. The complex control structures like "[while](https://community.bistudio.com/wiki/while) ... [do](https://community.bistudio.com/wiki/do) ..." are implemented using helper types, like [While Type](https://community.bistudio.com/wiki/While_Type).*

## Requirements[Link](https://community.bistudio.com/wiki/Control_Structures#Requirements)

To fully understand this article you should read the following articles:

- [Introduction to Arma Scripting](https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting)
- [Variables](https://community.bistudio.com/wiki/Variables)
- [Operators](https://community.bistudio.com/wiki/Operators)

## Conditional Structures[Link](https://community.bistudio.com/wiki/Control_Structures#Conditional_Structures)

**Conditional structures** help to define code which is only executed under certain circumstances. Often you will write code that depends on the game state, on other code or other conditions.

### [if](https://community.bistudio.com/wiki/if)-Statement[Link](https://community.bistudio.com/wiki/Control_Structures#if-Statement)

The if-statement defines code that is only executed **if** a certain condition is met. The syntax of it looks like that:

```
if (CONDITION) then // The round braces are optional
{
	STATEMENT;
	...
};
```

- CONDITION is a [Boolean](https://community.bistudio.com/wiki/Boolean) [Statement](https://community.bistudio.com/wiki/Statement) or [Variables](https://community.bistudio.com/wiki/Variables) which returns either true or false. The code nested in the following [Block](https://community.bistudio.com/wiki/Block) is only executed if the condition is true, else ignored.
- STATEMENT is a custom sequence of [Statement](https://community.bistudio.com/wiki/Statement). That may be commands, assignments, control structures etc.

**Example:**

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) (_temperature [<](https://community.bistudio.com/wiki/a_less_b) 0) [then](https://community.bistudio.com/wiki/then) { [hint](https://community.bistudio.com/wiki/hint) "Snow!"; };

In this example, first the value of _temperature is checked:

- If the value is 0 or greater than 0, the nested code is ignored.
- If the value is less than 0, the command hint "Snow!"; is executed.

#### Alternative Code ([else](https://community.bistudio.com/wiki/else))[Link](https://community.bistudio.com/wiki/Control_Structures#Alternative_Code_(else))

You can also define *alternative* code that is executed, when the condition is *not* true.

```
if (CONDITION) then
{
	STATEMENT1;
	...
}
else
{
	STATEMENT2;
	...
};
```

Another way of specifying an alternative code is done by feeding a 2-dimensional [Array](https://community.bistudio.com/wiki/Array) of [Code](https://community.bistudio.com/wiki/Code) into the [then](https://community.bistudio.com/wiki/then) like this (but this alternative is CPU-heavier):

```
if (CONDITION) then [{STATEMENT1; ...}, {STATEMENT2; ...}];
```

In fact the above syntax with the Array is the only possible syntax as [else](https://community.bistudio.com/wiki/else) does nothing else than taking the code to its left and the one to its right and packs them both into an [Array](https://community.bistudio.com/wiki/Array) of [Code](https://community.bistudio.com/wiki/Code) which is then fed into the [then](https://community.bistudio.com/wiki/then) operator. But using [else](https://community.bistudio.com/wiki/else) is just as fine and in most cases better in case of readability of your code.
 Here you have a second sequence of [Statement](https://community.bistudio.com/wiki/Statement) executed when CONDITION is false.

#### Conditional assignments[Link](https://community.bistudio.com/wiki/Control_Structures#Conditional_assignments)

if..then structures can also be used to assign conditional values to variables:

Copy code to clipboard

_living [=](https://community.bistudio.com/wiki/a_=_b) [if](https://community.bistudio.com/wiki/if) ([alive](https://community.bistudio.com/wiki/alive) [player](https://community.bistudio.com/wiki/player)) [then](https://community.bistudio.com/wiki/then) { [true](https://community.bistudio.com/wiki/true) } [else](https://community.bistudio.com/wiki/else) { [false](https://community.bistudio.com/wiki/false) };

#### SQS syntax (deprecated)[Link](https://community.bistudio.com/wiki/Control_Structures#SQS_syntax_(deprecated))

⚠

[SQS Syntax](https://community.bistudio.com/wiki/SQS_Syntax) is deprecated; [SQF Syntax](https://community.bistudio.com/wiki/SQF_Syntax) should be used instead.

Within [SQS Syntax](https://community.bistudio.com/wiki/SQS_Syntax) the use of [goto](https://community.bistudio.com/wiki/goto) labels is a way to execute more than one statement within if...then structures.

```
if (CONDITION) then { goto "label" }
... some other statements
#label
  statement1
  statement2
  statement3
```

**Example 1: (without [else](https://community.bistudio.com/wiki/else))**

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) (_temperature [<](https://community.bistudio.com/wiki/a_less_b) 0) [then](https://community.bistudio.com/wiki/then) { [goto](https://community.bistudio.com/wiki/goto) "Snow" } ; ... some other statements [#](https://community.bistudio.com/wiki/SQS_Syntax#Label)Snow [hint](https://community.bistudio.com/wiki/hint) "Snow!" [echo](https://community.bistudio.com/wiki/echo) "There is snow!" variable [=](https://community.bistudio.com/wiki/a_=_b) [text](https://community.bistudio.com/wiki/text) "Hey. Snow outside."

**Example 2: (with [else](https://community.bistudio.com/wiki/else))**

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) (_temperature [<](https://community.bistudio.com/wiki/a_less_b) 0) [then](https://community.bistudio.com/wiki/then) { [goto](https://community.bistudio.com/wiki/goto) "Snow" } [else](https://community.bistudio.com/wiki/else) { [goto](https://community.bistudio.com/wiki/goto) "Sunshine" } ; ... some other statements [goto](https://community.bistudio.com/wiki/goto) "Continue" [#](https://community.bistudio.com/wiki/SQS_Syntax#Label)Snow [hint](https://community.bistudio.com/wiki/hint) "Snow!" [echo](https://community.bistudio.com/wiki/echo) "There is snow!" variable [=](https://community.bistudio.com/wiki/a_=_b) [text](https://community.bistudio.com/wiki/text) "Hey. Snow outside." [goto](https://community.bistudio.com/wiki/goto) "Continue" [#](https://community.bistudio.com/wiki/SQS_Syntax#Label)Sunshine [hint](https://community.bistudio.com/wiki/hint) "No Snow but sunshine!" [echo](https://community.bistudio.com/wiki/echo) "There is no snow!" variable [=](https://community.bistudio.com/wiki/a_=_b) [text](https://community.bistudio.com/wiki/text) "Hey. No snow outside." [goto](https://community.bistudio.com/wiki/goto) "Continue" [#](https://community.bistudio.com/wiki/SQS_Syntax#Label)Continue ; ...

#### Nested [if](https://community.bistudio.com/wiki/if)-Statements[Link](https://community.bistudio.com/wiki/Control_Structures#Nested_if-Statements)

Since the if-statement is itself a [Statement](https://community.bistudio.com/wiki/Statement), you can also create **nested if-statements**.

**Example:**

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) ([alive](https://community.bistudio.com/wiki/alive) [player](https://community.bistudio.com/wiki/player)) [then](https://community.bistudio.com/wiki/then) { [if](https://community.bistudio.com/wiki/if) ([someAmmo](https://community.bistudio.com/wiki/someAmmo) [player](https://community.bistudio.com/wiki/player)) [then](https://community.bistudio.com/wiki/then) { [hint](https://community.bistudio.com/wiki/hint) "The player is alive and has ammo!"; } [else](https://community.bistudio.com/wiki/else) { [hint](https://community.bistudio.com/wiki/hint) "The player is out of ammo!"; }; } [else](https://community.bistudio.com/wiki/else) { [hint](https://community.bistudio.com/wiki/hint) "The player is dead!"; };

[Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00)[Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00)

### [switch](https://community.bistudio.com/wiki/switch)-Statement[Link](https://community.bistudio.com/wiki/Control_Structures#switch-Statement)

In some cases you may want to check a [Variables](https://community.bistudio.com/wiki/Variables) for several values and execute different code depending on the value. With the above knowledge you could just write a sequence of if-statements.

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) (_color [==](https://community.bistudio.com/wiki/a_==_b) "blue") [then](https://community.bistudio.com/wiki/then) { [hint](https://community.bistudio.com/wiki/hint) "What a nice color"; } [else](https://community.bistudio.com/wiki/else) { [if](https://community.bistudio.com/wiki/if) (_color [==](https://community.bistudio.com/wiki/a_==_b) "red") [then](https://community.bistudio.com/wiki/then) { [hint](https://community.bistudio.com/wiki/hint) "Don't you get aggressive?"; } };

The more values you want to compare, the longer gets this sequence. That is why the simplified switch-statement was introduced.

The switch-statement compares a variable against different values:

```
switch (VARIABLE) do
{
	case VALUE1:
	{
		STATEMENT;
		...
	};
	case VALUE2:
	{
		STATEMENT;
		...
	};
	...
};
```

The structure compares VARIABLE against all given values (VALUE1, VALUE2, ...). If any of the values matches, the corresponding block of statements is executed.

**Example:**

Copy code to clipboard

[[switch](https://community.bistudio.com/wiki/switch) (_color) [do](https://community.bistudio.com/wiki/do) { [case](https://community.bistudio.com/wiki/case) "blue"[:](https://community.bistudio.com/wiki/a_:_b) { [hint](https://community.bistudio.com/wiki/hint) "What a nice color"; }; [case](https://community.bistudio.com/wiki/case) "red"[:](https://community.bistudio.com/wiki/a_:_b) { [hint](https://community.bistudio.com/wiki/hint) "Don't you get aggressive?"; }; };

#### [default](https://community.bistudio.com/wiki/default)-Block[Link](https://community.bistudio.com/wiki/Control_Structures#default-Block)

In some cases you may want to define alternative code that is executed, when none of the values matches. You can write this code in a default-Block.

```
switch (VARIABLE) do
{
	case VALUE1:
	{
		STATEMENT;
		...
	};
	case VALUE2:
	{
		STATEMENT;
		...
	};
	...
	default // No colon behind default
	{
		STATEMENT;
		...
	};
};
```

#### Variable Assignments[Link](https://community.bistudio.com/wiki/Control_Structures#Variable_Assignments)

Switch can be used to assign different values to a variable:

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _color [=](https://community.bistudio.com/wiki/a_=_b) [switch](https://community.bistudio.com/wiki/switch) ([side](https://community.bistudio.com/wiki/side) [player](https://community.bistudio.com/wiki/player)) [do](https://community.bistudio.com/wiki/do) { [case](https://community.bistudio.com/wiki/case) [west](https://community.bistudio.com/wiki/west)[:](https://community.bistudio.com/wiki/a_:_b) { "ColorGreen" }; [case](https://community.bistudio.com/wiki/case) [east](https://community.bistudio.com/wiki/east)[:](https://community.bistudio.com/wiki/a_:_b) { "ColorRed" }; };

## Loops[Link](https://community.bistudio.com/wiki/Control_Structures#Loops)

**Loops** are used to execute the same [Block](https://community.bistudio.com/wiki/Block) for a specific or unspecific number of times.

### [while](https://community.bistudio.com/wiki/while)-Loop[Link](https://community.bistudio.com/wiki/Control_Structures#while-Loop)

This loop repeats the same code block as long as a given [Boolean](https://community.bistudio.com/wiki/Boolean) condition is true.

```
while {CONDITION} do // Note the curly braces
{
	STATEMENT;
	...
};
```

**Description:**

1. CONDITION is evaluated. If it is true, go on to 2., else skip the block and go on with the code following the loop.
2. Execution of all nested [Statement](https://community.bistudio.com/wiki/Statement). Go back to 1.

If CONDITION is false from the beginning on, the statements within the block of the loop will never be executed.

Because the test of the while expression takes place before each execution of the loop, a while loop executes zero or more times.

**Example:**

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _counter [=](https://community.bistudio.com/wiki/a_=_b) 0; [while](https://community.bistudio.com/wiki/while) { _counter [<](https://community.bistudio.com/wiki/a_less_b) 10 } [do](https://community.bistudio.com/wiki/do) { _counter [=](https://community.bistudio.com/wiki/a_=_b) _counter [+](https://community.bistudio.com/wiki/+) 1; };

[Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00)[Category:Introduced with Armed Assault version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Armed_Assault_version_1.00)

### [for](https://community.bistudio.com/wiki/for)-Loop[Link](https://community.bistudio.com/wiki/Control_Structures#for-Loop)

The for-loop repeats the same code block for a specific number of times.

```
for [{BEGIN}, {CONDITION}, {STEP}] do
{
	STATEMENT;
	...
};
```

- BEGIN is a number of [Statement](https://community.bistudio.com/wiki/Statement) executed *before* the loop starts
- CONDITION is a [Boolean](https://community.bistudio.com/wiki/Boolean) condition evaluated *before* each loop
- STEP is a number of statements executed *after* each loop

The loop processes as follows:

1. BEGIN is executed
2. CONDITION is evaluated. If it is true, go on to 3., else skip the block and go on with the code following the loop.
3. The statements in the code block are executed
4. STEP is executed, go on to 2.

If CONDITION is false from the beginning on, the code block will never be executed.

**Example:**

Copy code to clipboard

[for](https://community.bistudio.com/wiki/for) [{ _i [=](https://community.bistudio.com/wiki/a_=_b) 0 }, { _i [<](https://community.bistudio.com/wiki/a_less_b) 10 }, { _i [=](https://community.bistudio.com/wiki/a_=_b) _i [+](https://community.bistudio.com/wiki/+) 1 }] [do](https://community.bistudio.com/wiki/do) // a loop repeating 10 times { [player](https://community.bistudio.com/wiki/player) [globalChat](https://community.bistudio.com/wiki/globalChat) [format](https://community.bistudio.com/wiki/format) ["%1", _i]; };

will display "0" then "1" then "2" then "3" then "4" then "5" then "6" then "7" then "8" then "9".

**Description:**

1. The variable _i is set to 0
2. The condition _i < 10 is evaluated, which is true until _i surpasses 9.
3. The code player globalChat _i; is executed
4. The variable _i is incremented by 1, back to step 2.

#### [for](https://community.bistudio.com/wiki/for)-[from](https://community.bistudio.com/wiki/from)-[to](https://community.bistudio.com/wiki/to)-Loop[Link](https://community.bistudio.com/wiki/Control_Structures#for-from-to-Loop)

There exists an alternate syntax of the for-loop, which simplifies the last example a bit.

```
for "VARNAME" from STARTVALUE to ENDVALUE do
{
	STATEMENT;
	...
};
```

- VARNAME is any name given to the variable used to count the loop
- STARTVALUE is a [Number](https://community.bistudio.com/wiki/Number) value given to the counter variable before the loop starts
- ENDVALUE is a [Number](https://community.bistudio.com/wiki/Number) value until which the counter is incremented

⚠

Note: Unless using a custom [step](https://community.bistudio.com/wiki/step) as seen below, ENDVALUE must be greater than STARTVALUE for the loop to execute

The loop processes as follows:

1. A variable with the name VARNAME is initialized with STARTVALUE
2. If VARNAME does not exceed ENDVALUE, the code block will be executed.
3. The variable VARNAME is incremented by 1
4. Go back to step 2

The following example is semantically equal to the last example.

**Example:**

Copy code to clipboard

[for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 0 [to](https://community.bistudio.com/wiki/to) 9 [do](https://community.bistudio.com/wiki/do) // a loop repeating 10 times { [player](https://community.bistudio.com/wiki/player) [globalChat](https://community.bistudio.com/wiki/globalChat) [format](https://community.bistudio.com/wiki/format) ["%1", _i]; };

**Description:**

1. _i is set to 0
2. player globalChat 0 is executed
3. _i is incremented by 1 => _i is now 1
4. Back to step 2

#### [for](https://community.bistudio.com/wiki/for)-[from](https://community.bistudio.com/wiki/from)-[to](https://community.bistudio.com/wiki/to)-Loop with custom [step](https://community.bistudio.com/wiki/step)[Link](https://community.bistudio.com/wiki/Control_Structures#for-from-to-Loop_with_custom_step)

The default step to increment the variable in for-from-to-Loops is 1. You can set a custom step though using this syntax:

```
for "VARNAME" from STARTVALUE to ENDVALUE step STEP do
{
	STATEMENT;
	...
};
```

- STEP is a [Number](https://community.bistudio.com/wiki/Number) which defines the step by which the variable is incremented every loop

⚠

Note: Utilizing this method, you can perform loops where VARNAME decrements by using a negative [step](https://community.bistudio.com/wiki/step) value combined with a STARTVALUE that is greater than ENDVALUE

The rest is equal to the above section.

**Example:**

Copy code to clipboard

[for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 0 [to](https://community.bistudio.com/wiki/to) 9 [step](https://community.bistudio.com/wiki/step) 2 [do](https://community.bistudio.com/wiki/do) // a loop repeating 5 times { [player](https://community.bistudio.com/wiki/player) [globalChat](https://community.bistudio.com/wiki/globalChat) [format](https://community.bistudio.com/wiki/format) ["%1", _i]; };

**Description:**

1. _i is set to 0
2. player globalChat 0 is executed
3. _i is incremented by 2 => _i is now 2
4. Back to step 2

### [forEach](https://community.bistudio.com/wiki/forEach)-Loop[Link](https://community.bistudio.com/wiki/Control_Structures#forEach-Loop)

You will often use the forEach-loop to increment over [Array](https://community.bistudio.com/wiki/Array). It repeats the same code block for every item in an array.

```
{
	STATEMENT;
	...
} forEach ARRAY;
```

The code block is executed exactly ([count](https://community.bistudio.com/wiki/count) ARRAY) times.

You may use the [Magic Variables](https://community.bistudio.com/wiki/Magic_Variables) _x within the code block, which always references to the current item of the array. Magic variable _foreachindex contains current index of the _x element in ARRAY.

**Example:**

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _array [=](https://community.bistudio.com/wiki/a_=_b) [unit1, unit2, unit3]; { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [setDamage](https://community.bistudio.com/wiki/setDamage) 1; } [forEach](https://community.bistudio.com/wiki/forEach) _array;

**Description:**

1. In the first loop, the statement unit1 setDamage 1; is executed
2. In the second loop, the statement unit2 setDamage 1; is executed
3. In the third loop, the statement unit3 setDamage 1; is executed

⚠

Each iteration will be executed within one frame, even if it consists of multiple instructions. So be aware of large and/or complex code blocks!

## Return Values[Link](https://community.bistudio.com/wiki/Control_Structures#Return_Values)

Control structures always return the **last [expression](https://community.bistudio.com/wiki/expression) evaluated** within the structure.

**Example:**

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) (myCondition) [then](https://community.bistudio.com/wiki/then) { myValueA; } [else](https://community.bistudio.com/wiki/else) { myValueB; }; // returns myValueA or myValueB

## See Also[Link](https://community.bistudio.com/wiki/Control_Structures#See_Also)

- [Category:Command Group: Program Flow](https://community.bistudio.com/wiki/Category:Command_Group:_Program_Flow)
- [Statement](https://community.bistudio.com/wiki/Statement)
- [Expression](https://community.bistudio.com/wiki/Expression)

Retrieved from "[https://community.bistudio.com/wiki?title=Control_Structures&oldid=363911](https://community.bistudio.com/wiki?title=Control_Structures&oldid=363911)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Syntax](https://community.bistudio.com/wiki/Category:Syntax)