# Scheduler - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/Scheduler#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

Category: [Category:Scripting Topics](https://community.bistudio.com/wiki/Category:Scripting_Topics)

The Scheduler is the part of the game engine that decides which script runs at a certain point in time. It has the ability to pause a running script, move it to the back of the running queue and start a new script.

## Scripts[Link](https://community.bistudio.com/wiki/Scheduler#Scripts)

A new script can be started by using [spawn](https://community.bistudio.com/wiki/spawn), [execVM](https://community.bistudio.com/wiki/execVM), [exec](https://community.bistudio.com/wiki/exec) and [execFSM](https://community.bistudio.com/wiki/execFSM) commands. The script started this way will be added into the script scheduler and will be executed in turns, giving priority to the scripts waiting longest since their last suspension. Completed scripts are removed from the scheduler while scripts not completed in allocated time are suspended.

## Scheduled Environment[Link](https://community.bistudio.com/wiki/Scheduler#Scheduled_Environment)

Running code in a scheduled environment starts a new script. The executing instance will not wait for the result of scheduled code and will continue on with its execution, so it is not possible to return any values from code executed in this manner although a [Script Handle](https://community.bistudio.com/wiki/Script_Handle) for started script is provided.

As described below there is no way to predict when scheduled code will have finished, although you can use the command [scriptDone](https://community.bistudio.com/wiki/scriptDone) with the provided [Script Handle](https://community.bistudio.com/wiki/Script_Handle) to query if the script execution has finished and there is also the command [terminate](https://community.bistudio.com/wiki/terminate) to abort the script.

Because the scheduled code can run only for a fixed duration, heavy scripts spread their load over time, and thus are having lesser impact on the game performance.

**All scheduled scripts can run for a maximum of 3ms in a frame**. (Except if inside loadingscreen where it is 50ms per frame)
 Each Script that runs add's up to the total runtime and as soon as the total runtime of 3ms is reached the current script is paused and the game continues calculating everything else it needs to calculate that frame (For example sound and graphics rendering). On the next frame the scheduler again starts to run scripts for 3ms, starting with the script which has not been executed for the longest time.

This means any script that ran as the 3ms runtime was reached will be paused in the middle of it is execution and depending on how many scripts are spawned it might take several frames till it will run again. A while true loop with sleep started in scheduled environment therefore has little chance to follow with exact interval, because [sleep](https://community.bistudio.com/wiki/sleep) only marks the script as done in the current frame and the next time the script is executed the engine will check if the sleep is over. This means at 20 FPS the time between one frame and the next is roughly 50ms. That would make a sleep 0.01 wait for atleast 0.05 seconds.This effect get's bigger when the fps get even lower and if the scheduler is so overfilled that your script only get's checked every few frames instead of every frame.

If you spawn a scheduled script it will only start to run in the next frame when the scheduler starts fresh again.

### Where code starts scheduled[Link](https://community.bistudio.com/wiki/Scheduler#Where_code_starts_scheduled)

- [Event Scripts](https://community.bistudio.com/wiki/Event_Scripts#init.sqf)
- [Event Scripts](https://community.bistudio.com/wiki/Event_Scripts#initServer.sqf)
- [Event Scripts](https://community.bistudio.com/wiki/Event_Scripts#initPlayerLocal.sqf)
- [Event Scripts](https://community.bistudio.com/wiki/Event_Scripts#initPlayerServer.sqf)
- [Arma 3: Functions Library](https://community.bistudio.com/wiki/Arma_3:_Functions_Library#Pre_and_Post_Init) (although suspension is allowed, any long term suspension will halt the mission loading until suspension has finished)
- code executed with [spawn](https://community.bistudio.com/wiki/spawn)
- code executed with [execVM](https://community.bistudio.com/wiki/execVM)
- code executed with [exec](https://community.bistudio.com/wiki/exec)
- code executed with [call](https://community.bistudio.com/wiki/call) from a scheduled environment

### Scheduler diagnostics commands[Link](https://community.bistudio.com/wiki/Scheduler#Scheduler_diagnostics_commands)

The following commands are available:

- [diag activeSQSScripts](https://community.bistudio.com/wiki/diag_activeSQSScripts) - for all [exec](https://community.bistudio.com/wiki/exec) scripts in the scheduler
- [diag activeSQFScripts](https://community.bistudio.com/wiki/diag_activeSQFScripts) - for all [execVM](https://community.bistudio.com/wiki/execVM) and [spawn](https://community.bistudio.com/wiki/spawn) scripts in the scheduler
- [diag activeMissionFSMs](https://community.bistudio.com/wiki/diag_activeMissionFSMs) - for all [execFSM](https://community.bistudio.com/wiki/execFSM) scripts in the scheduler
- [diag activeScripts](https://community.bistudio.com/wiki/diag_activeScripts) - for all scripts in the scheduler

## Unscheduled Environment[Link](https://community.bistudio.com/wiki/Scheduler#Unscheduled_Environment)

Often also called non-scheduled environment but means the same and you will find both terms used in this wiki. The unscheduled environment runs (as described above) in the executing instance. The executing instance waits until the called function is finished. This ensures the execution order and is the fastest way for scripters to execute their code. The disadvantage is that a called function can halt or slow down the game if the function has a high performance consumption. Therefore those functions should be spawned and thereby run in a scheduled environment.

### Where code starts unscheduled[Link](https://community.bistudio.com/wiki/Scheduler#Where_code_starts_unscheduled)

- [Arma 3: Debug Console](https://community.bistudio.com/wiki/Arma_3:_Debug_Console)
- [Eden Editor: Trigger](https://community.bistudio.com/wiki/Eden_Editor:_Trigger)
- [Waypoints](https://community.bistudio.com/wiki/Waypoints) (condition *and* activation)
- All pre-init code executions including [Arma 3: Functions Library](https://community.bistudio.com/wiki/Arma_3:_Functions_Library#Pre_and_Post_Init)
- Code executed by [FSM](https://community.bistudio.com/wiki/FSM) (actions, conditions, etc.)
- [Category:Event Handlers](https://community.bistudio.com/wiki/Category:Event_Handlers) on units and in GUI
- *EachFrame* code ([Arma 3: Mission Event Handlers](https://community.bistudio.com/wiki/Arma_3:_Mission_Event_Handlers#EachFrame) / [BIS fnc addStackedEventHandler](https://community.bistudio.com/wiki/BIS_fnc_addStackedEventHandler) / [onEachFrame](https://community.bistudio.com/wiki/onEachFrame))
- Object initialisation fields
- Expressions of Eden Editor entity/mission attributes
- Code execution with [call](https://community.bistudio.com/wiki/call) from an unscheduled environment
- Code executed with [remoteExecCall](https://community.bistudio.com/wiki/remoteExecCall)
- Code inside [isNil](https://community.bistudio.com/wiki/isNil)
- [SQF Syntax](https://community.bistudio.com/wiki/SQF_Syntax) code called from [SQS Syntax](https://community.bistudio.com/wiki/SQS_Syntax) code
- [Conversations](https://community.bistudio.com/wiki/Conversations#Conversation_Event_Handler)
- Code inside [collect3DENHistory](https://community.bistudio.com/wiki/collect3DENHistory)

### while Loops[Link](https://community.bistudio.com/wiki/Scheduler#while_Loops)

A [while](https://community.bistudio.com/wiki/while)-[do](https://community.bistudio.com/wiki/do) loop is limited to (hard-coded) **10,000** iterations in a non-scheduled environment.

## Suspension[Link](https://community.bistudio.com/wiki/Scheduler#Suspension)

Suspension is the process to wait a period of time or to wait for something to happen. Commands for suspension are [sleep](https://community.bistudio.com/wiki/sleep), [uiSleep](https://community.bistudio.com/wiki/uiSleep), [waitUntil](https://community.bistudio.com/wiki/waitUntil).

Suspension is **forbidden** in an unscheduled environment and trying to use such command will fail with an error; you must ensure that you are running your code in a scheduled environment **and** can suspend with the **[canSuspend](https://community.bistudio.com/wiki/canSuspend)** command.

Retrieved from "[https://community.bistudio.com/wiki?title=Scheduler&oldid=351907](https://community.bistudio.com/wiki?title=Scheduler&oldid=351907)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Scripting Topics](https://community.bistudio.com/wiki/Category:Scripting_Topics)