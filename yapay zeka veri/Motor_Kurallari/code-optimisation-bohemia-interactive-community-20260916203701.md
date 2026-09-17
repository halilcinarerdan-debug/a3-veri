# Code Optimisation - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/Code_Optimisation#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

Category: [Category:Arma Scripting Tutorials](https://community.bistudio.com/wiki/Category:Arma_Scripting_Tutorials)

ⓘ

This page is about Code Optimisation. For *conception* optimisation, see [Mission Optimisation](https://community.bistudio.com/wiki/Mission_Optimisation).

This article will try to be a general guide about improving your code **and** its performance.

- The first part ([Rules](https://community.bistudio.com/wiki/Code_Optimisation#Rules)) focuses on having a clean, readable and maintainable code.
- The second part ([Code optimisation](https://community.bistudio.com/wiki/Code_Optimisation#Code_optimisation)) is about **improving performance**, sometimes trading it against code readability.
- The third part ([Equivalent commands performance](https://community.bistudio.com/wiki/Code_Optimisation#Equivalent_commands_performance)) mentions commands that in appearance have identical effects but may differ in terms of performance according to the use you may have of them.
- The fourth part ([Conversion from earlier versions](https://community.bistudio.com/wiki/Code_Optimisation#Conversion_from_earlier_versions)) is a hopefully helpful, short guide about useful new commands or syntaxes to replace the old ways.

## Rules[Link](https://community.bistudio.com/wiki/Code_Optimisation#Rules)

In the domain of development, any rule is a rule of thumb. If a rule states for example that it is *better* that a line of code doesn't go over 80 characters, it doesn't mean that any line ***must not*** go over 80 characters; sometimes, the situation needs it. If you have a good structure, **do not** change your code to enforce a single arbitrary rule. If you break many of them, you may have to change something. Again, this is according to your judgement.

With that being said, here are the three basic rules to get yourself in the clear:

1. [Make it work](https://community.bistudio.com/wiki/Code_Optimisation#Make_It_Work)
2. [Make it readable](https://community.bistudio.com/wiki/Code_Optimisation#Make_It_Readable)
3. [Optimise then](https://community.bistudio.com/wiki/Code_Optimisation#Optimise_Then)

### Make It Work[Link](https://community.bistudio.com/wiki/Code_Optimisation#Make_It_Work)

«

« Premature optimization is the root of all evil. » – [Donald Knuth](https://en.wikipedia.org/wiki/Donald_Knuth)

Your first goal when coding is to make your code do what you want it does. A good way to reach this objective is to read and getting inspired by other people's code. If you understand it by reading it once, it is probably a good source of inspiration.

- When starting from scratch if you know what you want but miss the specific steps to get to your point, it is a good practice to write down in your native language what you want to do. E.g *Get [allUnits](https://community.bistudio.com/wiki/allUnits) [distance](https://community.bistudio.com/wiki/distance) [locationPosition](https://community.bistudio.com/wiki/locationPosition), and [forEach](https://community.bistudio.com/wiki/forEach) [side](https://community.bistudio.com/wiki/side) soldier in them, [setDamage](https://community.bistudio.com/wiki/setDamage)*.
- Use [Arma 3 Startup Parameters](https://community.bistudio.com/wiki/Arma_3_Startup_Parameters#Developer_Options) startup parameter and **make sure your code doesn't throw errors.** Not only will your code run slower but it may also *not work at all*. Be sure to read the error, isolate the issue and sort it out [Category:Scripting Commands](https://community.bistudio.com/wiki/Category:Scripting_Commands).
- Read your [Crash Files](https://community.bistudio.com/wiki/Crash_Files) (report) to read more details about the error that happened in your code.

### Make It Readable[Link](https://community.bistudio.com/wiki/Code_Optimisation#Make_It_Readable)

Whether you are cleaning your code or a different person's, you must understand the code without twisting your brain:

- While [SQF Syntax](https://community.bistudio.com/wiki/SQF_Syntax) *is* (non-noticeably) impacted by variable name length, this should not take precedence on the fact that code must be readable by a human being. Variables like **_u** instead of **_uniform** should not be present.
- *One-lining* (putting everything in one statement) memory improvement is most of the time not worth the headache it gives when trying to read it. Don't overuse it.
- Indentation is important for the human mind, and space is too. Space is free, use it.
- Same goes for line return; it helps to see a code block wrapping multiple common instructions instead of having to guess where it starts and stops.
- Do you see the same code multiple times, only with different parameters? Now is the time to write a function!
- If you have a lot of [if](https://community.bistudio.com/wiki/if)..[else](https://community.bistudio.com/wiki/else), you may want to look at a [switch](https://community.bistudio.com/wiki/switch) condition, or again break your code in smaller functions.
- Is your function code far too long? Break it in understandable-sized bites for your own sanity.
- Finally, camel-casing (namingLikeThis) your variables will naturally make the code more readable, especially for long names.

ⓘ

See **[Code Best Practices](https://community.bistudio.com/wiki/Code_Best_Practices)** for more information.

See the following code:

```
_w=[]; {_w pushbackunique primaryweapon _x} foreach((allunits+alldeadmen) select{_x call BIS_fnc_objectside==east});
```

The same example is far more readable with proper spacing, good variable names and intermediate results:

```
_weaponNames = [];
_allUnitsAliveAndDead = allUnits + allDeadMen;
_allEastAliveAndDead = _allUnitsAliveAndDead select { _x call BIS_fnc_objectSide == east };
{ _weaponNames pushBackUnique primaryWeapon _x } forEach _allEastAliveAndDead;
```

#### Constants[Link](https://community.bistudio.com/wiki/Code_Optimisation#Constants)

Using a hard-coded constant more than once? Use preprocessor directives rather than storing it in memory or cluttering your code with numbers. Such as:

Copy code to clipboard

a [=](https://community.bistudio.com/wiki/a_=_b) [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [+](https://community.bistudio.com/wiki/+) 1.053; b [=](https://community.bistudio.com/wiki/a_=_b) [_y](https://community.bistudio.com/wiki/Magic_Variables#y) [+](https://community.bistudio.com/wiki/+) 1.053;

And

Copy code to clipboard

_buffer [=](https://community.bistudio.com/wiki/a_=_b) 1.053; a [=](https://community.bistudio.com/wiki/a_=_b) [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [+](https://community.bistudio.com/wiki/+) _buffer; b [=](https://community.bistudio.com/wiki/a_=_b) [_y](https://community.bistudio.com/wiki/Magic_Variables#y) [+](https://community.bistudio.com/wiki/+) _buffer;

Becomes

Copy code to clipboard

#define BUFFER 1.053 // note: no semicolon _a [=](https://community.bistudio.com/wiki/a_=_b) [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [+](https://community.bistudio.com/wiki/+) BUFFER; _b [=](https://community.bistudio.com/wiki/a_=_b) [_y](https://community.bistudio.com/wiki/Magic_Variables#y) [+](https://community.bistudio.com/wiki/+) BUFFER;

ⓘ

Using the Copy code to clipboard#define macro only works within the current [SQF Syntax](https://community.bistudio.com/wiki/SQF_Syntax) *file*. Such definition will not propagate anywhere else.

**Global** "constants" can be defined via a [Description.ext](https://community.bistudio.com/wiki/Description.ext) declaration, though, and accessed using [getMissionConfigValue](https://community.bistudio.com/wiki/getMissionConfigValue) command:

Declaration in [Description.ext](https://community.bistudio.com/wiki/Description.ext):

```cpp
var1 = 123;
var2 = "123";
var3[] = { 1, 2, 3 };
rand = __EVAL(random 999);
```

Usage in code:

Copy code to clipboard

[hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) [getMissionConfigValue](https://community.bistudio.com/wiki/getMissionConfigValue) "var1"; // 123 // 0.0007 ms [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) [getMissionConfigValue](https://community.bistudio.com/wiki/getMissionConfigValue) "var2"; // "123" // 0.0008 ms [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) [getMissionConfigValue](https://community.bistudio.com/wiki/getMissionConfigValue) "var3"; // [1,2,3] // 0.0017 ms [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) [getMissionConfigValue](https://community.bistudio.com/wiki/getMissionConfigValue) "rand"; // constant random, for example 935.038 // 0.0007 ms

The [getMissionConfigValue](https://community.bistudio.com/wiki/getMissionConfigValue) command searching [Description.ext](https://community.bistudio.com/wiki/Description.ext) from top to bottom, it is better for a matter of performance to put all your definitions at the top of the file.

### Optimise Then[Link](https://community.bistudio.com/wiki/Code_Optimisation#Optimise_Then)

Once you know what is what, you can understand your code better.

- Use [Variables](https://community.bistudio.com/wiki/Variables#Scopes) instead of global variables (preceded by an underscore) as much as possible.
- You were iterating multiple times on the same array?
  - You should be able to spot your issue now.
- Are you using [execVM](https://community.bistudio.com/wiki/execVM) on the same file, many times?
  - Store your function in memory to avoid file reading every call ( e.g Copy code to clipboard_myFunction [=](https://community.bistudio.com/wiki/a_=_b) [compile](https://community.bistudio.com/wiki/compile) [preprocessFileLineNumbers](https://community.bistudio.com/wiki/preprocessFileLineNumbers) "myFile.sqf";).
- Is your variable name far too long?
  - Find a smaller name, according to the variable scope;e.g:Copy code to clipboard

{ _opforUnitUniform [=](https://community.bistudio.com/wiki/a_=_b) [uniform](https://community.bistudio.com/wiki/uniform) [_x](https://community.bistudio.com/wiki/Magic_Variables#x); [systemChat](https://community.bistudio.com/wiki/systemChat) _opforUnitUniform; } [forEach](https://community.bistudio.com/wiki/forEach) _allOpforUnits;becomesCopy code to clipboard

{ _uniform [=](https://community.bistudio.com/wiki/a_=_b) [uniform](https://community.bistudio.com/wiki/uniform) [_x](https://community.bistudio.com/wiki/Magic_Variables#x); [systemChat](https://community.bistudio.com/wiki/systemChat) _uniform; } [forEach](https://community.bistudio.com/wiki/forEach) _allOpforUnits;

## Code Optimisation[Link](https://community.bistudio.com/wiki/Code_Optimisation#Code_Optimisation)

⚠

**Please note:** Tests and benchmarks were done with the latest Arma 3 version at the time [Category:Introduced with Arma 3 version 1.82](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.82)[Category:Introduced with Arma 3 version 1.82](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.82) with **Tank DLC**. Game engine performance may have changed since.
Benchmark result in milliseconds (ms) is an average for **10000** iterations.

ⓘ

means you

**must**

change your ways today,

*or with us you will ride…*

means you may want to look at it if you are targeting pure performance

means the gain is little to insignificant. Going through your code for this replacement is not worth it. You

*may*

only consider it for future code.

### Scheduled and Unscheduled Environment[Link](https://community.bistudio.com/wiki/Code_Optimisation#Scheduled_and_Unscheduled_Environment)

There are two code environment types, [Scheduler](https://community.bistudio.com/wiki/Scheduler#Scheduled_Environment) and [Scheduler](https://community.bistudio.com/wiki/Scheduler#Unscheduled_Environment).

- A **scheduled** script has an execution time limit of **3 ms** before being suspended to the benefit of another script until its turn comes back. It is a bit slower than unscheduled, but [canSuspend](https://community.bistudio.com/wiki/canSuspend) ([sleep](https://community.bistudio.com/wiki/sleep), [waitUntil](https://community.bistudio.com/wiki/waitUntil)) is allowed.
- An **unscheduled** script is not watched and will run without limitations. It is recommended for time-critical scripts, but [canSuspend](https://community.bistudio.com/wiki/canSuspend) ([sleep](https://community.bistudio.com/wiki/sleep), [waitUntil](https://community.bistudio.com/wiki/waitUntil)) is **not** allowed!

ⓘ

See [Scheduler](https://community.bistudio.com/wiki/Scheduler) for more information.

### Variable Assignment

[Link](https://community.bistudio.com/wiki/Code_Optimisation#Variable_Assignment)

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _myVar [=](https://community.bistudio.com/wiki/a_=_b) [33, 66] [select](https://community.bistudio.com/wiki/select) [false](https://community.bistudio.com/wiki/false); // 0.0013 ms [private](https://community.bistudio.com/wiki/private) _myVar [=](https://community.bistudio.com/wiki/a_=_b) [if](https://community.bistudio.com/wiki/if) ([false](https://community.bistudio.com/wiki/false)) [then](https://community.bistudio.com/wiki/then) { 33; } [else](https://community.bistudio.com/wiki/else) { 66; }; // 0.0020 ms [private](https://community.bistudio.com/wiki/private) "_myVar"; [if](https://community.bistudio.com/wiki/if) ([false](https://community.bistudio.com/wiki/false)) [then](https://community.bistudio.com/wiki/then) { _myVar [=](https://community.bistudio.com/wiki/a_=_b) 33; } [else](https://community.bistudio.com/wiki/else) { _myVar [=](https://community.bistudio.com/wiki/a_=_b) 66; }; // 0.0025 ms

### Lazy Evaluation

[Link](https://community.bistudio.com/wiki/Code_Optimisation#Lazy_Evaluation)

In [SQF Syntax](https://community.bistudio.com/wiki/SQF_Syntax) the following code will evaluate every single condition, even if one fails:

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) (a [&&](https://community.bistudio.com/wiki/a_&&_b) b [&&](https://community.bistudio.com/wiki/a_&&_b) c) [then](https://community.bistudio.com/wiki/then) {};

Even if a returns [false](https://community.bistudio.com/wiki/false) (and thus the entire [Boolean](https://community.bistudio.com/wiki/Boolean) expression can no longer become [true](https://community.bistudio.com/wiki/true)), b and c will still be executed and evaluated regardless.

To avoid this behaviour, one can either imbricate [if](https://community.bistudio.com/wiki/if) statements or use **lazy evaluation**. The latter is done like so:

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) (a [&&](https://community.bistudio.com/wiki/a_&&_b) { b [&&](https://community.bistudio.com/wiki/a_&&_b) { c } }) [then](https://community.bistudio.com/wiki/then) {};

In the example above, condition evaluation stops once any condition evaluates to [false](https://community.bistudio.com/wiki/false).

#### Influence on Semantics[Link](https://community.bistudio.com/wiki/Code_Optimisation#Influence_on_Semantics)

Depending on the arrangement of the curly brackets, lazy evaluation can change the precedence (and therefore the semantics) of a condition. Consider this example:

| Expression | Condition Value | Condition Value | Condition Value | Evaluated Conditions | Result |
| --- | --- | --- | --- | --- | --- |
| Expression |  |  |  | Evaluated Conditions | Result |
| a | b | c |  |  |  |
| Copy code to clipboard a [&&](https://community.bistudio.com/wiki/a_&&_b) b [\|\|](https://community.bistudio.com/wiki/a_or_b) c | [false](https://community.bistudio.com/wiki/false) | any [Boolean](https://community.bistudio.com/wiki/Boolean) | [true](https://community.bistudio.com/wiki/true) | a, b, c | [true](https://community.bistudio.com/wiki/true) |
|  | [false](https://community.bistudio.com/wiki/false) | any [Boolean](https://community.bistudio.com/wiki/Boolean) | [true](https://community.bistudio.com/wiki/true) |  |  |
|  | [false](https://community.bistudio.com/wiki/false) | any [Boolean](https://community.bistudio.com/wiki/Boolean) | [true](https://community.bistudio.com/wiki/true) |  |  |
| Copy code to clipboard a [&&](https://community.bistudio.com/wiki/a_&&_b) {b} [\|\|](https://community.bistudio.com/wiki/a_or_b) {c} | a, c | [true](https://community.bistudio.com/wiki/true) |  |  |  |
| Copy code to clipboard a [&&](https://community.bistudio.com/wiki/a_&&_b) {b [\|\|](https://community.bistudio.com/wiki/a_or_b) {c}} | a | [false](https://community.bistudio.com/wiki/false) |  |  |  |

#### Performance[Link](https://community.bistudio.com/wiki/Code_Optimisation#Performance)

Using lazy evaluation is not always the best way as it can both speed up and slow down the code, depending on the current condition being evaluated:

Copy code to clipboard

["true || { false || {false}}", [nil](https://community.bistudio.com/wiki/nil), 100000] [call](https://community.bistudio.com/wiki/call) [BIS_fnc_codePerformance](https://community.bistudio.com/wiki/BIS_fnc_codePerformance); // 0.00080 ms ["true || {false} || {false} ", [nil](https://community.bistudio.com/wiki/nil), 100000] [call](https://community.bistudio.com/wiki/call) [BIS_fnc_codePerformance](https://community.bistudio.com/wiki/BIS_fnc_codePerformance); // 0.00105 ms ["false || false || false ", [nil](https://community.bistudio.com/wiki/nil), 100000] [call](https://community.bistudio.com/wiki/call) [BIS_fnc_codePerformance](https://community.bistudio.com/wiki/BIS_fnc_codePerformance); // 0.00123 ms ["true || false || false ", [nil](https://community.bistudio.com/wiki/nil), 100000] [call](https://community.bistudio.com/wiki/call) [BIS_fnc_codePerformance](https://community.bistudio.com/wiki/BIS_fnc_codePerformance); // 0.00128 ms ["false || {false} || {false} ", [nil](https://community.bistudio.com/wiki/nil), 100000] [call](https://community.bistudio.com/wiki/call) [BIS_fnc_codePerformance](https://community.bistudio.com/wiki/BIS_fnc_codePerformance); // 0.00200 ms

### Concatenating Strings

[Link](https://community.bistudio.com/wiki/Code_Optimisation#Concatenating_Strings)

Copy code to clipboardmyString [=](https://community.bistudio.com/wiki/a_=_b) myString [+](https://community.bistudio.com/wiki/+) otherString works fine for small strings, however the bigger the string gets the slower the operation becomes:

Copy code to clipboard

myString [=](https://community.bistudio.com/wiki/a_=_b) ""; [for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 1 [to](https://community.bistudio.com/wiki/to) 10000 [do](https://community.bistudio.com/wiki/do) { myString [=](https://community.bistudio.com/wiki/a_=_b) myString [+](https://community.bistudio.com/wiki/+) "123" }; // 290 ms

The solution is to use a string array that you will concatenate later:

Copy code to clipboard

strings [=](https://community.bistudio.com/wiki/a_=_b) []; [for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 1 [to](https://community.bistudio.com/wiki/to) 10000 [do](https://community.bistudio.com/wiki/do) { strings [pushBack](https://community.bistudio.com/wiki/pushBack) "123" }; strings [=](https://community.bistudio.com/wiki/a_=_b) strings [joinString](https://community.bistudio.com/wiki/joinString) ""; // 30 ms

### Array Manipulation

[Link](https://community.bistudio.com/wiki/Code_Optimisation#Array_Manipulation)

#### Add Elements[Link](https://community.bistudio.com/wiki/Code_Optimisation#Add_Elements)

New commands [append](https://community.bistudio.com/wiki/append) and [pushBack](https://community.bistudio.com/wiki/pushBack) hold the best score.

Copy code to clipboard

_array [=](https://community.bistudio.com/wiki/a_=_b) [0,1,2,3]; _array [append](https://community.bistudio.com/wiki/append) [4,5,6]; // 0.0020 ms _array [=](https://community.bistudio.com/wiki/a_=_b) [0,1,2,3]; _array [=](https://community.bistudio.com/wiki/a_=_b) _array [+](https://community.bistudio.com/wiki/+) [4,5,6]; // 0.0023 ms _array [=](https://community.bistudio.com/wiki/a_=_b) [0,1,2,3]; { _array [set](https://community.bistudio.com/wiki/set) [[count](https://community.bistudio.com/wiki/count) _array, [_x](https://community.bistudio.com/wiki/Magic_Variables#x)]; } [forEach](https://community.bistudio.com/wiki/forEach) [4,5,6]; // 0.0080 ms

Copy code to clipboard

_array [=](https://community.bistudio.com/wiki/a_=_b) [0,1,2,3]; _array [pushBack](https://community.bistudio.com/wiki/pushBack) 4; // 0.0016 ms _array [=](https://community.bistudio.com/wiki/a_=_b) [0,1,2,3]; _array [=](https://community.bistudio.com/wiki/a_=_b) _array [+](https://community.bistudio.com/wiki/+) [4]; // 0.0021 ms _array [=](https://community.bistudio.com/wiki/a_=_b) [0,1,2,3]; _array [set](https://community.bistudio.com/wiki/set) [[count](https://community.bistudio.com/wiki/count) _array, [_x](https://community.bistudio.com/wiki/Magic_Variables#x)]; // 0.0022 ms

#### Iterate Elements[Link](https://community.bistudio.com/wiki/Code_Optimisation#Iterate_Elements)

**If [Magic Variables](https://community.bistudio.com/wiki/Magic_Variables#x) is not required**, [for](https://community.bistudio.com/wiki/for) is twice as fast as [forEach](https://community.bistudio.com/wiki/forEach) - otherwise, use [forEach](https://community.bistudio.com/wiki/forEach) (see results below).

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _list [=](https://community.bistudio.com/wiki/a_=_b) [allUnits](https://community.bistudio.com/wiki/allUnits); // 64 units 256 units // if the amount of loops is known [for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 0 [to](https://community.bistudio.com/wiki/to) 63 [do](https://community.bistudio.com/wiki/do) {}; // 0.0120 ms 0.0460 ms [for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 0 [to](https://community.bistudio.com/wiki/to) [count](https://community.bistudio.com/wiki/count) _list -1 [do](https://community.bistudio.com/wiki/do) {}; // 0.0170 ms 0.0480 ms [for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 0 [to](https://community.bistudio.com/wiki/to) [count](https://community.bistudio.com/wiki/count) _list -1 [do](https://community.bistudio.com/wiki/do) { [private](https://community.bistudio.com/wiki/private) [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [=](https://community.bistudio.com/wiki/a_=_b) _list [select](https://community.bistudio.com/wiki/select) _i }; // 0.0500 ms 0.1896 ms < [for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 0 [to](https://community.bistudio.com/wiki/to) [count](https://community.bistudio.com/wiki/count) _list -1 [do](https://community.bistudio.com/wiki/do) { [private](https://community.bistudio.com/wiki/private) [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [=](https://community.bistudio.com/wiki/a_=_b) _list [select](https://community.bistudio.com/wiki/select) _i; [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [setDamage](https://community.bistudio.com/wiki/setDamage) 0 }; // 0.107 ms 0.39 ms {} [forEach](https://community.bistudio.com/wiki/forEach) _list; // 0.0250 ms 0.098 ms { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [setDamage](https://community.bistudio.com/wiki/setDamage) 0 } [forEach](https://community.bistudio.com/wiki/forEach) _list; // 0.0770 ms 0.312 ms _list [apply](https://community.bistudio.com/wiki/apply) {}; // 0.0250 ms 0.098 ms _list [apply](https://community.bistudio.com/wiki/apply) { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [setDamage](https://community.bistudio.com/wiki/setDamage) 0 }; // 0.0770 ms 0.312 ms [private](https://community.bistudio.com/wiki/private) _i [=](https://community.bistudio.com/wiki/a_=_b) 0; [while](https://community.bistudio.com/wiki/while) { _i [<](https://community.bistudio.com/wiki/a_less_b) 64 } [do](https://community.bistudio.com/wiki/do) { _i [=](https://community.bistudio.com/wiki/a_=_b) _i [+](https://community.bistudio.com/wiki/+) 1; }; // 0.048 ms 0.200 ms // counts array every loop [private](https://community.bistudio.com/wiki/private) _i [=](https://community.bistudio.com/wiki/a_=_b) 0; [while](https://community.bistudio.com/wiki/while) { _i [<](https://community.bistudio.com/wiki/a_less_b) [count](https://community.bistudio.com/wiki/count) _list } [do](https://community.bistudio.com/wiki/do) { _i [=](https://community.bistudio.com/wiki/a_=_b) _i [+](https://community.bistudio.com/wiki/+) 1; }; // 0.062 ms 0.247 ms [private](https://community.bistudio.com/wiki/private) _i [=](https://community.bistudio.com/wiki/a_=_b) 0; [while](https://community.bistudio.com/wiki/while) { _i [<](https://community.bistudio.com/wiki/a_less_b) 64 } [do](https://community.bistudio.com/wiki/do) { [private](https://community.bistudio.com/wiki/private) [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [=](https://community.bistudio.com/wiki/a_=_b) _list [select](https://community.bistudio.com/wiki/select) _i; _i [=](https://community.bistudio.com/wiki/a_=_b) _i [+](https://community.bistudio.com/wiki/+) 1; }; // 0.086 ms 0.42 ms

#### Remove Elements[Link](https://community.bistudio.com/wiki/Code_Optimisation#Remove_Elements)

Copy code to clipboard

_array [=](https://community.bistudio.com/wiki/a_=_b) [0,1,2,3]; _array [deleteAt](https://community.bistudio.com/wiki/deleteAt) 0; // 0.0015 ms _array [=](https://community.bistudio.com/wiki/a_=_b) [0,1,2,3]; _array [set](https://community.bistudio.com/wiki/set) [0, [objNull](https://community.bistudio.com/wiki/objNull)]; _array [=](https://community.bistudio.com/wiki/a_=_b) _array [-](https://community.bistudio.com/wiki/-) [[objNull](https://community.bistudio.com/wiki/objNull)]; // 0.0038 ms

Copy code to clipboard

_array [=](https://community.bistudio.com/wiki/a_=_b) [0,1,2,3]; _array [deleteRange](https://community.bistudio.com/wiki/deleteRange) [1, 2]; // 0.0018 ms _array [=](https://community.bistudio.com/wiki/a_=_b) [0,1,2,3]; { _array [set](https://community.bistudio.com/wiki/set) [[_x](https://community.bistudio.com/wiki/Magic_Variables#x), [objNull](https://community.bistudio.com/wiki/objNull)] } [forEach](https://community.bistudio.com/wiki/forEach) [1,2]; _array [=](https://community.bistudio.com/wiki/a_=_b) _array [-](https://community.bistudio.com/wiki/-) [[objNull](https://community.bistudio.com/wiki/objNull)]; // 0.0078 ms

### Multiplayer Recommendations

[Link](https://community.bistudio.com/wiki/Code_Optimisation#Multiplayer_Recommendations)

- Do not saturate the network with information: [publicVariable](https://community.bistudio.com/wiki/publicVariable) or public [setVariable](https://community.bistudio.com/wiki/setVariable) shouldn't be used at high frequency, else **everyone's performance experience** is at risk!
- The server is supposed to have a good CPU and a lot of memory, use it: store functions, run them from it, send only the result to the clients
- [publicVariable](https://community.bistudio.com/wiki/publicVariable) and [setVariable](https://community.bistudio.com/wiki/setVariable) variable name length impacts network, be sure to send well-named, understandable variables
(*and not **playerNameBecauseThePlayerIsImportantAndWeNeedToKnowWhoTheyAreAllTheTimeEspeciallyInsideThisImpressiveFunction***)
- Use, use and use [remoteExec](https://community.bistudio.com/wiki/remoteExec) & [remoteExecCall](https://community.bistudio.com/wiki/remoteExecCall). Ditch [BIS fnc MP](https://community.bistudio.com/wiki/BIS_fnc_MP) for good!

ⓘ

See [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting) for more information.

## Equivalent Commands Performance[Link](https://community.bistudio.com/wiki/Code_Optimisation#Equivalent_Commands_Performance)

### call

[Link](https://community.bistudio.com/wiki/Code_Optimisation#call)

[call](https://community.bistudio.com/wiki/call) without arguments is faster than call with arguments:

Copy code to clipboard

[call](https://community.bistudio.com/wiki/call) {}; // 0.0007 ms 123 [call](https://community.bistudio.com/wiki/call) {}; // 0.0013 ms

Since the variables defined in the parent scope will be available in the [call](https://community.bistudio.com/wiki/call) child scope, it could be possible to speed up the code by avoiding passing arguments all together, for example writing:

Copy code to clipboard

[player](https://community.bistudio.com/wiki/player) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HandleDamage", { [call](https://community.bistudio.com/wiki/call) my_fnc_damage }];

instead of:

Copy code to clipboard

[player](https://community.bistudio.com/wiki/player) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HandleDamage", { [_this](https://community.bistudio.com/wiki/Magic_Variables#this) [call](https://community.bistudio.com/wiki/call) my_fnc_damage }];

### execVM and call

[Link](https://community.bistudio.com/wiki/Code_Optimisation#execVM_and_call)

⚠

Using [execVM](https://community.bistudio.com/wiki/execVM) multiple times make the game read the file and recompile it every time.
 If you use the script more than once, store its code in a variable or better, make it a [Arma 3: Functions Library](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)!

Copy code to clipboard

// myFile.sqf is an EMPTY file [private](https://community.bistudio.com/wiki/private) _myFunction [=](https://community.bistudio.com/wiki/a_=_b) [compile](https://community.bistudio.com/wiki/compile) [preprocessFileLineNumbers](https://community.bistudio.com/wiki/preprocessFileLineNumbers) "myFile.sqf"; // compile time is done only once [call](https://community.bistudio.com/wiki/call) _myFunction; // 0.0009 ms [execVM](https://community.bistudio.com/wiki/execVM) "myFile.sqf"; // 0.275 ms // myFile.sqf is BIS_fnc_showRespawnMenu [private](https://community.bistudio.com/wiki/private) _myFunction [=](https://community.bistudio.com/wiki/a_=_b) [compile](https://community.bistudio.com/wiki/compile) [preprocessFileLineNumbers](https://community.bistudio.com/wiki/preprocessFileLineNumbers) "myFile.sqf"; // compile time is done only once ["close"] [call](https://community.bistudio.com/wiki/call) _myFunction; // 0.0056 ms ["close"] [execVM](https://community.bistudio.com/wiki/execVM) "myFile.sqf"; // 0.506 ms

### loadFile, preprocessFile and preprocessFileLineNumbers

[Link](https://community.bistudio.com/wiki/Code_Optimisation#loadFile,_preprocessFile_and_preprocessFileLineNumbers)

Copy code to clipboard

// myFile.sqf is an empty file [loadFile](https://community.bistudio.com/wiki/loadFile) "myFile.sqf"; // 0.219 ms [preprocessFile](https://community.bistudio.com/wiki/preprocessFile) "myFile.sqf"; // 0.353 ms [preprocessFileLineNumbers](https://community.bistudio.com/wiki/preprocessFileLineNumbers) "myFile.sqf"; // 0.355 ms

Copy code to clipboard

// myFile.sqf is BIS_fnc_showRespawnMenu [loadFile](https://community.bistudio.com/wiki/loadFile) "myFile.sqf"; // 0.3516 ms [preprocessFile](https://community.bistudio.com/wiki/preprocessFile) "myFile.sqf"; // 2.75 ms [preprocessFileLineNumbers](https://community.bistudio.com/wiki/preprocessFileLineNumbers) "myFile.sqf"; // 2.73 ms

Copy code to clipboard

// myFile.sqf is a missing file [loadFile](https://community.bistudio.com/wiki/loadFile) "myFile.sqf"; // 0.692 ms [preprocessFile](https://community.bistudio.com/wiki/preprocessFile) "myFile.sqf"; // 0.6225 ms [preprocessFileLineNumbers](https://community.bistudio.com/wiki/preprocessFileLineNumbers) "myFile.sqf"; // 0.6225 ms

⚠

The comparison of [loadFile](https://community.bistudio.com/wiki/loadFile) with preprocessFile* is not exactly fair as [loadFile](https://community.bistudio.com/wiki/loadFile) doesn't preprocess the file's content.
 On the other hand, the loaded file cannot contain any Copy code to clipboard// or Copy code to clipboard/* */ comments nor any [PreProcessor Commands](https://community.bistudio.com/wiki/PreProcessor_Commands) (including debug information like line numbers or file information).

### if

[Link](https://community.bistudio.com/wiki/Code_Optimisation#if)

Copy code to clipboard

[if](https://community.bistudio.com/wiki/if) (condition) [then](https://community.bistudio.com/wiki/then) { /* thenCode */ }; // 0.0011 ms [if](https://community.bistudio.com/wiki/if) (condition) [exitWith](https://community.bistudio.com/wiki/exitWith) { /* exitCode */ }; // 0.0014 ms [if](https://community.bistudio.com/wiki/if) (condition) [then](https://community.bistudio.com/wiki/then) { /* thenCode */ } [else](https://community.bistudio.com/wiki/else) { /* elseCode */ }; // 0.0015 ms [if](https://community.bistudio.com/wiki/if) (condition) [then](https://community.bistudio.com/wiki/then) [{ /* thenCode */ }, { /* elseCode */ }]; // 0.0016 ms

### if and select

[Link](https://community.bistudio.com/wiki/Code_Optimisation#if_and_select)

Use Copy code to clipboard[array] [select](https://community.bistudio.com/wiki/select) boolean instead of the lazy-evaluated [if](https://community.bistudio.com/wiki/if).

Copy code to clipboard

_result [=](https://community.bistudio.com/wiki/a_=_b) ["false result", "true result"] [select](https://community.bistudio.com/wiki/select) [true](https://community.bistudio.com/wiki/true); // 0.0011 ms _result [=](https://community.bistudio.com/wiki/a_=_b) [if](https://community.bistudio.com/wiki/if) ([true](https://community.bistudio.com/wiki/true)) [then](https://community.bistudio.com/wiki/then) { "true result"; } [else](https://community.bistudio.com/wiki/else) { "false result"; }; // 0.0017 ms

### if and switch

[Link](https://community.bistudio.com/wiki/Code_Optimisation#if_and_switch)

Copy code to clipboard

_result [=](https://community.bistudio.com/wiki/a_=_b) [call](https://community.bistudio.com/wiki/call) { [if](https://community.bistudio.com/wiki/if) ([false](https://community.bistudio.com/wiki/false)) [exitWith](https://community.bistudio.com/wiki/exitWith) {}; [if](https://community.bistudio.com/wiki/if) ([false](https://community.bistudio.com/wiki/false)) [exitWith](https://community.bistudio.com/wiki/exitWith) {}; [if](https://community.bistudio.com/wiki/if) ([true](https://community.bistudio.com/wiki/true)) [exitWith](https://community.bistudio.com/wiki/exitWith) {}; [if](https://community.bistudio.com/wiki/if) ([false](https://community.bistudio.com/wiki/false)) [exitWith](https://community.bistudio.com/wiki/exitWith) {}; [if](https://community.bistudio.com/wiki/if) ([false](https://community.bistudio.com/wiki/false)) [exitWith](https://community.bistudio.com/wiki/exitWith) {}; }; // 0.0032 ms

Copy code to clipboard

_result [=](https://community.bistudio.com/wiki/a_=_b) [switch](https://community.bistudio.com/wiki/switch) ([true](https://community.bistudio.com/wiki/true)) [do](https://community.bistudio.com/wiki/do) { [case](https://community.bistudio.com/wiki/case) ([false](https://community.bistudio.com/wiki/false))[:](https://community.bistudio.com/wiki/a_:_b) {}; [case](https://community.bistudio.com/wiki/case) ([false](https://community.bistudio.com/wiki/false))[:](https://community.bistudio.com/wiki/a_:_b) {}; [case](https://community.bistudio.com/wiki/case) ([true](https://community.bistudio.com/wiki/true)) [:](https://community.bistudio.com/wiki/a_:_b) {}; [case](https://community.bistudio.com/wiki/case) ([false](https://community.bistudio.com/wiki/false))[:](https://community.bistudio.com/wiki/a_:_b) {}; [case](https://community.bistudio.com/wiki/case) ([false](https://community.bistudio.com/wiki/false))[:](https://community.bistudio.com/wiki/a_:_b) {}; }; // 0.0047 ms

### if else and switch

[Link](https://community.bistudio.com/wiki/Code_Optimisation#if_else_and_switch)

Copy code to clipboard

_mode [=](https://community.bistudio.com/wiki/a_=_b) "killed"; [switch](https://community.bistudio.com/wiki/switch) _mode [do](https://community.bistudio.com/wiki/do) { [case](https://community.bistudio.com/wiki/case) "init"[:](https://community.bistudio.com/wiki/a_:_b) {}; [case](https://community.bistudio.com/wiki/case) "killed"[:](https://community.bistudio.com/wiki/a_:_b) {}; [case](https://community.bistudio.com/wiki/case) "respawned"[:](https://community.bistudio.com/wiki/a_:_b) {}; }; // 0.0019 ms

Copy code to clipboard

_mode [=](https://community.bistudio.com/wiki/a_=_b) "killed"; [if](https://community.bistudio.com/wiki/if) (_mode [==](https://community.bistudio.com/wiki/a_==_b) "init") [then](https://community.bistudio.com/wiki/then) {} [else](https://community.bistudio.com/wiki/else) { [if](https://community.bistudio.com/wiki/if) (_mode [==](https://community.bistudio.com/wiki/a_==_b) "killed") [then](https://community.bistudio.com/wiki/then) {} [else](https://community.bistudio.com/wiki/else) { [if](https://community.bistudio.com/wiki/if) (_mode [==](https://community.bistudio.com/wiki/a_==_b) "respawned") [then](https://community.bistudio.com/wiki/then) {}; }; }; // 0.0019 ms

### in vs find

[Link](https://community.bistudio.com/wiki/Code_Optimisation#in_vs_find)

Copy code to clipboard

// String search "bar" [in](https://community.bistudio.com/wiki/in) "foobar" // 0.0008 ms "foobar" [find](https://community.bistudio.com/wiki/find) "bar" [>](https://community.bistudio.com/wiki/a_greater_b) -1 // 0.0012 ms

Copy code to clipboard

// array search - case-sensitive "bar" [in](https://community.bistudio.com/wiki/in) ["foo", "Bar", "bar", "BAR"]; // 0.0012 ms ["foo", "Bar", "bar", "BAR"] [find](https://community.bistudio.com/wiki/find) "bar" [>](https://community.bistudio.com/wiki/a_greater_b) -1; // 0.0016 ms

### for

[Link](https://community.bistudio.com/wiki/Code_Optimisation#for)

The [for](https://community.bistudio.com/wiki/for)..[from](https://community.bistudio.com/wiki/from)..[to](https://community.bistudio.com/wiki/to)..[do](https://community.bistudio.com/wiki/do) is twice as fast as its alternative syntax, [for](https://community.bistudio.com/wiki/for)..[do](https://community.bistudio.com/wiki/do).

Copy code to clipboard

[for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 0 [to](https://community.bistudio.com/wiki/to) 10 [do](https://community.bistudio.com/wiki/do) { /* forCode */ }; // 0.015 ms [for](https://community.bistudio.com/wiki/for) [{ _i [=](https://community.bistudio.com/wiki/a_=_b) 0 }, { _i [<](https://community.bistudio.com/wiki/a_less_b) 100 }, { _i [=](https://community.bistudio.com/wiki/a_=_b) _i [+](https://community.bistudio.com/wiki/+) 1 }] [do](https://community.bistudio.com/wiki/do) { /* forCode */ }; // 0.030 ms

### forEach vs count vs findIf

[Link](https://community.bistudio.com/wiki/Code_Optimisation#forEach_vs_count_vs_findIf)

Both [forEach](https://community.bistudio.com/wiki/forEach) and [count](https://community.bistudio.com/wiki/count) commands will step through *all* the array elements and both commands will contain reference to current element with the [Magic Variables](https://community.bistudio.com/wiki/Magic_Variables#x) variable. However, [count](https://community.bistudio.com/wiki/count) loop is a little faster than [forEach](https://community.bistudio.com/wiki/forEach) loop, but it does not benefit from the [Magic Variables](https://community.bistudio.com/wiki/Magic_Variables#forEachIndex) variable.
 Also, there is a limitation as the code inside [count](https://community.bistudio.com/wiki/count) expects [Boolean](https://community.bistudio.com/wiki/Boolean) or [Nothing](https://community.bistudio.com/wiki/Nothing) while the command itself returns [Number](https://community.bistudio.com/wiki/Number). This limitation is very important if you try to replace your [forEach](https://community.bistudio.com/wiki/forEach) by [count](https://community.bistudio.com/wiki/count). If you have to add an extra [true](https://community.bistudio.com/wiki/true)/[false](https://community.bistudio.com/wiki/false)/[nil](https://community.bistudio.com/wiki/nil) at the end to make [count](https://community.bistudio.com/wiki/count) work, it will be slower than the [forEach](https://community.bistudio.com/wiki/forEach) equivalent.

Copy code to clipboard

{ [diag_log](https://community.bistudio.com/wiki/diag_log) [_x](https://community.bistudio.com/wiki/Magic_Variables#x) } [count](https://community.bistudio.com/wiki/count) [1,2,3,4,5]; // 0.082 ms { [diag_log](https://community.bistudio.com/wiki/diag_log) [_x](https://community.bistudio.com/wiki/Magic_Variables#x) } [forEach](https://community.bistudio.com/wiki/forEach) [1,2,3,4,5]; // 0.083 ms

Copy code to clipboard

// with an empty array _someoneIsNear [=](https://community.bistudio.com/wiki/a_=_b) ([allUnits](https://community.bistudio.com/wiki/allUnits) [findIf](https://community.bistudio.com/wiki/findIf) { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [distance](https://community.bistudio.com/wiki/distance) [0,0,0] [<](https://community.bistudio.com/wiki/a_less_b) 1000 }) [!=](https://community.bistudio.com/wiki/a_!=_b) -1; // 0.0046 ms _someoneIsNear [=](https://community.bistudio.com/wiki/a_=_b) { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [distance](https://community.bistudio.com/wiki/distance) [0,0,0] [<](https://community.bistudio.com/wiki/a_less_b) 1000 } [count](https://community.bistudio.com/wiki/count) [allUnits](https://community.bistudio.com/wiki/allUnits) [>](https://community.bistudio.com/wiki/a_greater_b) 0; // 0.0047 ms < _someoneIsNear [=](https://community.bistudio.com/wiki/a_=_b) { [if](https://community.bistudio.com/wiki/if) ([_x](https://community.bistudio.com/wiki/Magic_Variables#x) [distance](https://community.bistudio.com/wiki/distance) [0,0,0] [<](https://community.bistudio.com/wiki/a_less_b) 1000) [exitWith](https://community.bistudio.com/wiki/exitWith) { [true](https://community.bistudio.com/wiki/true) }; [false](https://community.bistudio.com/wiki/false) } [forEach](https://community.bistudio.com/wiki/forEach) [allUnits](https://community.bistudio.com/wiki/allUnits); // 0.0060 ms

Copy code to clipboard

// with a 30 items array _someoneIsNear [=](https://community.bistudio.com/wiki/a_=_b) ([allUnits](https://community.bistudio.com/wiki/allUnits) [findIf](https://community.bistudio.com/wiki/findIf) { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [distance](https://community.bistudio.com/wiki/distance) [0,0,0] [<](https://community.bistudio.com/wiki/a_less_b) 1000 }) [!=](https://community.bistudio.com/wiki/a_!=_b) -1; // 0.0275 ms _someoneIsNear [=](https://community.bistudio.com/wiki/a_=_b) { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [distance](https://community.bistudio.com/wiki/distance) [0,0,0] [<](https://community.bistudio.com/wiki/a_less_b) 1000 } [count](https://community.bistudio.com/wiki/count) [allUnits](https://community.bistudio.com/wiki/allUnits) [>](https://community.bistudio.com/wiki/a_greater_b) 0; // 0.0645 ms < _someoneIsNear [=](https://community.bistudio.com/wiki/a_=_b) { [if](https://community.bistudio.com/wiki/if) ([_x](https://community.bistudio.com/wiki/Magic_Variables#x) [distance](https://community.bistudio.com/wiki/distance) [0,0,0] [<](https://community.bistudio.com/wiki/a_less_b) 1000) [exitWith](https://community.bistudio.com/wiki/exitWith) { [true](https://community.bistudio.com/wiki/true) }; [false](https://community.bistudio.com/wiki/false) } [forEach](https://community.bistudio.com/wiki/forEach) [allUnits](https://community.bistudio.com/wiki/allUnits); // 0.0390 ms

### findIf

[Link](https://community.bistudio.com/wiki/Code_Optimisation#findIf)

[findIf](https://community.bistudio.com/wiki/findIf) stops array iteration as soon as the condition is met.

Copy code to clipboard

[0,1,2,3,4,5,6,7,8,9] [findIf](https://community.bistudio.com/wiki/findIf) { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [==](https://community.bistudio.com/wiki/a_==_b) 2 }; // 0.0050 ms { [if](https://community.bistudio.com/wiki/if) ([_x](https://community.bistudio.com/wiki/Magic_Variables#x) [==](https://community.bistudio.com/wiki/a_==_b) 2) [exitWith](https://community.bistudio.com/wiki/exitWith) { [_forEachIndex](https://community.bistudio.com/wiki/Magic_Variables#forEachIndex); }; } [forEach](https://community.bistudio.com/wiki/forEach) [0,1,2,3,4,5,6,7,8,9]; // 0.0078 ms _quantity [=](https://community.bistudio.com/wiki/a_=_b) { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [==](https://community.bistudio.com/wiki/a_==_b) 2 } [count](https://community.bistudio.com/wiki/count) [0,1,2,3,4,5,6,7,8,9]; // 0.0114 ms

### format vs str

[Link](https://community.bistudio.com/wiki/Code_Optimisation#format_vs_str)

Copy code to clipboard

[str](https://community.bistudio.com/wiki/str) 33; // 0.0016 ms [format](https://community.bistudio.com/wiki/format) ["%1", 33]; // 0.0022 ms

### + vs format vs joinString

[Link](https://community.bistudio.com/wiki/Code_Optimisation#+_vs_format_vs_joinString)

non-[String](https://community.bistudio.com/wiki/String) data:

Copy code to clipboard

[33, 45, 78] [joinString](https://community.bistudio.com/wiki/joinString) ""; // 0.0052 ms - no length limit [format](https://community.bistudio.com/wiki/format) ["%1%2%3", 33, 45, 78]; // 0.0054 ms - limited to ~8Kb [str](https://community.bistudio.com/wiki/str) 33 [+](https://community.bistudio.com/wiki/+) [str](https://community.bistudio.com/wiki/str) 45 [+](https://community.bistudio.com/wiki/+) [str](https://community.bistudio.com/wiki/str) 78; // 0.0059 ms - no length limit

[String](https://community.bistudio.com/wiki/String) data:

Copy code to clipboard

["str1", "str2", "str3"] [joinString](https://community.bistudio.com/wiki/joinString) ""; // 0.0015 ms - no length limit [format](https://community.bistudio.com/wiki/format) ["%1%2%3", "str1", "str2", "str3"]; // 0.0015 ms - limited to ~8Kb "str1" [+](https://community.bistudio.com/wiki/+) "str2" [+](https://community.bistudio.com/wiki/+) "str3"; // 0.0012 ms - no length limit

### private

[Link](https://community.bistudio.com/wiki/Code_Optimisation#private)

Direct declaration (Copy code to clipboard[private](https://community.bistudio.com/wiki/private) _var [=](https://community.bistudio.com/wiki/a_=_b) value) is faster than declaring *then* assigning the variable.

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _a [=](https://community.bistudio.com/wiki/a_=_b) 1; [private](https://community.bistudio.com/wiki/private) _b [=](https://community.bistudio.com/wiki/a_=_b) 2; [private](https://community.bistudio.com/wiki/private) _c [=](https://community.bistudio.com/wiki/a_=_b) 3; [private](https://community.bistudio.com/wiki/private) _d [=](https://community.bistudio.com/wiki/a_=_b) 4; // 0.0023 ms

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) ["_a", "_b", "_c", "_d"]; _a [=](https://community.bistudio.com/wiki/a_=_b) 1; _b [=](https://community.bistudio.com/wiki/a_=_b) 2; _c [=](https://community.bistudio.com/wiki/a_=_b) 3; _d [=](https://community.bistudio.com/wiki/a_=_b) 4; // 0.0040 ms

However, if you have to reuse the same variable in a loop, external declaration is faster.
 The reason behind this is that a declaration in the loop will create, assign and delete the variable in each loop.
 An external declaration creates the variable only once and the loop only assigns the value.

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) ["_a", "_b", "_c", "_d"]; [for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 1 [to](https://community.bistudio.com/wiki/to) 10 [do](https://community.bistudio.com/wiki/do) { _a [=](https://community.bistudio.com/wiki/a_=_b) 1; _b [=](https://community.bistudio.com/wiki/a_=_b) 2; _c [=](https://community.bistudio.com/wiki/a_=_b) 3; _d [=](https://community.bistudio.com/wiki/a_=_b) 4; }; // 0.0195 ms

Copy code to clipboard

[for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 1 [to](https://community.bistudio.com/wiki/to) 10 [do](https://community.bistudio.com/wiki/do) { [private](https://community.bistudio.com/wiki/private) _a [=](https://community.bistudio.com/wiki/a_=_b) 1; [private](https://community.bistudio.com/wiki/private) _b [=](https://community.bistudio.com/wiki/a_=_b) 2; [private](https://community.bistudio.com/wiki/private) _c [=](https://community.bistudio.com/wiki/a_=_b) 3; [private](https://community.bistudio.com/wiki/private) _d [=](https://community.bistudio.com/wiki/a_=_b) 4; }; // 0.0235 ms

### isNil

[Link](https://community.bistudio.com/wiki/Code_Optimisation#isNil)

Copy code to clipboard

[isNil](https://community.bistudio.com/wiki/isNil) "varName"; // 0.0007 ms [isNil](https://community.bistudio.com/wiki/isNil) { varName }; // 0.0012 ms

### isEqualType and typeName

[Link](https://community.bistudio.com/wiki/Code_Optimisation#isEqualType_and_typeName)

[isEqualType](https://community.bistudio.com/wiki/isEqualType) is much faster than [typeName](https://community.bistudio.com/wiki/typeName)

Copy code to clipboard

"string" [isEqualType](https://community.bistudio.com/wiki/isEqualType) 33; // 0.0006 ms [typeName](https://community.bistudio.com/wiki/typeName) "string" [==](https://community.bistudio.com/wiki/a_==_b) [typeName](https://community.bistudio.com/wiki/typeName) 33; // 0.0018 ms

### isEqualTo and count

[Link](https://community.bistudio.com/wiki/Code_Optimisation#isEqualTo_and_count)

Copy code to clipboard

// with a items array [allUnits](https://community.bistudio.com/wiki/allUnits) [isEqualTo](https://community.bistudio.com/wiki/isEqualTo) []; // 0.0040 ms [count](https://community.bistudio.com/wiki/count) [allUnits](https://community.bistudio.com/wiki/allUnits) [==](https://community.bistudio.com/wiki/a_==_b) 0; // 0.0043 ms

### select and param

[Link](https://community.bistudio.com/wiki/Code_Optimisation#select_and_param)

Copy code to clipboard

[1,2,3] [select](https://community.bistudio.com/wiki/select) 0; // 0.0008 ms [1,2,3] [param](https://community.bistudio.com/wiki/param) [0]; // 0.0011 ms

### createSimpleObject vs createVehicle

[Link](https://community.bistudio.com/wiki/Code_Optimisation#createSimpleObject_vs_createVehicle)

Copy code to clipboard

// createSimpleObject is over 43× faster than createVehicle! [deleteVehicle](https://community.bistudio.com/wiki/deleteVehicle) [createSimpleObject](https://community.bistudio.com/wiki/createSimpleObject) ["a3\structures_f_mark\vr\shapes\vr_shape_01_cube_1m_f.p3d", [0,0,0]]; // ~0.08 ms [deleteVehicle](https://community.bistudio.com/wiki/deleteVehicle) [createSimpleObject](https://community.bistudio.com/wiki/createSimpleObject) ["Land_VR_Shape_01_cube_1m_F", [0,0,0]]; // ~3.2 ms [deleteVehicle](https://community.bistudio.com/wiki/deleteVehicle) [createVehicle](https://community.bistudio.com/wiki/createVehicle) ["Land_VR_Shape_01_cube_1m_F", [0,0,0], [], 0, "CAN_COLLIDE"]; // ~2.7 ms [deleteVehicle](https://community.bistudio.com/wiki/deleteVehicle) [createVehicle](https://community.bistudio.com/wiki/createVehicle) ["Land_VR_Shape_01_cube_1m_F", [0,0,0], [], 0, "NONE"]; // ~78 ms

### objectParent and vehicle

[Link](https://community.bistudio.com/wiki/Code_Optimisation#objectParent_and_vehicle)

Copy code to clipboard

[isNull](https://community.bistudio.com/wiki/isNull) [objectParent](https://community.bistudio.com/wiki/objectParent) [player](https://community.bistudio.com/wiki/player); // 0.0013 ms [vehicle](https://community.bistudio.com/wiki/vehicle) [player](https://community.bistudio.com/wiki/player) [==](https://community.bistudio.com/wiki/a_==_b) [player](https://community.bistudio.com/wiki/player); // 0.0022 ms

[Link](https://community.bistudio.com/wiki/File:nearEntities_vs_nearestObjects.png)

[Enlarge](https://community.bistudio.com/wiki/File:nearEntities_vs_nearestObjects.png)

nearEntities vs nearestObjects

### nearEntities and nearestObjects

[Link](https://community.bistudio.com/wiki/Code_Optimisation#nearEntities_and_nearestObjects)

[nearEntities](https://community.bistudio.com/wiki/nearEntities) is much faster than [nearestObjects](https://community.bistudio.com/wiki/nearestObjects) given on range and amount of objects within the given range. If range is over 100 meters it is highly recommended to use [nearEntities](https://community.bistudio.com/wiki/nearEntities) over [nearestObjects](https://community.bistudio.com/wiki/nearestObjects).

Copy code to clipboard

// tested with a NATO rifle squad amongst solar power plant panels on Altis at coordinates [20762,15837] [getPosATL](https://community.bistudio.com/wiki/getPosATL) [player](https://community.bistudio.com/wiki/player) [nearEntities](https://community.bistudio.com/wiki/nearEntities) [["CAManBase"], 50]; // 0.0075 ms [nearestObjects](https://community.bistudio.com/wiki/nearestObjects) [[getPosATL](https://community.bistudio.com/wiki/getPosATL) [player](https://community.bistudio.com/wiki/player), ["CAManBase"], 50]; // 0.0145 ms

⚠

[nearEntities](https://community.bistudio.com/wiki/nearEntities) only searches for [alive](https://community.bistudio.com/wiki/alive) objects and on-foot soldiers.
 In-vehicle units, killed units, destroyed vehicles, static objects and buildings will be ignored.

### Global Variables vs Local Variables

[Link](https://community.bistudio.com/wiki/Code_Optimisation#Global_Variables_vs_Local_Variables)

If you need to use global variable repeatedly in a loop, copy its value to local variable and use local variable instead:

Copy code to clipboard

SomeGlobalVariable [=](https://community.bistudio.com/wiki/a_=_b) [123]; [for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 1 [to](https://community.bistudio.com/wiki/to) 100 [do](https://community.bistudio.com/wiki/do) { SomeGlobalVariable [select](https://community.bistudio.com/wiki/select) 0; }; // 0.13 ms

is noticeably slower than

Copy code to clipboard

SomeGlobalVariable [=](https://community.bistudio.com/wiki/a_=_b) [123]; [private](https://community.bistudio.com/wiki/private) _var [=](https://community.bistudio.com/wiki/a_=_b) SomeGlobalVariable; [for](https://community.bistudio.com/wiki/for) "_i" [from](https://community.bistudio.com/wiki/from) 1 [to](https://community.bistudio.com/wiki/to) 100 [do](https://community.bistudio.com/wiki/do) { _var [select](https://community.bistudio.com/wiki/select) 0; }; // 0.08 ms

### Config path delimiter

[Link](https://community.bistudio.com/wiki/Code_Optimisation#Config_path_delimiter)

[config greater greater name](https://community.bistudio.com/wiki/config_greater_greater_name) is slightly faster than [a / b](https://community.bistudio.com/wiki/a_/_b) when used in config path with [configFile](https://community.bistudio.com/wiki/configFile) or [missionConfigFile](https://community.bistudio.com/wiki/missionConfigFile).

Copy code to clipboard

[configFile](https://community.bistudio.com/wiki/configFile) [>>](https://community.bistudio.com/wiki/config_greater_greater_name) "CfgVehicles"; // 0.0019 ms [configFile](https://community.bistudio.com/wiki/configFile) [/](https://community.bistudio.com/wiki/a_/_b) "CfgVehicles"; // 0.0023 ms

ⓘ

A config path can be stored in a variable for later use, saving CPU time: Copy code to clipboard_cfgVehicles [=](https://community.bistudio.com/wiki/a_=_b) [configFile](https://community.bistudio.com/wiki/configFile) [>>](https://community.bistudio.com/wiki/config_greater_greater_name) "CfgVehicles".

### getPos* and setPos*

[Link](https://community.bistudio.com/wiki/Code_Optimisation#getPos*_and_setPos*)

Copy code to clipboard

[getPosWorld](https://community.bistudio.com/wiki/getPosWorld) // 0.0015 ms [getPosASL](https://community.bistudio.com/wiki/getPosASL) // 0.0016 ms [getPosATL](https://community.bistudio.com/wiki/getPosATL) // 0.0016 ms [getPosASLW](https://community.bistudio.com/wiki/getPosASLW) // 0.0023 ms [getPos](https://community.bistudio.com/wiki/getPos) // 0.0030-0.0300 ms; performance depends on where this command is used - see its documentation [position](https://community.bistudio.com/wiki/position) // same as getPos [getPosVisual](https://community.bistudio.com/wiki/getPosVisual) // same as getPos [visiblePosition](https://community.bistudio.com/wiki/visiblePosition) // same as getPos

Copy code to clipboard

[setPosWorld](https://community.bistudio.com/wiki/setPosWorld) // 0.0060 ms [setPosASL](https://community.bistudio.com/wiki/setPosASL) // 0.0060 ms [setPosATL](https://community.bistudio.com/wiki/setPosATL) // 0.0060 ms [setPos](https://community.bistudio.com/wiki/setPos) // 0.0063 ms [setPosASLW](https://community.bistudio.com/wiki/setPosASLW) // 0.0068 ms [setVehiclePosition](https://community.bistudio.com/wiki/setVehiclePosition) // 0.0077 ms with "CAN_COLLIDE" // 0.0390 ms with "NONE"

### toLower/toUpper vs toLowerANSI/toUpperANSI

[Link](https://community.bistudio.com/wiki/Code_Optimisation#toLower/toUpper_vs_toLowerANSI/toUpperANSI)

Copy code to clipboard

// _myString is a 100 chars "aAaAaA(…)" string [toLowerANSI](https://community.bistudio.com/wiki/toLowerANSI) _myString; // 0.0006 ms [toLower](https://community.bistudio.com/wiki/toLower) _myString; // 0.0016 ms [toUpperANSI](https://community.bistudio.com/wiki/toUpperANSI) _myString; // 0.0006 ms [toUpper](https://community.bistudio.com/wiki/toUpper) _myString; // 0.0016 ms

## Equivalent Data Structures Performance[Link](https://community.bistudio.com/wiki/Code_Optimisation#Equivalent_Data_Structures_Performance)

### Key-Value Data Structures[Link](https://community.bistudio.com/wiki/Code_Optimisation#Key-Value_Data_Structures)

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _hashMap [=](https://community.bistudio.com/wiki/a_=_b) [createHashMapFromArray](https://community.bistudio.com/wiki/createHashMapFromArray) [["id", 123], ["name", "player name"], ["unit", [player](https://community.bistudio.com/wiki/player)]]; // since Arma 3 v2.02 [private](https://community.bistudio.com/wiki/private) _goodFormat [=](https://community.bistudio.com/wiki/a_=_b) [["id", "name", "unit"], [123, "player name", [player](https://community.bistudio.com/wiki/player)]]; [private](https://community.bistudio.com/wiki/private) _slowFormat [=](https://community.bistudio.com/wiki/a_=_b) [["id", 123], ["name", "player name"], ["unit", [player](https://community.bistudio.com/wiki/player)]];

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _name [=](https://community.bistudio.com/wiki/a_=_b) _hashMap [get](https://community.bistudio.com/wiki/get) "name"; // 0.0018ms // this takes 0.0038ms: [private](https://community.bistudio.com/wiki/private) _index [=](https://community.bistudio.com/wiki/a_=_b) _goodFormat [select](https://community.bistudio.com/wiki/select) 0 [find](https://community.bistudio.com/wiki/find) "name"; // loop in engine [private](https://community.bistudio.com/wiki/private) _name [=](https://community.bistudio.com/wiki/a_=_b) _goodFormat [select](https://community.bistudio.com/wiki/select) 1 [select](https://community.bistudio.com/wiki/select) _index; // this takes 0.0116ms: [private](https://community.bistudio.com/wiki/private) _index [=](https://community.bistudio.com/wiki/a_=_b) _slowFormat [findIf](https://community.bistudio.com/wiki/findIf) { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [select](https://community.bistudio.com/wiki/select) 0 [==](https://community.bistudio.com/wiki/a_==_b) "name" }; // loop in script [private](https://community.bistudio.com/wiki/private) _name [=](https://community.bistudio.com/wiki/a_=_b) _slowFormat [select](https://community.bistudio.com/wiki/select) _index [select](https://community.bistudio.com/wiki/select) 1;

ⓘ

[Category:Function Group: Database](https://community.bistudio.com/wiki/Category:Function_Group:_Database) use a slow format.

## Conversion From Earlier Versions[Link](https://community.bistudio.com/wiki/Code_Optimisation#Conversion_From_Earlier_Versions)

Each iteration of Bohemia games (Operation Flashpoint, Armed Assault, Arma 2, Take On Helicopters, Arma 3) brought their own new commands, especially Arma 2 and Arma 3.
 For that, if you are converting scripts from older versions of the engine, the following aspects should be reviewed.

### Loops[Link](https://community.bistudio.com/wiki/Code_Optimisation#Loops)

- [forEach](https://community.bistudio.com/wiki/forEach) loops, depending on the situation, can be replaced by:
  - [apply](https://community.bistudio.com/wiki/apply)
  - [count](https://community.bistudio.com/wiki/count)
  - [findIf](https://community.bistudio.com/wiki/findIf)
  - [select](https://community.bistudio.com/wiki/select)

### Array Operations[Link](https://community.bistudio.com/wiki/Code_Optimisation#Array_Operations)

- **Adding an item:** Copy code to clipboardmyArray [+](https://community.bistudio.com/wiki/+) [element] and Copy code to clipboardmyArray [set](https://community.bistudio.com/wiki/set) [[count](https://community.bistudio.com/wiki/count) myArray, element] have been replaced by [pushBack](https://community.bistudio.com/wiki/pushBack)
- **Selecting a random item:** [BIS fnc selectRandom](https://community.bistudio.com/wiki/BIS_fnc_selectRandom) has been replaced by [selectRandom](https://community.bistudio.com/wiki/selectRandom)
- **Removing items:** Copy code to clipboardmyArray [set](https://community.bistudio.com/wiki/set) [1, [objNull](https://community.bistudio.com/wiki/objNull)]; myArray [-](https://community.bistudio.com/wiki/-) [[objNull](https://community.bistudio.com/wiki/objNull)] has been replaced by [deleteAt](https://community.bistudio.com/wiki/deleteAt) and [deleteRange](https://community.bistudio.com/wiki/deleteRange)
- **Concatenating:** Copy code to clipboardmyArray [=](https://community.bistudio.com/wiki/a_=_b) myArray [+](https://community.bistudio.com/wiki/+) [element] has been *reinforced* with [append](https://community.bistudio.com/wiki/append): if you don't need the original array to be modified, use [+](https://community.bistudio.com/wiki/%2B)
- **Comparing:** use [isEqualTo](https://community.bistudio.com/wiki/isEqualTo) instead of [BIS fnc areEqual](https://community.bistudio.com/wiki/BIS_fnc_areEqual)
- **Finding common items:** [in](https://community.bistudio.com/wiki/in) [forEach](https://community.bistudio.com/wiki/forEach) loop has been replaced by [arrayIntersect](https://community.bistudio.com/wiki/arrayIntersect)
- **Condition filtering:** [forEach](https://community.bistudio.com/wiki/forEach) can be replaced by [select](https://community.bistudio.com/wiki/select) (alternative syntax)

Copy code to clipboard

result [=](https://community.bistudio.com/wiki/a_=_b) (arrayOfNumbers [select](https://community.bistudio.com/wiki/select) { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [%](https://community.bistudio.com/wiki/a_%25_b) 2 [==](https://community.bistudio.com/wiki/a_==_b) 0 }); // 1.55 ms

Copy code to clipboard

result [=](https://community.bistudio.com/wiki/a_=_b) []; { [if](https://community.bistudio.com/wiki/if) ([_x](https://community.bistudio.com/wiki/Magic_Variables#x) [%](https://community.bistudio.com/wiki/a_%25_b) 2 [==](https://community.bistudio.com/wiki/a_==_b) 0) [then](https://community.bistudio.com/wiki/then) { result [pushBack](https://community.bistudio.com/wiki/pushBack) [_x](https://community.bistudio.com/wiki/Magic_Variables#x); }; } [forEach](https://community.bistudio.com/wiki/forEach) arrayOfNumbers; // 2.57 ms

### Vector Operations[Link](https://community.bistudio.com/wiki/Code_Optimisation#Vector_Operations)

- [BIS fnc vectorMultiply](https://community.bistudio.com/wiki/BIS_fnc_vectorMultiply) has been replaced by [vectorMultiply](https://community.bistudio.com/wiki/vectorMultiply) (at least 6x faster)
- [BIS fnc vectorDivide](https://community.bistudio.com/wiki/BIS_fnc_vectorDivide) too, to an extent (see [BIS fnc vectorDivide](https://community.bistudio.com/wiki/BIS_fnc_vectorDivide) for more information)

Copy code to clipboard

[private](https://community.bistudio.com/wiki/private) _vector [=](https://community.bistudio.com/wiki/a_=_b) [102, 687, 1543]; [private](https://community.bistudio.com/wiki/private) _factor [=](https://community.bistudio.com/wiki/a_=_b) 53; _vector [vectorMultiply](https://community.bistudio.com/wiki/vectorMultiply) _factor; // 0.0028 ms [_vector, _factor] [call](https://community.bistudio.com/wiki/call) [BIS_fnc_vectorMultiply](https://community.bistudio.com/wiki/BIS_fnc_vectorMultiply); // 0.0145 ms _vector [vectorMultiply](https://community.bistudio.com/wiki/vectorMultiply) (1 [/](https://community.bistudio.com/wiki/a_/_b) _factor); // 0.003 ms - but beware of 0 divisor [_vector, _factor] [call](https://community.bistudio.com/wiki/call) [BIS_fnc_vectorDivide](https://community.bistudio.com/wiki/BIS_fnc_vectorDivide); // 0.017 ms

### String Operations[Link](https://community.bistudio.com/wiki/Code_Optimisation#String_Operations)

[String](https://community.bistudio.com/wiki/String) manipulation has been simplified with the following commands:

- alternative syntax for [select](https://community.bistudio.com/wiki/select): Copy code to clipboardstring [select](https://community.bistudio.com/wiki/select) index
- [toArray](https://community.bistudio.com/wiki/toArray) and [toString](https://community.bistudio.com/wiki/toString) have been *reinforced* with [splitString](https://community.bistudio.com/wiki/splitString) and [joinString](https://community.bistudio.com/wiki/joinString)

### Number Operations[Link](https://community.bistudio.com/wiki/Code_Optimisation#Number_Operations)

- [BIS fnc linearConversion](https://community.bistudio.com/wiki/BIS_fnc_linearConversion) has been replaced by [linearConversion](https://community.bistudio.com/wiki/linearConversion). The command is **9 times faster**.
- [BIS fnc selectRandomWeighted](https://community.bistudio.com/wiki/BIS_fnc_selectRandomWeighted) has been replaced by [selectRandomWeighted](https://community.bistudio.com/wiki/selectRandomWeighted). The command is **7 times faster**.

### Type Comparison[Link](https://community.bistudio.com/wiki/Code_Optimisation#Type_Comparison)

- [typeName](https://community.bistudio.com/wiki/typeName) has been more than *reinforced* with [isEqualType](https://community.bistudio.com/wiki/isEqualType).

### Multiplayer[Link](https://community.bistudio.com/wiki/Code_Optimisation#Multiplayer)

- [BIS fnc MP](https://community.bistudio.com/wiki/BIS_fnc_MP) has been replaced by [remoteExec](https://community.bistudio.com/wiki/remoteExec) and [remoteExecCall](https://community.bistudio.com/wiki/remoteExecCall) and internally uses them. Use the engine commands from now on!

ⓘ

See also [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting).

### Parameters[Link](https://community.bistudio.com/wiki/Code_Optimisation#Parameters)

- [BIS fnc param](https://community.bistudio.com/wiki/BIS_fnc_param) has been replaced by [param](https://community.bistudio.com/wiki/param) and [params](https://community.bistudio.com/wiki/params). The commands are approximately **14 times** faster. Use them!

Retrieved from "[https://community.bistudio.com/wiki?title=Code_Optimisation&oldid=378687](https://community.bistudio.com/wiki?title=Code_Optimisation&oldid=378687)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Arma Scripting Tutorials](https://community.bistudio.com/wiki/Category:Arma_Scripting_Tutorials)