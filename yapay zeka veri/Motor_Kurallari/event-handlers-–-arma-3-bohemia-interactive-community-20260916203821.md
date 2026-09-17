# Event Handlers – Arma 3 - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

Category: [Category:Event Handlers](https://community.bistudio.com/wiki/Category:Event_Handlers)

An Event Handler (abbreviated to EH) allows you to automatically monitor and then execute custom code upon particular events being triggered.
 See also [Event Scripts](https://community.bistudio.com/wiki/Event_Scripts) for special event triggered scripts.

## Basic Event Handlers[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Basic_Event_Handlers)

The object-based Event Handler is always executed on the computer where it was added.

Commands:

- [addEventHandler](https://community.bistudio.com/wiki/addEventHandler)
- [removeEventHandler](https://community.bistudio.com/wiki/removeEventHandler)
- [removeAllEventHandlers](https://community.bistudio.com/wiki/removeAllEventHandlers)

[Category:Introduced with Arma 3 version 2.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.22)[Category:Introduced with Arma 3 version 2.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.22)

### AmmoExplodedNear[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#AmmoExplodedNear)

Triggers when ammo explodes in some damage range of the object. This EH triggers where the ammo is 'real', similar to HitPart.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["AmmoExplodedNear", { [params](https://community.bistudio.com/wiki/params) ["_object", "_shot", "_position", "_velocity", "_ammo", "_explosive", "_indirectHit", "_invArmor", "_damage"]; }];

- object: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- shot: [Object](https://community.bistudio.com/wiki/Object) - shot that has exploded
- position: [Array](https://community.bistudio.com/wiki/Array) - world position of the shot
- velocity: [Array](https://community.bistudio.com/wiki/Array) - world velocity of the shot
- ammmo: [String](https://community.bistudio.com/wiki/String) - config ammo class name
- explosive: [Number](https://community.bistudio.com/wiki/Number) - config value for 'explosive'
- indirectHit: [Number](https://community.bistudio.com/wiki/Number) - config value for 'indirectHit'
- invArmor: [Number](https://community.bistudio.com/wiki/Number) - calculated inverse armor from config value
- damage: [Number](https://community.bistudio.com/wiki/Number) - a rough estimate of the potential damage to the center of the object based on config values and the distance

### AnimChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#AnimChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered every time a new animation is started. This EH is only triggered for the 1st animation state in a sequence.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["AnimChanged", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_anim"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- anim: [String](https://community.bistudio.com/wiki/String) - name of the anim that is started

### AnimDone[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#AnimDone)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered every time an animation is finished. Triggered for all animation states in a sequence.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["AnimDone", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_anim"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- anim: [String](https://community.bistudio.com/wiki/String) - name of the anim that has been finished

### AnimStateChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#AnimStateChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered every time an animation state changes. Triggered for all animation states in a sequence.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["AnimStateChanged", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_anim"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- anim: [String](https://community.bistudio.com/wiki/String) - name of the anim that has been started

[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)

### Assembled[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Assembled)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when weapon that is moved out of the world is assembled again. EH should be attached to the entity.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Assembled", { [params](https://community.bistudio.com/wiki/params) ["_entity", "_unit", "_primaryBag", "_secondaryBag"]; }];

- entity: [Object](https://community.bistudio.com/wiki/Object) - weapon this event is assigned to
- unit: [Object](https://community.bistudio.com/wiki/Object) - person who assembled the weapon
- primaryBag: [Object](https://community.bistudio.com/wiki/Object) - first backpack object which was entity disassembled into (just before it is deleted)
- secondaryBag: [Object](https://community.bistudio.com/wiki/Object) - second backpack object which was entity disassembled into (just before it is deleted)

[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)

### Attached[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Attached)

Triggered after an object has been attached to another object (see [attachTo](https://community.bistudio.com/wiki/attachTo)).

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Attached", { [params](https://community.bistudio.com/wiki/params) ["_attachedObj", "_parentObj", "_isReattach", "_offset", "_memoryPointIndex", "_followBoneRotation"]; }];

- attachedObj: [Object](https://community.bistudio.com/wiki/Object)
- parentObj: [Object](https://community.bistudio.com/wiki/Object)
- isReattach: [Boolean](https://community.bistudio.com/wiki/Boolean) - [true](https://community.bistudio.com/wiki/true) if attachedObj was already attached to parentObj, e.g. if only the offset was changed
- offset: [Array](https://community.bistudio.com/wiki/Array) format [PositionRelative](https://community.bistudio.com/wiki/PositionRelative)
- memoryPointIndex: [Number](https://community.bistudio.com/wiki/Number)
- followBoneRotation: [Boolean](https://community.bistudio.com/wiki/Boolean)

[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)

### CargoLoaded[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CargoLoaded)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a vehicle is loaded into another vehicle ([setVehicleCargo](https://community.bistudio.com/wiki/setVehicleCargo)).
 It can be added to either the transport vehicle, or the cargo vehicle, and will fire for both cases.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CargoLoaded", { [params](https://community.bistudio.com/wiki/params) ["_parentVehicle", "_cargoVehicle"]; }];

- parentVehicle: [Object](https://community.bistudio.com/wiki/Object) - the transport (parent) vehicle
- cargoVehicle: [Object](https://community.bistudio.com/wiki/Object) - the cargo (child) vehicle

[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)

### CargoUnloaded[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CargoUnloaded)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a vehicle is unloaded from another vehicle ([setVehicleCargo](https://community.bistudio.com/wiki/setVehicleCargo)).
 It can be added to either the transport vehicle, or the cargo vehicle, and will fire for both cases.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CargoUnloaded", { [params](https://community.bistudio.com/wiki/params) ["_parentVehicle", "_cargoVehicle"]; }];

- parentVehicle: [Object](https://community.bistudio.com/wiki/Object) - the transport (parent) vehicle
- cargoVehicle: [Object](https://community.bistudio.com/wiki/Object) - the cargo (child) vehicle

[Category:Introduced with Arma 3 version 1.32](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.32)[Category:Introduced with Arma 3 version 1.32](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.32)

### ContainerClosed[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#ContainerClosed)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when player finished accessing cargo container. This event handler is similar to [InventoryClosed](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#InventoryClosed) EH, but needs to be assigned to the container rather than the player.
 **Note:** will trigger only for the unit opening container.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["ContainerClosed", { [params](https://community.bistudio.com/wiki/params) ["_container", "_unit"]; }];

- container: [Object](https://community.bistudio.com/wiki/Object) - cargo container.
- unit: [Object](https://community.bistudio.com/wiki/Object) - unit who accessed the container

[Category:Introduced with Arma 3 version 1.32](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.32)[Category:Introduced with Arma 3 version 1.32](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.32)

### ContainerOpened[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#ContainerOpened)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when cargo container is accessed by player. This event handler is similar to [InventoryOpened](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#InventoryOpened) EH, but needs to be assigned to the container rather than the player and cannot be overridden.
 **Note:** will trigger only for the unit opening container.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["ContainerOpened", { [params](https://community.bistudio.com/wiki/params) ["_container", "_unit"]; }];

- container: [Object](https://community.bistudio.com/wiki/Object) - cargo container
- unit: [Object](https://community.bistudio.com/wiki/Object) - unit who accessed the container

[Category:Introduced with Arma 3 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.00)[Category:Introduced with Arma 3 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.00)

### ControlsShifted[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#ControlsShifted)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when control of a vehicle is shifted (pilot->co-pilot, co-pilot->pilot), usually when user performs an [action](https://community.bistudio.com/wiki/action) such as [action/Arma 3 Actions List](https://community.bistudio.com/wiki/action/Arma_3_Actions_List#TakeVehicleControl), [action/Arma 3 Actions List](https://community.bistudio.com/wiki/action/Arma_3_Actions_List#SuspendVehicleControl), [action/Arma 3 Actions List](https://community.bistudio.com/wiki/action/Arma_3_Actions_List#UnlockVehicleControl), [action/Arma 3 Actions List](https://community.bistudio.com/wiki/action/Arma_3_Actions_List#LockVehicleControl), or when [enableCopilot](https://community.bistudio.com/wiki/enableCopilot) command is used. This event handler will always fire on the PC where [action](https://community.bistudio.com/wiki/action) is triggered as well as where the vehicle is [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality) at the time. When control of the vehicle is shifted, the locality of the vehicle changes to the locality of the new controller. For example, if helicopter is [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality) to the server and co-pilot takes controls, the helicopter changes locality to co-pilot PC. This means that if "ControlsShifted" EH was added on both server and client, "Take Controls" action will trigger EH on both, client and server PC, but subsequent co-pilot "Release Controls" action will trigger only on co-pilot's PC, because vehicle will be local to co-pilot at this point. There is also a slightly better mission version of [Arma 3: Mission Event Handlers](https://community.bistudio.com/wiki/Arma_3:_Mission_Event_Handlers#ControlsShifted) event handler.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["ControlsShifted", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_activeCoPilot", "_oldController"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle which controls were shifted
- activeCoPilot: [Object](https://community.bistudio.com/wiki/Object) - co-pilot unit which controls vehicle after this event. [objNull](https://community.bistudio.com/wiki/objNull) if co-pilot is not controlling the vehicle
- oldController: [Object](https://community.bistudio.com/wiki/Object) - unit who controlled vehicle before this event

### Dammaged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Dammaged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the unit is damaged. In ArmA works with all vehicles not only men like in OFP.

**Notes:**

- The typo is "intentional": it is Da**mm**aged with two "m".
- If simultaneous damage occured (e.g. via grenade) EH might be triggered several times.
- The Dammaged EH will not necessarily fire if only minor damage occurred (e.g. firing a bullet at a tank), even though the damage increased.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Dammaged", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_hitSelection", "_damage", "_hitPartIndex", "_hitPoint", "_shooter", "_projectile"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- hitSelection: [String](https://community.bistudio.com/wiki/String) - name of the selection where the unit was damaged
- damage: [Number](https://community.bistudio.com/wiki/Number) - resulting level of damage
- [Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68)[Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68) hitPartIndex: [Number](https://community.bistudio.com/wiki/Number) - hit index of the hit selection
- [Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68)[Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68) hitPoint: [String](https://community.bistudio.com/wiki/String) - hit point Cfg name
- [Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70)[Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70) shooter: [Object](https://community.bistudio.com/wiki/Object) - shooter reference (to get instigator use [getShotParents](https://community.bistudio.com/wiki/getShotParents) on projectile)
- [Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70)[Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70) projectile: [Object](https://community.bistudio.com/wiki/Object) - the projectile that caused damage

[Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68)[Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68)

### Deleted (Entity)[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Deleted_(Entity))

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered just before the assigned entity is deleted.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Deleted", { [params](https://community.bistudio.com/wiki/params) ["_entity"]; }];

- entity: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to

[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)

### Detached[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Detached)

Triggered after an object has been detached from its parent object (see [detach](https://community.bistudio.com/wiki/detach)). Does not fire if the parent object was deleted.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Detached", { [params](https://community.bistudio.com/wiki/params) ["_attachedObj", "_parentObj"]; }];

- attachedObj: [Object](https://community.bistudio.com/wiki/Object)
- parentObj: [Object](https://community.bistudio.com/wiki/Object)

[Category:Introduced with Arma 3 version 2.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.00)[Category:Introduced with Arma 3 version 2.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.00)

### Disassembled[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Disassembled)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when entity such as weapon/backpack gets disassembled. EH should be attached to the entity.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Disassembled", { [params](https://community.bistudio.com/wiki/params) ["_entity", "_primaryBag", "_secondaryBag", "_unit"]; }];

- entity: [Object](https://community.bistudio.com/wiki/Object) - weapon this event is assigned to (just before is is moved out of the world)
- primaryBag: [Object](https://community.bistudio.com/wiki/Object) - first backpack object which was entity disassembled into
- secondaryBag: [Object](https://community.bistudio.com/wiki/Object) - second backpack object which was entity disassembled into
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) unit: [Object](https://community.bistudio.com/wiki/Object) - person who disassembled the weapon

### Engine[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Engine)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the engine of the unit is turned on/off.

ⓘ

Although the event is global, on clients (non-server) and applied to remote vehicles, it will fire only if the vehicle is closer than about 6 km from the camera. Should the vehicle be far away, it will fire as soon as the camera and vehicle are close enough together, alongside the [isEngineOn](https://community.bistudio.com/wiki/isEngineOn) flag change.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Engine", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_engineState"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle the event handler is assigned to
- engineState: [Boolean](https://community.bistudio.com/wiki/Boolean) - true when the engine is turned on, false when turned off

[Category:Introduced with Arma 3 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.00)[Category:Introduced with Arma 3 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.00)

### EpeContact[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#EpeContact)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when object collision (PhysX) is in progress.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["EpeContact", { [params](https://community.bistudio.com/wiki/params) ["_object1", "_object2", "_selection1", "_selection2", "_force", "_reactVect", "_worldPos"]; }];

- object1: [Object](https://community.bistudio.com/wiki/Object) - object with attached handler
- object2: [Object](https://community.bistudio.com/wiki/Object) - object which is colliding with object1
- selection1: [String](https://community.bistudio.com/wiki/String) - selection of object1 which is colliding - not in use at this moment, empty string is always returned
- selection2: [String](https://community.bistudio.com/wiki/String) - selection of object2 which is colliding - not in use at this moment, empty string is always returned
- force: [Number](https://community.bistudio.com/wiki/Number) - force of collision
- [Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12)[Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12) reactVect: [Array](https://community.bistudio.com/wiki/Array) - impact reaction force vector
- [Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12)[Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12) worldPos: [PositionWorld](https://community.bistudio.com/wiki/PositionWorld) - point of impact in world coordinates

[Category:Introduced with Arma 3 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.00)[Category:Introduced with Arma 3 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.00)

### EpeContactEnd[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#EpeContactEnd)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when object collision (PhysX) ends.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["EpeContactEnd", { [params](https://community.bistudio.com/wiki/params) ["_object1", "_object2", "_selection1", "_selection2", "_force"]; }];

- object1: [Object](https://community.bistudio.com/wiki/Object) - object with attached handler
- object2: [Object](https://community.bistudio.com/wiki/Object) - object which is colliding with object1
- selection1: [String](https://community.bistudio.com/wiki/String) - selection of object1 which is colliding - not in use at this moment, empty string is always returned
- selection2: [String](https://community.bistudio.com/wiki/String) - selection of object2 which is colliding - not in use at this moment, empty string is always returned
- force: [Number](https://community.bistudio.com/wiki/Number) - force of collision

[Category:Introduced with Arma 3 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.00)[Category:Introduced with Arma 3 version 1.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.00)

### EpeContactStart[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#EpeContactStart)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when object collision (PhysX) starts.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["EpeContactStart", { [params](https://community.bistudio.com/wiki/params) ["_object1", "_object2", "_selection1", "_selection2", "_force", "_reactForce", "_worldPos"]; }];

- object1: [Object](https://community.bistudio.com/wiki/Object) - object with attached handler
- object2: [Object](https://community.bistudio.com/wiki/Object) - object which is colliding with object1
- select1: [String](https://community.bistudio.com/wiki/String) - selection of object1 which is colliding - not in use at this moment, empty string is always returned
- select2: [String](https://community.bistudio.com/wiki/String) - selection of object2 which is colliding - not in use at this moment, empty string is always returned
- force: [Number](https://community.bistudio.com/wiki/Number) - force of collision
- [Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12)[Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12) reactForce: [Array](https://community.bistudio.com/wiki/Array) - impact reaction force vector
- [Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12)[Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12) worldPos: [PositionWorld](https://community.bistudio.com/wiki/PositionWorld) - point of impact in world coordinates

[Category:Introduced with Arma 3 version 0.76](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.76)[Category:Introduced with Arma 3 version 0.76](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.76)

### Explosion[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Explosion)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a vehicle or unit is damaged by a nearby explosion. It can be assigned to a remote unit or vehicle but will only fire on the PC where EH is added and explosion is local, i.e. it really needs to be added on every PC and JIP and will fire only where the explosion is originated.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Explosion", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_damage", "_explosionSource"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- damage: [Number](https://community.bistudio.com/wiki/Number) - damage inflicted to the object
- [Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10)[Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10) explosionSource: [Object](https://community.bistudio.com/wiki/Object) - the exploding object (NOT the shooter) - may be [objNull](https://community.bistudio.com/wiki/objNull) in some cases

ⓘ

This event will fire even for tiniest of explosion damage (which appears as 0 damage argument), while

[HitPart (Entity)](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitPart_(Entity))

could ignore such damage and not fire.

Example of such event would be a tank firing AP round and hitting ground a meter away from the vehicle, it does not produce an explosion yet its [CfgAmmo Config Reference](https://community.bistudio.com/wiki/CfgAmmo_Config_Reference#indirectHit) could still cause tiny amount of damage to weak hit points (car wheels, headlights, etc.).

In such case you might not get any

[HitPart (Entity)](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitPart_(Entity))

event fires, get some

[HandleDamage](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleDamage)

events if target is local, and get this Explosion event.

### Fired[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Fired)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the unit fires a weapon.
 This EH will not trigger if a unit fires out of a vehicle. For those cases an EH has to be attached to that particular vehicle. When "Manual Fire" is used, the *gunner* is [objNull](https://community.bistudio.com/wiki/objNull) if gunner is not present or the *gunner* is not the one who fires. To check if "Manual Fire" is on, use [isManualFire](https://community.bistudio.com/wiki/isManualFire). The actual shot instigator could be retrieved with [getShotParents](https://community.bistudio.com/wiki/getShotParents) command.

⚠

**Special multiplayer behaviour:**

When added to a remote unit or vehicle, this EH will only fire if said entity is within range of the camera.

That range is determined by the fired ammo's highest visibleFire and audibleFire config value.

In case of units, muzzle attachment coefficients are applied too.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Fired", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- weapon: [String](https://community.bistudio.com/wiki/String) - fired weapon
- muzzle: [String](https://community.bistudio.com/wiki/String) - muzzle that was used
- mode: [String](https://community.bistudio.com/wiki/String) - current mode of the fired weapon
- ammo: [String](https://community.bistudio.com/wiki/String) - ammo used
- magazine: [String](https://community.bistudio.com/wiki/String) - magazine name which was used
- projectile: [Object](https://community.bistudio.com/wiki/Object) - object of the projectile that was shot out
- [Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66) gunner: [Object](https://community.bistudio.com/wiki/Object) - gunner whose weapons are firing.

[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)

### FiredMan[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#FiredMan)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the unit fires a weapon. This EH must be attached to a soldier and unlike with "Fired" EH, it will fire regardless of whether the soldier is on foot or firing vehicle weapon. For [remoteControl](https://community.bistudio.com/wiki/remoteControl) unit use "Fired" EH instead.

⚠

**Special multiplayer behaviour:**

When added to a remote unit or vehicle, this EH will only fire if said entity is within range of the camera.

That range is determined by the fired ammo's highest visibleFire and audibleFire config value.

In case of units, muzzle attachment coefficients are applied too.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["FiredMan", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit the event handler is assigned to (the instigator)
- weapon: [String](https://community.bistudio.com/wiki/String) - fired weapon
- muzzle: [String](https://community.bistudio.com/wiki/String) - muzzle that was used
- mode: [String](https://community.bistudio.com/wiki/String) - current mode of the fired weapon
- ammo: [String](https://community.bistudio.com/wiki/String) - ammo used
- magazine: [String](https://community.bistudio.com/wiki/String) - magazine name which was used
- projectile: [Object](https://community.bistudio.com/wiki/Object) - object of the projectile that was shot out
- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle, if weapon is vehicle weapon, otherwise [objNull](https://community.bistudio.com/wiki/objNull)

### FiredNear[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#FiredNear)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a weapon is fired somewhere *near* the unit or vehicle. It is also triggered if the unit itself is firing.
 When "Manual Fire" is used, the *gunner* is [objNull](https://community.bistudio.com/wiki/objNull) if gunner is not present or the *gunner* is not the one who fires. To check if "Manual Fire" is on, use [isManualFire](https://community.bistudio.com/wiki/isManualFire). The actual shot instigator can be retrieved with [getShotParents](https://community.bistudio.com/wiki/getShotParents) command.
 [Category:Introduced with Arma 3 version 1.30](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.30)[Category:Introduced with Arma 3 version 1.30 (page does not exist)](https://community.bistudio.com/wiki?title=Category:Introduced_with_Arma_3_version_1.30&action=edit&redlink=1) Works with thrown weapons (using the "Throw" weapon) like grenades.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["FiredNear", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- firer: [Object](https://community.bistudio.com/wiki/Object) - object which fires a weapon near the unit
- distance: [Number](https://community.bistudio.com/wiki/Number) - distance in meters between the *unit* and *firer* (max. distance ~69m)
- weapon: [String](https://community.bistudio.com/wiki/String) - fired weapon
- muzzle: [String](https://community.bistudio.com/wiki/String) - muzzle that was used
- mode: [String](https://community.bistudio.com/wiki/String) - current mode of the fired weapon
- ammo: [String](https://community.bistudio.com/wiki/String) - ammo used
- [Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66) gunner: [Object](https://community.bistudio.com/wiki/Object) - gunner, whose weapons are fired

### Fuel[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Fuel)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the vehicle's fuel status changes between non-empty and empty or between empty and non-empty.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Fuel", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_hasFuel"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle the event handler is assigned to
- hasFuel: [Boolean](https://community.bistudio.com/wiki/Boolean) - false when has no fuel, true when has some fuel

### Gear[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Gear)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the unit lowers/retracts the landing gear, whether it is a helicopter or a plane. Also triggered for helicopters in landing mode, regardless if they have retractable gear or not.

ⓘ

Not to be confused with *[Arma 3: Event Handlers](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#InventoryOpened)* and *[Arma 3: Event Handlers](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#InventoryClosed)* events, *Gear* fires when the landing gear state on an aircraft has changed.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Gear", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_gearState"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle the event handler is assigned to
- gearState: [Boolean](https://community.bistudio.com/wiki/Boolean) - true when the gear is lowered, false when retracted

[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)

### GestureChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#GestureChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered every time a new gesture is played.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["GestureChanged", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_gesture"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- gesture: [String](https://community.bistudio.com/wiki/String) - name of the gesture that has started playing

[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)

### GestureDone[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#GestureDone)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered every time a gesture is finished.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["GestureDone", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_gesture"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- gesture: [String](https://community.bistudio.com/wiki/String) - name of the gesture that has been finished

### GetIn[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#GetIn)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when a unit enters the vehicle to which this EH has been added. This EH is triggered by moveInXXXX commands and "GetInXXXX" [action](https://community.bistudio.com/wiki/action), but not upon a seat change within the same vehicle.

In vehicles with multi-turret setup, entering any turret will show "gunner" for position.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["GetIn", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_role", "_unit", "_turret"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle the event handler is assigned to
- role: [String](https://community.bistudio.com/wiki/String) - can be either "driver", "gunner", "commander" or "cargo"
- unit: [Object](https://community.bistudio.com/wiki/Object) - unit that entered the vehicle
- [Category:Introduced with Arma 3 version 1.36](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.36)[Category:Introduced with Arma 3 version 1.36](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.36) turret: [Array](https://community.bistudio.com/wiki/Array) - turret path

[Category:Introduced with Arma 3 version 1.58](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.58)[Category:Introduced with Arma 3 version 1.58](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.58)

### GetInMan[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#GetInMan)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when a unit enters a vehicle. Similar to "GetIn" but must be assigned to a unit and not vehicle. Persistent on respawn if assigned where unit was [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality). This EH is triggered by moveInXXXX commands and "GetInXXXX" [action](https://community.bistudio.com/wiki/action).

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["GetInMan", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_role", "_vehicle", "_turret"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit the event handler is assigned to
- role: [String](https://community.bistudio.com/wiki/String) - can be either "driver", "gunner", "commander" or "cargo"
- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle the unit entered
- turret: [Array](https://community.bistudio.com/wiki/Array) - turret path

### GetOut[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#GetOut)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when a unit gets out from the vehicle to which this EH has been added. This EH is triggered by [moveOut](https://community.bistudio.com/wiki/moveOut), "GetOut" & "Eject" [action](https://community.bistudio.com/wiki/action), if an [alive](https://community.bistudio.com/wiki/alive) [crew](https://community.bistudio.com/wiki/crew) member disconnects or is deleted, but not upon a seat change within the same vehicle.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["GetOut", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_role", "_unit", "_turret", "_isEject"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle the event handler is assigned to
- role: [String](https://community.bistudio.com/wiki/String) - can be either "driver", "gunner", "commander" or "cargo"
- unit: [Object](https://community.bistudio.com/wiki/Object) - unit that left the vehicle
- [Category:Introduced with Arma 3 version 1.36](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.36)[Category:Introduced with Arma 3 version 1.36](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.36) turret: [Array](https://community.bistudio.com/wiki/Array) - turret path
- [Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14) isEject: [Boolean](https://community.bistudio.com/wiki/Boolean) - [true](https://community.bistudio.com/wiki/true) if unit used 'Eject' action

[Category:Introduced with Arma 3 version 1.58](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.58)[Category:Introduced with Arma 3 version 1.58](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.58)

### GetOutMan[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#GetOutMan)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when a unit exits a vehicle. Similar to "GetOut" but must be assigned to a unit and not vehicle. Persistent on respawn if assigned where unit was [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality). This EH is triggered by [moveOut](https://community.bistudio.com/wiki/moveOut) and "GetOut" & "Eject" [action](https://community.bistudio.com/wiki/action).

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["GetOutMan", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_role", "_vehicle", "_turret", "_isEject"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit the event handler is assigned to
- role: [String](https://community.bistudio.com/wiki/String) - can be either "driver", "gunner", "commander" or "cargo"
- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle that the unit left
- turret: [Array](https://community.bistudio.com/wiki/Array) - turret path
- [Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14) isEject: [Boolean](https://community.bistudio.com/wiki/Boolean) - [true](https://community.bistudio.com/wiki/true) if unit used 'Eject' action

### HandleDamage[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleDamage)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when the unit is damaged and fires for each damaged selection separately Works with all vehicles. This EH can accept a remote unit as argument however it will only fire when the unit is [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality) to the PC this event handler was added on. For example, you can add this event handler to one particular vehicle on every PC. When this vehicle gets hit, only EH on PC where the vehicle is currently [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality) will fire.

If the provided code returns a numeric value, this value will overwrite the default damage of given selection after processing. If no value is returned, the default damage processing will be done - this allows for safe stacking of this event handler. Only the return value of the last added "HandleDamage" EH is considered.

⚠

A return value of 0 will make the unit **invulnerable** if damage is not scripted in other ways (i.e using [setDamage](https://community.bistudio.com/wiki/setDamage) and/or [setHit](https://community.bistudio.com/wiki/setHit) for additional damage handling). The return value is the hit zone's **absolute damage value**, **not** the damage to be *added* to it.

**Notes:**

- Multiple "HandleDamage" EHs can be added to the same unit. If multiple EHs return damage value for custom damage handling, only last returned value will be considered by the engine.

EHs that do not return value can be safely added after EHs that do return value.

- You can save the last event as timestamp ([diag tickTime](https://community.bistudio.com/wiki/diag_tickTime)) onto the unit, as well as the current health of the unit/its selections, with [setVariable](https://community.bistudio.com/wiki/setVariable) and query it on each "HandleDamage" event with [getVariable](https://community.bistudio.com/wiki/getVariable) to define a system how to handle the "HandleDamage" event.
- "HandleDamage" will continue to trigger even if the unit is already dead.
- "HandleDamage" is persistent. If you add it to the [player](https://community.bistudio.com/wiki/player) object, it will continue to exist after player respawned.
- "HandleDamage" can trigger "twice" per damage event. Once for direct damage, once for indirect damage (explosive damage). This can happen even in the same frame, but is unlikely.
- Use [setMissionOptions](https://community.bistudio.com/wiki/setMissionOptions) to filter out no damage calls or fake head hit.

Additional [Celery's explanation (Updated by ShadowRanger for Arma 3)](https://forums.bistudio.com/forums/topic/205515-handledamage-event-handler-explained/).

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HandleDamage", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitPartIndex", "_instigator", "_hitPoint", "_directHit", "_context"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- selection: [String](https://community.bistudio.com/wiki/String) - name of the selection where the unit was damaged.
  - "" for overall structural damage
  - "?" for unknown selections
- damage: [Number](https://community.bistudio.com/wiki/Number) - resulting level of damage for the selection
- source: [Object](https://community.bistudio.com/wiki/Object) - the source unit that caused the damage
- projectile: [String](https://community.bistudio.com/wiki/String) - classname of the projectile that caused inflicted the damage. ("" for unknown, such as fall damage)
- [Category:Introduced with Arma 3 version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.50)[Category:Introduced with Arma 3 version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.50) hitPartIndex: [Number](https://community.bistudio.com/wiki/Number) - hit part index of the hit point, -1 otherwise
- [Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66) instigator: [Object](https://community.bistudio.com/wiki/Object) - person who pulled the trigger
- [Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68)[Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68) hitPoint: [String](https://community.bistudio.com/wiki/String) - hit point Cfg name
- [Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12)[Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12) directHit: [Boolean](https://community.bistudio.com/wiki/Boolean) - [true](https://community.bistudio.com/wiki/true) for direct projectile damage, [false](https://community.bistudio.com/wiki/false) for explosion splash damage and all other kinds of damage like fall damage, fire damage, collision damage, etc.
- [Category:Introduced with Arma 3 version 2.16](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.16)[Category:Introduced with Arma 3 version 2.16](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.16) context: [Number](https://community.bistudio.com/wiki/Number) - some additional context for the event:

0 : TotalDamage - total damage adjusted before iteration through hitpoints
1 : HitPoint - some hit point processed during iteration
2 : LastHitPoint - the last hitpoint from iteration is processed
3 : FakeHeadHit - head hit that is added/adjusted
4 : TotalDamageBeforeBleeding - total damage is adjusted before calculating bleeding

ⓘ

Between an unknown version (confirmed in Arma 3 v1.70) until v1.78 HandleDamage event triggered for every selection of a vehicle, no matter if the section was damaged or not.

### HandleHeal[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleHeal)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when unit starts healing process (player using heal action on self or other unit, scripted [action](https://community.bistudio.com/wiki/action) or AI heals after being ordered or on its own). This event handler must be added to the 'injured' (could be added to Init field in editor) and in multiplayer will trigger only on PC where 'healer' is [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality). If code returns anything but [true](https://community.bistudio.com/wiki/true), engine side healing follows, otherwise healing is aborted.

⚠

When AI unit is ordered (or acts at own accord) to heal at a medical vehicle and the event handler returns [true](https://community.bistudio.com/wiki/true), the healing is canceled but AI will try again and again and again. The event handler in this case will fire every second until AI unit is healed by other means.

**NOTE**: This Event Handler was broken before Arma 3 v2.18.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HandleHeal", { [_this](https://community.bistudio.com/wiki/Magic_Variables#this) [spawn](https://community.bistudio.com/wiki/spawn) { [params](https://community.bistudio.com/wiki/params) ["_injured", "_healer", "_isMedic", "_atVehicle", "_action"]; [private](https://community.bistudio.com/wiki/private) _damage [=](https://community.bistudio.com/wiki/a_=_b) [damage](https://community.bistudio.com/wiki/damage) _injured; [if](https://community.bistudio.com/wiki/if) (_injured [==](https://community.bistudio.com/wiki/a_==_b) _healer) [then](https://community.bistudio.com/wiki/then) { [waitUntil](https://community.bistudio.com/wiki/waitUntil) { [damage](https://community.bistudio.com/wiki/damage) _injured [!=](https://community.bistudio.com/wiki/a_!=_b) _damage }; [if](https://community.bistudio.com/wiki/if) ([damage](https://community.bistudio.com/wiki/damage) _injured [<](https://community.bistudio.com/wiki/a_less_b) _damage) [then](https://community.bistudio.com/wiki/then) { _injured [setDamage](https://community.bistudio.com/wiki/setDamage) 0; }; }; }; }];

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HandleHeal", { [params](https://community.bistudio.com/wiki/params) ["_injured", "_healer", "_isMedic", "_atVehicle", "_action"]; }];

- injured: [Object](https://community.bistudio.com/wiki/Object) - unit EH is attached to
- healer: [Object](https://community.bistudio.com/wiki/Object) - unit that does the healing (could be the same unit as 'injured')
- isMedic: [Boolean](https://community.bistudio.com/wiki/Boolean) - true when healer is 'Medic'
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) atVehicle: [Object](https://community.bistudio.com/wiki/Object) - when healing at medical vehicle, this is the vehicle
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) action: [String](https://community.bistudio.com/wiki/String) - the action that triggered the event handler, for example "SoldierHealSelf"

### HandleIdentity[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleIdentity)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered whenever an entity is created. Can be used in scripts if EH is added immediately after unit is created in [Scheduler](https://community.bistudio.com/wiki/Scheduler#Unscheduled_Environment). Doesn't trigger for editor placed units. Does not work in Multiplayer. If EH scope returns [true](https://community.bistudio.com/wiki/true), the default engine identity application is overridden.

Copy code to clipboard

bob [=](https://community.bistudio.com/wiki/a_=_b) [group](https://community.bistudio.com/wiki/group) [player](https://community.bistudio.com/wiki/player) [createUnit](https://community.bistudio.com/wiki/createUnit) [[typeOf](https://community.bistudio.com/wiki/typeOf) [player](https://community.bistudio.com/wiki/player), [position](https://community.bistudio.com/wiki/position) [player](https://community.bistudio.com/wiki/player), [], 0, "NONE"]; bob [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HandleIdentity", { [params](https://community.bistudio.com/wiki/params) ["_unit"]; [hint](https://community.bistudio.com/wiki/hint) [str](https://community.bistudio.com/wiki/str) _unit; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to

[Category:Introduced with Arma 3 version 1.32](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.32)[Category:Introduced with Arma 3 version 1.32](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.32)

### HandleRating[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleRating)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when engine adds rating to overall rating of the unit, usually after a kill or a friendly kill. If EH code returns [Number](https://community.bistudio.com/wiki/Number), this will override default engine behaviour and the resulting value added will be the one returned by EH code.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HandleRating", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_rating"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- rating: [Number](https://community.bistudio.com/wiki/Number) - rating to be added

[Category:Introduced with Arma 3 version 1.32](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.32)[Category:Introduced with Arma 3 version 1.32](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.32)

### HandleScore[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleScore)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when engine adds score to overall score of the unit, usually after a kill. If the EH code returns [Nothing](https://community.bistudio.com/wiki/Nothing) or [true](https://community.bistudio.com/wiki/true), the default engine scoreboard update (score, vehicle kills, infantry kills, etc) is applied, if it returns [false](https://community.bistudio.com/wiki/false), the engine update is cancelled. To add or modify score, use [addScore](https://community.bistudio.com/wiki/addScore) and [addScoreSide](https://community.bistudio.com/wiki/addScoreSide) commands. For remote units like players, the event does not persist after respawn, and must be re-added to the new unit.
 **Note:** MP only.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HandleScore", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_object", "_score"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- object: [Object](https://community.bistudio.com/wiki/Object) - object for which score was awarded
- score: [Number](https://community.bistudio.com/wiki/Number) - score to be added

### Hit[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Hit)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the unit is hit/damaged.

Is *not* always triggered when unit is killed by a hit.
 Most of the time only the [killed](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Killed) event handler is triggered when a unit dies from a hit.
 The hit EH will not necessarily fire if only minor damage occurred (e.g. firing a bullet at a tank), even though the damage increased.
 Does not fire when a unit is set to allowDamage false.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Hit", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_source", "_damage", "_instigator"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- source: [Object](https://community.bistudio.com/wiki/Object) - object that caused the damage – contains *unit* in case of collisions
- damage: [Number](https://community.bistudio.com/wiki/Number) - level of damage caused by the hit
- [Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66) instigator: [Object](https://community.bistudio.com/wiki/Object) - person who pulled the trigger

### HitPart (Entity)[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitPart_(Entity))

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the object it was added to gets damaged. It returns the position and component that was hit on the object within a nested array, this is because the model may have more than one selection name for the hit component (i.e. a single piece of geometry can be simultaneously part of multiple, overlapping named selections).

While you can add "HitPart" handler to a remote unit, the respective [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) command must be executed on the shooter's PC and will only fire on shooter's PC as well. The event will not fire if the shooter is not local, even if the target itself is local. Additionally, if the unit gets damaged by any means other than ammunition or explosions, such as fall damage and burning, "HitPart" will not fire. Because of this, this event handler is most suitable for when the shooter needs feedback on his shooting, such as target practicing or hitmarker creation.

This EH returns an array of arrays. Each sub-array contains data for the part that was hit as usually multiple parts are hit at the same time (see [HitPart Sample](https://community.bistudio.com/wiki/HitPart_Sample)). The structure of the sub-arrays is listed below.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HitPart", { { [_x](https://community.bistudio.com/wiki/Magic_Variables#x) [params](https://community.bistudio.com/wiki/params) [ "_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect", "_instigator" ]; } [forEach](https://community.bistudio.com/wiki/forEach) [_this](https://community.bistudio.com/wiki/Magic_Variables#this); }];

- target: [Object](https://community.bistudio.com/wiki/Object) - object that was damaged
- shooter: [Object](https://community.bistudio.com/wiki/Object) - Unit or vehicle that inflicted the damage. If injured by a vehicle collision, the target itself is returned, or [objNull](https://community.bistudio.com/wiki/objNull) in case of explosions. In case of explosives that were planted by someone (e.g. satchel charges), that unit is returned.
- projectile: [Object](https://community.bistudio.com/wiki/Object) - object that was fired
- position: [Array](https://community.bistudio.com/wiki/Array) format [Position](https://community.bistudio.com/wiki/Position#PositionASL) - position the bullet impacted
- velocity: [Vector3D](https://community.bistudio.com/wiki/Vector3D) - 3D speed at which the bullet impacted
- selection: [Array](https://community.bistudio.com/wiki/Array) - array of [String](https://community.bistudio.com/wiki/String) with named selection of the object that were hit, in the FireGeometry LOD
- ammo:
  - [Array](https://community.bistudio.com/wiki/Array) in format [hitValue, indirectHitValue, indirectHitRange, explosiveDamage, ammoClassName] - If the damage was directly or indirectly inflicted by a projectile. Hit and damage values are derived from the projectile's [CfgAmmo Config Reference](https://community.bistudio.com/wiki/CfgAmmo_Config_Reference) class, and do not match the actual damage inflicted, which is usually lower due to armor and other factors.
  - [Array](https://community.bistudio.com/wiki/Array) in format [impulseValue, 0, 0, 0] - if the damage was inflicted by a vehicle collision
- vector: [Vector3D](https://community.bistudio.com/wiki/Vector3D) - Vector that is orthogonal (perpendicular) to the surface struck. For example, if a wall was hit, the vector would be pointing out of the wall at a 90 degree angle.
- radius: [Number](https://community.bistudio.com/wiki/Number) - radius (size) of component hit
- surfaceType: [String](https://community.bistudio.com/wiki/String) - surface type struck
- isDirect: [Boolean](https://community.bistudio.com/wiki/Boolean) - [true](https://community.bistudio.com/wiki/true) if object was directly hit, [false](https://community.bistudio.com/wiki/false) if it was hit by indirect / splash damage
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) instigator: [Object](https://community.bistudio.com/wiki/Object) - shot instigator

ⓘ

See [HitPart (Projectile)](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitPart_(Projectile)) for a similar event handler that is attached to the projectile instead of the entity.

ⓘ

This event does not fire when miniscule explosive damage is dealt to the target entity, but the [Explosion](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Explosion) event will still fire.

### IncomingMissile[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#IncomingMissile)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a unit fires a missile or rocket at the target. For projectiles fired by players this EH only triggers for guided missiles that have locked onto the target.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["IncomingMissile", { [params](https://community.bistudio.com/wiki/params) ["_target", "_ammo", "_vehicle", "_instigator", "_missile"]; }];

- target: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- ammo: [String](https://community.bistudio.com/wiki/String) - ammo type that was fired on the target
- [Category:Introduced with Arma 3 version 1.42](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.42)[Category:Introduced with Arma 3 version 1.42](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.42) vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle that fired the weapon. In case of soldier, unit is returned
- [Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66) instigator: [Object](https://community.bistudio.com/wiki/Object) - person who pulled the trigger
- [Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10)[Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10) missile: [Object](https://community.bistudio.com/wiki/Object) - the incoming missile

### Init (Entity)[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Init_(Entity))

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered whenever an entity is created. Cannot be used in scripts, only inside class Eventhandlers in config.

⚠

It is recommended to use the [PostInit](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#PostInit) event handler instead of this one when setting entity textures ([setObjectTexture](https://community.bistudio.com/wiki/setObjectTexture), [BIS fnc initVehicle](https://community.bistudio.com/wiki/BIS_fnc_initVehicle) etc) to avoid networking issues.

e.g:

```cpp
init = "params ['_entity'];";
```

Copy code to clipboard

[params](https://community.bistudio.com/wiki/params) ["_entity"];

- entity: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to

[Category:Introduced with Arma 3 version 1.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.22)[Category:Introduced with Arma 3 version 1.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.22)

### InventoryClosed[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#InventoryClosed)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the unit closes inventory. Said unit can be non-local when adding the EH, but **must** be local for the EH to trigger.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["InventoryClosed", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_container"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- container: [Object](https://community.bistudio.com/wiki/Object) - connected container or weaponholder

Copy code to clipboard

// Delete dropped items when inventory closed [player](https://community.bistudio.com/wiki/player) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["InventoryClosed", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_container"]; [if](https://community.bistudio.com/wiki/if) (_container [isKindOf](https://community.bistudio.com/wiki/isKindOf) "WeaponHolder") [then](https://community.bistudio.com/wiki/then) { [deleteVehicle](https://community.bistudio.com/wiki/deleteVehicle) _container; }; }];

[Category:Introduced with Arma 3 version 1.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.22)[Category:Introduced with Arma 3 version 1.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.22)

### InventoryOpened[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#InventoryOpened)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when unit opens inventory. Said unit can be non-local when adding the EH, but **must** be local for the EH to trigger. End EH main scope with [true](https://community.bistudio.com/wiki/true) to override the opening of the inventory in case you wish to handle it yourself:

Copy code to clipboard

// Create and open an ammo box when "Inventory" button is pressed [player](https://community.bistudio.com/wiki/player) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["InventoryOpened", { [player](https://community.bistudio.com/wiki/player) [removeAllEventHandlers](https://community.bistudio.com/wiki/removeAllEventHandlers) "InventoryOpened"; _box [=](https://community.bistudio.com/wiki/a_=_b) "Box_NATO_Ammo_F" [createVehicle](https://community.bistudio.com/wiki/createVehicle) [0,0,0]; _box [setPosASL](https://community.bistudio.com/wiki/setPosASL) ([player](https://community.bistudio.com/wiki/player) [modelToWorldVisualWorld](https://community.bistudio.com/wiki/modelToWorldVisualWorld) [0,1.5,0.5]); [player](https://community.bistudio.com/wiki/player) [action](https://community.bistudio.com/wiki/action) ["Gear", _box]; [true](https://community.bistudio.com/wiki/true); // <-- inventory override }];

To return all nearby containers use [nearSupplies](https://community.bistudio.com/wiki/nearSupplies) command.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["InventoryOpened", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_primaryContainer", "_secondaryContainer"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- primaryContainer: [Object](https://community.bistudio.com/wiki/Object) - connected container or weaponholder
- [Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66) secondaryContainer: [Object](https://community.bistudio.com/wiki/Object) - second connected container or weaponholder or [objNull](https://community.bistudio.com/wiki/objNull)

### Killed[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Killed)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the unit is killed.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Killed", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_killer", "_instigator", "_useEffects", "_shot", "_real"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - the object the event handler is assigned to
- killer: [Object](https://community.bistudio.com/wiki/Object) - the object that killed the unit. Contains the unit itself in case of collisions.
- [Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66) instigator: [Object](https://community.bistudio.com/wiki/Object) - the person who pulled the trigger
- [Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68)[Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68) useEffects: [Boolean](https://community.bistudio.com/wiki/Boolean) - same as *useEffects* in [setDamage](https://community.bistudio.com/wiki/setDamage) alt syntax
- [Category:Introduced with Arma 3 version 2.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.22)[Category:Introduced with Arma 3 version 2.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.22) shot: [Object](https://community.bistudio.com/wiki/Object) - shot that caused damage
- [Category:Introduced with Arma 3 version 2.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.22)[Category:Introduced with Arma 3 version 2.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.22) real: [Boolean](https://community.bistudio.com/wiki/Boolean) - [true](https://community.bistudio.com/wiki/true) when the shot was 'real' where the event handler triggered

### LandedStopped[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#LandedStopped)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when an AI pilot would get out usually. Not executed for player.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["LandedStopped", { [params](https://community.bistudio.com/wiki/params) ["_plane", "_airportID", "_airportObject"]; }];

- plane: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- airportID: [Number](https://community.bistudio.com/wiki/Number) - ID of the airport (-1 for anything else)
- [Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12)[Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12) airportObject: [Object](https://community.bistudio.com/wiki/Object) - airport object in the event of a [Arma 3: Dynamic Airport Configuration](https://community.bistudio.com/wiki/Arma_3:_Dynamic_Airport_Configuration), otherwise [objNull](https://community.bistudio.com/wiki/objNull)

### LandedTouchDown[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#LandedTouchDown)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a plane (AI or player) touches the ground.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["LandedTouchDown", { [params](https://community.bistudio.com/wiki/params) ["_plane", "_airportID", "_airportObject"]; }];

- plane: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- airportID: [Number](https://community.bistudio.com/wiki/Number) - ID of the airport (-1 for anything else)
- [Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12)[Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12) airportObject: [Object](https://community.bistudio.com/wiki/Object) - airport object in the event of a [Arma 3: Dynamic Airport Configuration](https://community.bistudio.com/wiki/Arma_3:_Dynamic_Airport_Configuration), otherwise [objNull](https://community.bistudio.com/wiki/objNull)

[Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70)[Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70)

### Landing[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Landing)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when an AI pilot (or auto-pilot) is preparing for landing. The exact moment of triggering coincides with lowering of the gear ("Gear" EH)

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Landing", { [params](https://community.bistudio.com/wiki/params) ["_plane", "_airportID", "_isCarrier"]; }];

- plane: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- airportID: [Number](https://community.bistudio.com/wiki/Number) or [Object](https://community.bistudio.com/wiki/Object) - ID of the airport or aircraft carrier object
- isCarrier: [Boolean](https://community.bistudio.com/wiki/Boolean) - true if landing on aircraft carrier

[Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70)[Category:Introduced with Arma 3 version 1.70](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.70)

### LandingCanceled[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#LandingCanceled)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when AI pilot landing is cancelled (for example new order received to land elsewhere). The exact moment of triggering coincides with retracting of the gear ("Gear" EH).
 **Note**: Does not trigger if player switches off auto-pilot. Canceled is spelled with one L

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["LandingCanceled", { [params](https://community.bistudio.com/wiki/params) ["_plane", "_airportID", "_isCarrier"]; }];

- plane: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- airportID: [Number](https://community.bistudio.com/wiki/Number) or [Object](https://community.bistudio.com/wiki/Object) - ID of the airport or aircraft carrier object (-1 no airport)
- isCarrier: [Boolean](https://community.bistudio.com/wiki/Boolean) - [true](https://community.bistudio.com/wiki/true) if landing on aircraft carrier

[Category:Introduced with Arma 3 version 2.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.22)[Category:Introduced with Arma 3 version 2.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.22)

### LaserTargetChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#LaserTargetChanged)

Triggered when the laser target changes.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["LaserTargetChanged", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_laserTarget", "_designatedTarget", "_turretPath"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- laserTarget: [Object](https://community.bistudio.com/wiki/Object) - the laser target entity that got created at impact point
- designatedTarget: [Object](https://community.bistudio.com/wiki/Object) - the object that is targeted by the laser
- turretPath: [Turret Path](https://community.bistudio.com/wiki/Turret_Path) - the path to the turret that activated the laser. It is empty when the event is triggered by a unit

[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)

### LeaningChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#LeaningChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a soldier leaning factor is changed between -1 (extreme left), 0 (not leaning) and 1 (extreme right)

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["LeaningChanged", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_newLeaning", "_oldLeaning"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - soldier
- newLeaning: [Number](https://community.bistudio.com/wiki/Number) from -1 to 1
- oldLeaning: [Number](https://community.bistudio.com/wiki/Number) from -1 to 1

### Local (Entity)[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Local_(Entity))

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when locality of object in MP is changed. The event handler only triggers on the computers that are directly involved in change of locality. So if EH is added to every computer on network, it will only trigger on 2 computers, on the computer that receives ownership of the object (new owner), in which case [Magic Variables](https://community.bistudio.com/wiki/Magic_Variables#this) [select](https://community.bistudio.com/wiki/select) 1 will be [true](https://community.bistudio.com/wiki/true), and on the computer from which ownership is transferred (old owner), in which case [Magic Variables](https://community.bistudio.com/wiki/Magic_Variables#this) [select](https://community.bistudio.com/wiki/select) 1 will be [false](https://community.bistudio.com/wiki/false).

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Local", { [params](https://community.bistudio.com/wiki/params) ["_entity", "_isLocal"]; }];

- entity: [Object](https://community.bistudio.com/wiki/Object) - the object that changed locality
- isLocal: [Boolean](https://community.bistudio.com/wiki/Boolean) - if the object is local on given computer

[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)

### MagazineReloading[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MagazineReloading)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when reloading starts.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["MagazineReloading", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_weapon", "_muzzle", "_magazine", "_magazineClass", "_ammoCount", "_magazineID", "_magazineCreator"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit or vehicle to which EH is assigned
- weapon: [String](https://community.bistudio.com/wiki/String) - weapon that got unloaded
- muzzle: [String](https://community.bistudio.com/wiki/String) - weapon's muzzle that got unloaded
- magazine: [Array](https://community.bistudio.com/wiki/Array) - magazine info in format [magazineClass, ammoCount, magazineID, magazineCreator], where:
  - magazineClass: [String](https://community.bistudio.com/wiki/String) - class name of the magazine
  - ammoCount: [Number](https://community.bistudio.com/wiki/Number) - amount of ammo in magazine
  - magazineID: [Number](https://community.bistudio.com/wiki/Number) - global magazine id
  - magazineCreator: [Number](https://community.bistudio.com/wiki/Number) - owner of the magazine creator

[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)

### MagazineUnloaded[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MagazineUnloaded)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when a magazine is removed from a weapon manually or via script.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["MagazineUnloaded", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_weapon", "_muzzle", "_magazine", "_magazineClass", "_ammoCount", "_magazineID", "_magazineCreator"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit or vehicle to which EH is assigned
- weapon: [String](https://community.bistudio.com/wiki/String) - weapon that got unloaded
- muzzle: [String](https://community.bistudio.com/wiki/String) - weapon's muzzle that got unloaded
- magazine: [Array](https://community.bistudio.com/wiki/Array) - magazine info in format [magazineClass, ammoCount, magazineID, magazineCreator], where:
  - magazineClass: [String](https://community.bistudio.com/wiki/String) - class name of the magazine
  - ammoCount: [Number](https://community.bistudio.com/wiki/Number) - amount of ammo in magazine
  - magazineID: [Number](https://community.bistudio.com/wiki/Number) - global magazine id
  - magazineCreator: [Number](https://community.bistudio.com/wiki/Number) - owner of the magazine creator

[Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10)[Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10)

### OpticsModeChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#OpticsModeChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers everytime a local unit changes optic mode. This could be either through the [setOpticsMode](https://community.bistudio.com/wiki/setOpticsMode) command or by the player switching to the next optic mode using e.g NUM / or Ctrl + ![Right Mouse Button](https://community.bistudio.com/wikidata/images/thumb/8/84/mouse-button-right.png/32px-mouse-button-right.png).

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["OpticsModeChanged", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_opticsClass", "_newMode", "_oldMode", "_isADS"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - the unit
- opticsClass: [String](https://community.bistudio.com/wiki/String)
- newMode: [String](https://community.bistudio.com/wiki/String)
- oldMode: [String](https://community.bistudio.com/wiki/String)
- isADS: [Boolean](https://community.bistudio.com/wiki/Boolean) - if the new view is GUNNER

[Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10)[Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10)

### OpticsSwitch[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#OpticsSwitch)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers at the start of the camera transition from GUNNER to INTERNAL/EXTERNAL and vice-versa. So anytime the right mouse button is pressed and there is a GUNNER view available or are currently in it, this triggers. Works in vehicles and FFV as well. See also [cameraView](https://community.bistudio.com/wiki/cameraView).

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["OpticsSwitch", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_isADS"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - the unit
- isADS: [Boolean](https://community.bistudio.com/wiki/Boolean) - if the new view is GUNNER

[Category:Introduced with Arma 3 version 1.94](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.94)[Category:Introduced with Arma 3 version 1.94](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.94)

### PathCalculated[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#PathCalculated)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when a path has been calculated for the unit. Works for both agents and normal AI units.
 Note that paths to far destinations are typically calculated in segments. When the unit completes a segment, a new path is calculated and this is continued until the unit reaches its destination.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["PathCalculated", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_path"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - the unit/agent for which the path was calculated
- path: [Array](https://community.bistudio.com/wiki/Array) - the array of positions representing the path (PositionASL)

[Category:Introduced with Arma 3 version 2.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.00)[Category:Introduced with Arma 3 version 2.00](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.00)

### PeriscopeElevationChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#PeriscopeElevationChanged)

Fires every frame during periscope elevation animation.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["PeriscopeElevationChanged", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_turret", "_elevation", "_direction", "_userIsBlocked"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - the vehicle this EH is assigned to
- turret: [Array](https://community.bistudio.com/wiki/Array) - the turret which periscope is changing elevation
- elevation: [Number](https://community.bistudio.com/wiki/Number) - current periscope elevation (changes with each simulation). See also [periscopeElevation](https://community.bistudio.com/wiki/periscopeElevation), [elevatePeriscope](https://community.bistudio.com/wiki/elevatePeriscope)
- direction: [Number](https://community.bistudio.com/wiki/Number) - 1: moves up, 0: stopped, -1: moves down; when direction returns 0, this also means the event handler fired for the last time for this elevation.
- userIsBlocked: [Boolean](https://community.bistudio.com/wiki/Boolean) - whether or not the user ability to override is blocked. See also [periscopeElevation](https://community.bistudio.com/wiki/periscopeElevation), [elevatePeriscope](https://community.bistudio.com/wiki/elevatePeriscope)

[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)

### PostInit[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#PostInit)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered whenever an entity is created and initialized. Cannot be used in scripts, only inside class Eventhandlers in config.

⚠

It is recommended to use this event handler instead of the [Init](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Init) one when setting entity textures ([setObjectTexture](https://community.bistudio.com/wiki/setObjectTexture), [BIS fnc initVehicle](https://community.bistudio.com/wiki/BIS_fnc_initVehicle) etc) to avoid networking issues.

e.g:

```cpp
postInit = "params ['_entity'];";
```

```cpp
postinit = "params ['_entity']; if (local _entity) then { [_entity, '', [], false] call BIS_fnc_initVehicle };";
```

Copy code to clipboard

[params](https://community.bistudio.com/wiki/params) ["_entity"];

- entity: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to

### PostReset[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#PostReset)

**Obsolete** - triggers after PP effects have been reset by the engine.

[Category:Introduced with Arma 3 version 0.56](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.56)[Category:Introduced with Arma 3 version 0.56](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.56)

### Put[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Put)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when a unit puts an item in a container.

[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14) This event handler can be added to a container.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Put", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_container", "_item"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit who put the item in the container
- container: [Object](https://community.bistudio.com/wiki/Object) - the container into which the item was placed (vehicle, box, etc.)
- item: [String](https://community.bistudio.com/wiki/String) - the class name of the moved item

ⓘ

This EH could also trigger when unit replaces magazine in weapon with another magazine from unit containers (uniform, vest, backpack) during reload.

[Category:Introduced with Arma 3 version 2.20](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.20)[Category:Introduced with Arma 3 version 2.20](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.20)

### PylonChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#PylonChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when an aircraft's pylon changes magazine type:

Copy code to clipboard

[vehicle](https://community.bistudio.com/wiki/vehicle) [player](https://community.bistudio.com/wiki/player) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["PylonChanged", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_pylonIndex", "_oldMagazine", "_newMagazine"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object)
- pylonIndex: [Number](https://community.bistudio.com/wiki/Number)
- oldMagazine: [String](https://community.bistudio.com/wiki/String)
- newMagazine: [String](https://community.bistudio.com/wiki/String)

⚠

This event generally triggers

**twice**

for a swap, first unload then load, e.g:

Copy code to clipboard

// [myVehicle, 1, "oldMagClass", ""] // [myVehicle, 1, "", "newMagClass"]

[Category:Introduced with Arma 3 version 1.58](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.58)[Category:Introduced with Arma 3 version 1.58](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.58)

### Reloaded[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Reloaded)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers once a weapon is reloaded with a new magazine. For more information, see [Arma 3: Event Handlers/Reloaded](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers/Reloaded).

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Reloaded", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit or vehicle to which EH is assigned
- weapon: [String](https://community.bistudio.com/wiki/String) - weapon that got reloaded
- muzzle: [String](https://community.bistudio.com/wiki/String) - weapon's muzzle that got reloaded
- newMagazine: [Array](https://community.bistudio.com/wiki/Array) - new magazine info
- oldMagazine: [Array](https://community.bistudio.com/wiki/Array) or [Nothing](https://community.bistudio.com/wiki/Nothing) - old magazine info

### Respawn[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Respawn)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a unit respawns.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Respawn", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_corpse"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- corpse: [Object](https://community.bistudio.com/wiki/Object) - object the event handler was assigned to, aka the corpse/unit player was previously controlling

[Category:Introduced with Arma 3 version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.34)[Category:Introduced with Arma 3 version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.34)

### RopeAttach[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#RopeAttach)

Triggered when a rope is attached to an object.
 In the case of sling loading, this event handler must be assigned to the helicopter and will trigger for each attached rope.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["RopeAttach", { [params](https://community.bistudio.com/wiki/params) ["_object1", "_rope", "_object2"]; }];

- object1: [Object](https://community.bistudio.com/wiki/Object) - object to which the event handler is assigned.
- rope: [Object](https://community.bistudio.com/wiki/Object) - the rope being attached between object 1 and object 2.
- object2: [Object](https://community.bistudio.com/wiki/Object) - the object that is being attached to object 1 via rope.

[Category:Introduced with Arma 3 version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.34)[Category:Introduced with Arma 3 version 1.34](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.34)

### RopeBreak[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#RopeBreak)

Triggered when a rope is detached from an object.
 In the case of sling loading, this event handler must be assigned to the helicopter and will trigger for each detached rope.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["RopeBreak", { [params](https://community.bistudio.com/wiki/params) ["_object1", "_rope", "_object2"]; }];

- object1: [Object](https://community.bistudio.com/wiki/Object) - object to which the event handler is assigned.
- rope: [Object](https://community.bistudio.com/wiki/Object) - the rope that connected object 1 and object 2.
- object2: [Object](https://community.bistudio.com/wiki/Object) - the object that was connected to object 1 with a rope.

[Category:Introduced with Arma 3 version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.50)[Category:Introduced with Arma 3 version 1.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.50)

### SeatSwitched[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SeatSwitched)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when unit changes seat within vehicle. EH returns both units switching seats. If switching seats with an empty seat, one of the returned units will be [objNull](https://community.bistudio.com/wiki/objNull). The new position can be obtained with [assignedVehicleRole](https://community.bistudio.com/wiki/assignedVehicleRole). This EH must be assigned to a vehicle.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["SeatSwitched", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_unit1", "_unit2"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle to which the event handler is assigned.
- unit1: [Object](https://community.bistudio.com/wiki/Object) - unit switching seat.
- unit2: [Object](https://community.bistudio.com/wiki/Object) - unit switching seat.

[Category:Introduced with Arma 3 version 1.58](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.58)[Category:Introduced with Arma 3 version 1.58](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.58)

### SeatSwitchedMan[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SeatSwitchedMan)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when unit changes seat within vehicle. EH returns both units switching seats. If switching seats with an empty seat, one of the returned units will be [objNull](https://community.bistudio.com/wiki/objNull). The new position can be obtained with [assignedVehicleRole](https://community.bistudio.com/wiki/assignedVehicleRole) <unit>. This EH must be assigned to a unit and not a vehicle. This EH is persistent and will be transferred to the new unit after respawn, but only if it was assigned where unit was local.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["SeatSwitchedMan", { [params](https://community.bistudio.com/wiki/params) ["_unit1", "_unit2", "_vehicle"]; }];

- unit1: [Object](https://community.bistudio.com/wiki/Object) - unit switching seat.
- unit2: [Object](https://community.bistudio.com/wiki/Object) - unit with which unit1 is switching seat.
- vehicle: [Object](https://community.bistudio.com/wiki/Object) - vehicle where switching seats is taking place.

### SelectedActionChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SelectedActionChanged)

RTM helicopter user action event

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["SelectedActionChanged", { [params](https://community.bistudio.com/wiki/params) ["_caller", "_target", "_enumNumber", "_actionId"]; }];

⚠

Limited or non-existent functionality.

### SelectedActionPerformed[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SelectedActionPerformed)

RTM helicopter user action event

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["SelectedActionPerformed", { [params](https://community.bistudio.com/wiki/params) ["_caller", "_target", "_enumNumber", "_actionId"]; }];

⚠

Limited or non-existent functionality.

### SelectedRotorLibActionChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SelectedRotorLibActionChanged)

RTM helicopter user action event

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["SelectedRotorLibActionChanged", { [params](https://community.bistudio.com/wiki/params) ["_caller", "_target", "_enumNumber", "_actionId"]; }];

⚠

Limited or non-existent functionality.

### SelectedRotorLibActionPerformed[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SelectedRotorLibActionPerformed)

RTM helicopter user action event

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["SelectedRotorLibActionPerformed", { [params](https://community.bistudio.com/wiki/params) ["_caller", "_target", "_enumNumber", "_actionId"]; }];

⚠

Works only for key press combination

RCtrl

+

W

, which is the binding for helicopter wheels brakes.

It fires with or without Advanced Flight Model enabled. The enum number returned is 4 and 5, probably because the enum is structured like this:

- 0: HelicopterAutoTrimOn
- 1: HelicopterAutoTrimOff
- 2: HelicopterTrimOn
- 3: HelicopterTrimOff
- 4: WheelsBrakeOn
- 5: WheelsBrakeOff

[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)

### SlotItemChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SlotItemChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when any of the following slots get assigned or unassigned: *Items* - Map, GPS, Radio, Watch, Compass, Helmet, Goggles, NVG; *Weapon* - Binoculars; *Containers* - Uniform, Vest, Backpack.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["SlotItemChanged", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_name", "_slot", "_assigned", "_weapon"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit EH assigned to.
- name: [String](https://community.bistudio.com/wiki/String) - name of the item/weapon/container (see [getSlotItemName](https://community.bistudio.com/wiki/getSlotItemName)).
- slot: [Number](https://community.bistudio.com/wiki/Number) - slot id (see [getSlotItemName](https://community.bistudio.com/wiki/getSlotItemName)).
- assigned: [Boolean](https://community.bistudio.com/wiki/Boolean) - [true](https://community.bistudio.com/wiki/true) assign action, [false](https://community.bistudio.com/wiki/false) unassign action.
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) weapon: [String](https://community.bistudio.com/wiki/String) - name of weapon in event that slot changed is a weapon attachment slot

[Category:Introduced with Arma 3 version 0.56](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.56)[Category:Introduced with Arma 3 version 0.56](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.56)

### SoundPlayed[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SoundPlayed)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when player is making noises when injured or fatigued for example. The number param passed to the EH code points to the sound origin:

1. Breath
2. Breath Injured
3. Breath Scuba
4. Injured
5. Pulsation
6. Hit Scream
7. Burning
8. Drowning
9. Drown
10. Gasping
11. Stabilizing
12. Healing
13. Healing With Medikit
14. Recovered
15. Breath Held

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["SoundPlayed", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_soundID"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit to which the event handler is assigned
- soundID: [Number](https://community.bistudio.com/wiki/Number) - sound origin

ⓘ

Since [Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12)[Category:Introduced with Arma 3 version 2.12](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.12) returning a [Number](https://community.bistudio.com/wiki/Number) from last added EH in range from 0 to 5 will alter the volume of played sound from mute to max volume.

[Category:Introduced with Arma 3 version 2.02](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.02)[Category:Introduced with Arma 3 version 2.02](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.02)

### Suppressed[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Suppressed)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when enemy projectile is passing by closer than defined suppression radius ammo value in config. Can be made to trigger for the same side if the side is set as enemy to itself (with [setFriend](https://community.bistudio.com/wiki/setFriend)). For more information see [Arma 3: Suppression](https://community.bistudio.com/wiki/Arma_3:_Suppression).

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Suppressed", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit to which the event is assigned
- distance: [Number](https://community.bistudio.com/wiki/Number) - distance of the projectile pass-by
- shooter: [Object](https://community.bistudio.com/wiki/Object) - who (or what) fired - vehicle or drone
- instigator: [Object](https://community.bistudio.com/wiki/Object) - who pressed the trigger. Instigator is different from the shooter when player is operator of UAV for example
- ammoObject: [Object](https://community.bistudio.com/wiki/Object) - the ammunition itself
- ammoClassName: [String](https://community.bistudio.com/wiki/String) - the ammunition's classname
- ammoConfig: [Config](https://community.bistudio.com/wiki/Config) - the ammunition's [CfgAmmo Config Reference](https://community.bistudio.com/wiki/CfgAmmo_Config_Reference) config path

[Category:Introduced with Arma 3 version 0.56](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.56)[Category:Introduced with Arma 3 version 0.56](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.56)

### Take[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Take)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when a unit takes an item from a container.

[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14) This event handler can be added to a container.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Take", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_container", "_item"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - unit who took the item from the container
- container: [Object](https://community.bistudio.com/wiki/Object) - the container from which the item was taken (vehicle, box, etc.)
- item: [String](https://community.bistudio.com/wiki/String) - the class name of the taken item

ⓘ

This EH could also trigger when unit replaces magazine in weapon with another magazine from unit containers (uniform, vest, backpack) during reload.

[Category:Introduced with Arma 3 version 1.32](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.32)[Category:Introduced with Arma 3 version 1.32](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.32)

### TaskSetAsCurrent[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#TaskSetAsCurrent)

Triggers when player's current task changes

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["TaskSetAsCurrent", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_task"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - the player to whom the event handler is assigned
- task: [Task](https://community.bistudio.com/wiki/Task) - the new current task

[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)

### TurnIn[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#TurnIn)

Triggers when member of crew in a vehicle uses Turn In [action](https://community.bistudio.com/wiki/action)

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["TurnIn", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_unit", "_turret"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - the vehicle the event handler is assigned to
- unit: [Object](https://community.bistudio.com/wiki/Object) - the unit performing the Turn In action
- turret: [Array](https://community.bistudio.com/wiki/Array) - turret path

[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)

### TurnOut[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#TurnOut)

Triggers when member of crew in a vehicle uses Turn Out [action](https://community.bistudio.com/wiki/action)

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["TurnOut", { [params](https://community.bistudio.com/wiki/params) ["_vehicle", "_unit", "_turret"]; }];

- vehicle: [Object](https://community.bistudio.com/wiki/Object) - the vehicle the event handler is assigned to
- unit: [Object](https://community.bistudio.com/wiki/Object) - the unit performing the Turn Out action
- turret: [Array](https://community.bistudio.com/wiki/Array) - turret path

[Category:Introduced with Arma 3 version 2.08](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.08)[Category:Introduced with Arma 3 version 2.08](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.08)

### VisionModeChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#VisionModeChanged)

Triggers when the assigned vehicle/unit's vision mode has changed.

Copy code to clipboard

[player](https://community.bistudio.com/wiki/player) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["VisionModeChanged", { [params](https://community.bistudio.com/wiki/params) ["_person", "_visionMode", "_TIindex", "_visionModePrev", "_TIindexPrev", "_vehicle", "_turret"]; }];

- person: [Object](https://community.bistudio.com/wiki/Object) - unit for whom the vision mode changes
- visionMode: [Number](https://community.bistudio.com/wiki/Number) - [currentVisionMode](https://community.bistudio.com/wiki/currentVisionMode)
- TIindex: [Number](https://community.bistudio.com/wiki/Number) - [setCamUseTI](https://community.bistudio.com/wiki/setCamUseTI); will return -1 when *visionMode* is not 2
- visionModePrev: [Number](https://community.bistudio.com/wiki/Number) - last vision mode
- TIindexPrev: [Number](https://community.bistudio.com/wiki/Number) - last TI mode; will return -1 when *visionModePrev* is not 2
- vehicle: [Object](https://community.bistudio.com/wiki/Object) - if unit is in a vehicle or controlling a UAV, this will be the vehicle
- turret: [Array](https://community.bistudio.com/wiki/Array) - turret path to the turret occupied by the unit, or [] if not on turret

### WeaponAssembled[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#WeaponAssembled)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when a weapon gets assembled. EH must be attached to the unit and not the weapon.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["WeaponAssembled", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_weapon", "_primaryBag", "_secondaryBag"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- weapon: [Object](https://community.bistudio.com/wiki/Object) - object of the assembled weapon
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) primaryBag: [Object](https://community.bistudio.com/wiki/Object) - primary bag (just before it is deleted)
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) secondaryBag: [Object](https://community.bistudio.com/wiki/Object) - secondary bag (just before it is deleted)

[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)

### WeaponChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#WeaponChanged)

Fires on weapon switch and firemode switch. Does not fire for player units inside vehicles (but does fire for vehicles with players in them).
 The locality is unknown, but it is known that this EH behaves like [currentWeapon](https://community.bistudio.com/wiki/currentWeapon), [currentWeaponMode](https://community.bistudio.com/wiki/currentWeaponMode) and [currentMuzzle](https://community.bistudio.com/wiki/currentMuzzle) in terms of locality.
 [Category:Introduced with Arma 3 version 2.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.22)[Category:Introduced with Arma 3 version 2.22](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.22) Fires for "Throw" muzzle changes too.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["WeaponChanged", { [params](https://community.bistudio.com/wiki/params) ["_object", "_oldWeapon", "_newWeapon", "_oldMode", "_newMode", "_oldMuzzle", "_newMuzzle", "_turretIndex"]; }];

- object: [Object](https://community.bistudio.com/wiki/Object) - the unit or vehicle the event handler is assigned to
- oldWeapon: [String](https://community.bistudio.com/wiki/String) - the class name of the previous weapon
- newWeapon: [String](https://community.bistudio.com/wiki/String) - the class name of the new weapon (same as [currentWeapon](https://community.bistudio.com/wiki/currentWeapon))
- oldMode: [String](https://community.bistudio.com/wiki/String) - the previous weapon mode
- newMode: [String](https://community.bistudio.com/wiki/String) - the new weapon mode (same as [currentWeaponMode](https://community.bistudio.com/wiki/currentWeaponMode))
- oldMuzzle: [String](https://community.bistudio.com/wiki/String) - the previous weapon muzzle
- newMuzzle: [String](https://community.bistudio.com/wiki/String) - the new weapon muzzle (same as [currentMuzzle](https://community.bistudio.com/wiki/currentMuzzle))
- turretIndex: [Array](https://community.bistudio.com/wiki/Array) format [Turret Path](https://community.bistudio.com/wiki/Turret_Path) - the turret path, or empty array if object is not a transport vehicle

[Category:Introduced with Arma 3 version 1.44](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.44)[Category:Introduced with Arma 3 version 1.44](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.44)

### WeaponDeployed[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#WeaponDeployed)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when the deployed state of a weapon or bipod changes.
 **Note:** A weapon cannot be rested and deployed at the same time.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["WeaponDeployed", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_isDeployed"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- isDeployed: [Boolean](https://community.bistudio.com/wiki/Boolean) - true if deployed

### WeaponDisassembled[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#WeaponDisassembled)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when a weapon gets disassembled. EH must be attached to the unit and not the weapon.
 **Note:** As of Arma 3 v1.32, this event does not fire if the weapon is not local.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["WeaponDisassembled", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_primaryBag", "_secondaryBag", "_weapon"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- primaryBag: [Object](https://community.bistudio.com/wiki/Object) - first backpack object which was weapon disassembled into
- secondaryBag: [Object](https://community.bistudio.com/wiki/Object) - second backpack object which was weapon disassembled into
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) weapon: [Object](https://community.bistudio.com/wiki/Object) - disassembled weapon (just before it is moved out of the world)

[Category:Introduced with Arma 3 version 1.44](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.44)[Category:Introduced with Arma 3 version 1.44](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.44)

### WeaponRested[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#WeaponRested)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggers when weapon rested state changes (weapon near a surface that can provide weapon support).
 **Note:** A weapon cannot be rested and deployed at the same time.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["WeaponRested", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_isRested"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- isRested: [Boolean](https://community.bistudio.com/wiki/Boolean) - true if rested

## Multiplayer Event Handlers[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Multiplayer_Event_Handlers)

Global object event handler, executed on every connected machine.

Commands:

- [addMPEventHandler](https://community.bistudio.com/wiki/addMPEventHandler)
- [removeMPEventHandler](https://community.bistudio.com/wiki/removeMPEventHandler)
- [removeAllMPEventHandlers](https://community.bistudio.com/wiki/removeAllMPEventHandlers)

⚠

A Multiplayer Event Handler is **not** saved in a save file and therefore will not be restored on load - use it accordingly.

### MPHit[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPHit)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the unit is hit/damaged. EH can be added on any machine and EH code will trigger globally on every connected client and server. This EH is clever enough to be triggered globally only once even if added on all clients or a single client that is then disconnected, EH will still trigger globally only once.

Is *not* always triggered when unit is killed by a hit. Most of the time only the [killed](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Killed) event handler is triggered when a unit dies from a hit. The hit EH will not necessarily fire if only minor damage occurred (e.g. firing a bullet at a tank), even though the damage increased. Can also trigger several times for an explosion (direct and indirect damage). Does not fire when a unit is set to [allowDamage](https://community.bistudio.com/wiki/allowDamage) [false](https://community.bistudio.com/wiki/false). However it will fire with "HandleDamage" EH added alongside stopping unit from taking damage (Copy code to clipboardunit [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HandleDamage", { 0 }];. Will not trigger once the unit is dead.

**Note:** call a function from the MPHit EH code space rather than defining the full code in there directly. The reason is the code space will be transferred over network on each event activation - so keep the data as small as possible!

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addMPEventHandler](https://community.bistudio.com/wiki/addMPEventHandler) ["MPHit", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_causedBy", "_damage", "_instigator"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- causedBy: [Object](https://community.bistudio.com/wiki/Object) - object that caused the damage. Contains the unit itself in case of collisions.
- damage: [Number](https://community.bistudio.com/wiki/Number) - level of damage caused by the hit
- [Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66) instigator: [Object](https://community.bistudio.com/wiki/Object) - person who pulled the trigger

### MPKilled[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPKilled)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when the unit is killed. EH can be added on any machine and EH code will trigger globally **on every connected client and server**. This EH has a safeguard measure so that even if it's added on all clients or a single client that is then disconnected, EH will still trigger globally only once per client.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addMPEventHandler](https://community.bistudio.com/wiki/addMPEventHandler) ["MPKilled", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_killer", "_instigator", "_useEffects"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- killer: [Object](https://community.bistudio.com/wiki/Object) - object that killed the unit. Contains the unit itself in case of collisions
- [Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66)[Category:Introduced with Arma 3 version 1.66](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.66) instigator: [Object](https://community.bistudio.com/wiki/Object) - person who pulled the trigger
- [Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68)[Category:Introduced with Arma 3 version 1.68](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.68) useEffects: [Boolean](https://community.bistudio.com/wiki/Boolean) - same as *useEffects* in [setDamage](https://community.bistudio.com/wiki/setDamage) alt syntax

### MPRespawn[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPRespawn)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a unit, it is assigned to, respawns. This EH does not work as one would expect MP EH should work like. It is only triggered on one machine where the unit it was assigned to is [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality). The only difference between **Respawn** and **MPRespawn** is that **MPRespawn** can be assigned from anywhere while **Respawn** requires the unit to be local.

 MPRespawn EH expects the EH code to return an array in [Position](https://community.bistudio.com/wiki/Position) format which will be used to place the respawned unit at the desired coordinates.
 For example: Copy code to clipboard[player](https://community.bistudio.com/wiki/player) [addMPEventHandler](https://community.bistudio.com/wiki/addMPEventHandler) ["MPRespawn", { [1234, 1234, 0] }]; will place player at [1234,1234,0] immediately on respawn.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addMPEventHandler](https://community.bistudio.com/wiki/addMPEventHandler) ["MPRespawn", { [params](https://community.bistudio.com/wiki/params) ["_unit", "_corpse"]; }];

- unit: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to
- corpse: [Object](https://community.bistudio.com/wiki/Object) - object the event handler was assigned to, aka the corpse/unit player was previously controlling.

## Mission Event Handlers[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Mission_Event_Handlers)

Mission Event Handlers are specific EHs that are anchored to the running mission and automatically removed when mission is over.

Commands:

- [addMissionEventHandler](https://community.bistudio.com/wiki/addMissionEventHandler)
- [removeMissionEventHandler](https://community.bistudio.com/wiki/removeMissionEventHandler)

ⓘ

See [Arma 3: Mission Event Handlers](https://community.bistudio.com/wiki/Arma_3:_Mission_Event_Handlers).

[Category:Introduced with Arma 3 version 1.16](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.16)[Category:Introduced with Arma 3 version 1.16](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_1.16)

## Curator Event Handlers[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Curator_Event_Handlers)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 [Arma 3: Curator](https://community.bistudio.com/wiki/Arma_3:_Curator) Event Handlers are also added with the [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) command. They are executed only where the curator is local - on the machine that is in control of it.

⚠

These Event Handlers must be added to the curator object/module, **not** the player!

Commands:

- [addEventHandler](https://community.bistudio.com/wiki/addEventHandler)
- [removeEventHandler](https://community.bistudio.com/wiki/removeEventHandler)
- [removeAllEventHandlers](https://community.bistudio.com/wiki/removeAllEventHandlers)

### CuratorFeedbackMessage[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorFeedbackMessage)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when curator attempts invalid action in curator interface.

Each error has its own unique ID, recognized values are:

- 003 - when trying to teleport camera outside of [curatorCameraArea](https://community.bistudio.com/wiki/curatorCameraArea)
- 101 - trying to place an object when placing is disabled using [setCuratorCoef](https://community.bistudio.com/wiki/setCuratorCoef) "place"
- 102 - trying to place an object which is too expensive (cost set in *curatorObjectRegistered* multiplied by [setCuratorCoef](https://community.bistudio.com/wiki/setCuratorCoef) "place" is larger than [curatorPoints](https://community.bistudio.com/wiki/curatorPoints))
- 103 - trying to place an object outside of [curatorEditingArea](https://community.bistudio.com/wiki/curatorEditingArea)
- 104 - items of a placed composition were skipped / could not be placed (since Arma 3 v2.06)
- 201 - trying to place a waypoint when waypoint placing is disabled
- 202 - trying to place a waypoint which is too expensive (cost set by [setCuratorWaypointCost](https://community.bistudio.com/wiki/setCuratorWaypointCost) multiplied by [setCuratorCoef](https://community.bistudio.com/wiki/setCuratorCoef) "place" is larger than [curatorPoints](https://community.bistudio.com/wiki/curatorPoints))
- 206 - trying to place a waypoint when no AI unit is selected
- 301 - trying to move or rotate an entity when editing is disabled using [setCuratorCoef](https://community.bistudio.com/wiki/setCuratorCoef) "edit"
- 302 - trying to move or rotate an entity when it is too expensive (entity cost multiplied by [setCuratorCoef](https://community.bistudio.com/wiki/setCuratorCoef) "edit" is larger than [curatorPoints](https://community.bistudio.com/wiki/curatorPoints))
- 303 - trying to move an entity outside of [curatorEditingArea](https://community.bistudio.com/wiki/curatorEditingArea)
- 304 - trying to move or rotate an entity which is outside of [curatorEditingArea](https://community.bistudio.com/wiki/curatorEditingArea)
- 307 - trying to move or rotate a player (players cannot be manipulated with)
- 401 - trying to delete an entity when deleting is disabled using [setCuratorCoef](https://community.bistudio.com/wiki/setCuratorCoef) "delete"
- 402 - trying to delete an entity which is too expensive (cost multiplied by [setCuratorCoef](https://community.bistudio.com/wiki/setCuratorCoef) "delete" is larger than [curatorPoints](https://community.bistudio.com/wiki/curatorPoints))
- 404 - trying to delete an entity which is outside of [curatorEditingArea](https://community.bistudio.com/wiki/curatorEditingArea)
- 405 - trying to delete an entity which has [curatorEditableObjects](https://community.bistudio.com/wiki/curatorEditableObjects) crew in it
- 407 - trying to delete a player (players cannot be manipulated with)
- 501 - trying to destroy an object when destroying is disabled using [setCuratorCoef](https://community.bistudio.com/wiki/setCuratorCoef) "destroy"
- 502 - trying to destroy an object which is too expensive (cost multiplied by [setCuratorCoef](https://community.bistudio.com/wiki/setCuratorCoef) "destroy" is larger than [curatorPoints](https://community.bistudio.com/wiki/curatorPoints))
- 504 - trying to destroy an object which is outside of [curatorEditingArea](https://community.bistudio.com/wiki/curatorEditingArea)
- 505 - trying to destroy an object which has [curatorEditableObjects](https://community.bistudio.com/wiki/curatorEditableObjects) crew in it
- 506 - trying to destroy an object when no object is selected
- 507 - trying to destroy a player (players cannot be manipulated with)

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorFeedbackMessage", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_errorID"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- errorID: [Number](https://community.bistudio.com/wiki/Number)

### CuratorGroupDoubleClicked[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorGroupDoubleClicked)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a group is double-clicked on in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorGroupDoubleClicked", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_group"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- group: [Group](https://community.bistudio.com/wiki/Group)

### CuratorGroupPlaced[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorGroupPlaced)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when new group is placed in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorGroupPlaced", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_group"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- group: [Group](https://community.bistudio.com/wiki/Group)

### CuratorGroupSelectionChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorGroupSelectionChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a group is selected in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorGroupSelectionChanged", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_group"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- group: [Group](https://community.bistudio.com/wiki/Group)

### CuratorMarkerDeleted[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorMarkerDeleted)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a marker is deleted in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorMarkerDeleted", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_marker"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- marker: [String](https://community.bistudio.com/wiki/String)

### CuratorMarkerDoubleClicked[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorMarkerDoubleClicked)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a marker is double-clicked on in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorMarkerDoubleClicked", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_marker"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- marker: [String](https://community.bistudio.com/wiki/String)

### CuratorMarkerEdited[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorMarkerEdited)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a marker is moved in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorMarkerEdited", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_marker"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- marker: [String](https://community.bistudio.com/wiki/String)

### CuratorMarkerPlaced[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorMarkerPlaced)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when new marker is placed in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorMarkerPlaced", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_marker"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- marker: [String](https://community.bistudio.com/wiki/String)

### CuratorMarkerSelectionChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorMarkerSelectionChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a marker is selected in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorMarkerSelectionChanged", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_marker"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- marker: [String](https://community.bistudio.com/wiki/String)

### CuratorObjectDeleted[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorObjectDeleted)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when an object is deleted in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorObjectDeleted", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_entity"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- entity: [Object](https://community.bistudio.com/wiki/Object)

### CuratorObjectDoubleClicked[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorObjectDoubleClicked)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when an object is double-clicked on in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorObjectDoubleClicked", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_entity"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- entity: [Object](https://community.bistudio.com/wiki/Object)

### CuratorObjectEdited[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorObjectEdited)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when an object is moved or rotated in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorObjectEdited", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_entity"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- entity: [Object](https://community.bistudio.com/wiki/Object)

### CuratorObjectPlaced[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorObjectPlaced)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when new object is placed in curator interface. This event handler will trigger individually for each unit in a placed group - excluding the crew in vehicles.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorObjectPlaced", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_entity"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- entity: [Object](https://community.bistudio.com/wiki/Object)

### CuratorObjectRegistered[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorObjectRegistered)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when player enters curator interface. Assign curator cost to every object in the game. This is the primary method that a mission designer can use to limit the objects a curator can place.

ⓘ

See [Curator](https://community.bistudio.com/wiki/Curator#Manual_Assigning).

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorObjectRegistered", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_input"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- input: [Array](https://community.bistudio.com/wiki/Array) of [String](https://community.bistudio.com/wiki/String) - all [Arma 3: Assets](https://community.bistudio.com/wiki/Arma_3:_Assets) classes

### CuratorObjectSelectionChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorObjectSelectionChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when an object is selected in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorObjectSelectionChanged", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_entity"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- entity: [Object](https://community.bistudio.com/wiki/Object)

### CuratorPinged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorPinged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a player pings his curator(s) by pressing the *Zeus* key.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorPinged", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_player"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- player: [Object](https://community.bistudio.com/wiki/Object)

[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)

### CuratorSelectionPresetLoaded[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorSelectionPresetLoaded)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a selection preset is loaded using the respective number key or through script.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorSelectionPresetLoaded", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_numkey"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- numkey: [Number](https://community.bistudio.com/wiki/Number)

[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)

### CuratorSelectionPresetSaved[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorSelectionPresetSaved)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a selection preset is saved using the respective CTRL + number key or set through script.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorSelectionPresetSaved", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_numkey"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- numkey: [Number](https://community.bistudio.com/wiki/Number)

### CuratorWaypointDeleted[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorWaypointDeleted)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a waypoint is deleted in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorWaypointDeleted", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_waypoint"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- waypoint: [Array](https://community.bistudio.com/wiki/Array)

### CuratorWaypointDoubleClicked[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorWaypointDoubleClicked)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a waypoint is double-clicked on in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorWaypointDoubleClicked", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_waypoint"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- waypoint: [Array](https://community.bistudio.com/wiki/Array)

### CuratorWaypointEdited[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorWaypointEdited)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a waypoint is moved in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorWaypointEdited", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_group", "_waypointID"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- group: [Group](https://community.bistudio.com/wiki/Group)
- waypointID: [Number](https://community.bistudio.com/wiki/Number)

### CuratorWaypointPlaced[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorWaypointPlaced)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when new waypoint is placed in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorWaypointPlaced", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_group", "_waypointID"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- group: [Group](https://community.bistudio.com/wiki/Group)
- waypointID: [Number](https://community.bistudio.com/wiki/Number)

### CuratorWaypointSelectionChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorWaypointSelectionChanged)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a waypoint is selected in curator interface.

Copy code to clipboard

[this](https://community.bistudio.com/wiki/Magic_Variables#this_2) [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CuratorWaypointSelectionChanged", { [params](https://community.bistudio.com/wiki/params) ["_curator", "_waypoint"]; }];

- curator: [Object](https://community.bistudio.com/wiki/Object)
- waypoint: [Array](https://community.bistudio.com/wiki/Array)

[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)[Category:Introduced with Arma 3 version 2.06](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.06)

## UserAction Event Handlers[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#UserAction_Event_Handlers)

UserAction Event Handlers are events that trigger on user action.

Commands:

- [addUserActionEventHandler](https://community.bistudio.com/wiki/addUserActionEventHandler)
- [removeUserActionEventHandler](https://community.bistudio.com/wiki/removeUserActionEventHandler)

ⓘ

See [Arma 3: Modded Keybinding](https://community.bistudio.com/wiki/Arma_3:_Modded_Keybinding).

### Activate[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Activate)

Copy code to clipboard

[addUserActionEventHandler](https://community.bistudio.com/wiki/addUserActionEventHandler) ["KeyName", "Activate", { [params](https://community.bistudio.com/wiki/params) ["_activated"]; }];

- activated: [Boolean](https://community.bistudio.com/wiki/Boolean) - always returns [true](https://community.bistudio.com/wiki/true)

### Deactivate[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Deactivate)

Copy code to clipboard

[addUserActionEventHandler](https://community.bistudio.com/wiki/addUserActionEventHandler) ["KeyName", "Deactivate", { [params](https://community.bistudio.com/wiki/params) ["_activated"]; }];

- activated: [Boolean](https://community.bistudio.com/wiki/Boolean) - always returns [false](https://community.bistudio.com/wiki/false)

### Analog[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Analog)

Copy code to clipboard

[addUserActionEventHandler](https://community.bistudio.com/wiki/addUserActionEventHandler) ["KeyName", "Analog", { [params](https://community.bistudio.com/wiki/params) ["_value"]; }];

- value: [Number](https://community.bistudio.com/wiki/Number) - input device's analog value

[Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10)[Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10)

## Projectile Event Handlers[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Projectile_Event_Handlers)

Commands:

- [addEventHandler](https://community.bistudio.com/wiki/addEventHandler)
- [removeEventHandler](https://community.bistudio.com/wiki/removeEventHandler)
- [removeAllEventHandlers](https://community.bistudio.com/wiki/removeAllEventHandlers)

### Deleted (Projectile)[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Deleted_(Projectile))

Copy code to clipboard

_projectile [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Deleted", { [params](https://community.bistudio.com/wiki/params) ["_projectile"]; }];

- projectile: [Object](https://community.bistudio.com/wiki/Object)

### Deflected[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Deflected)

Copy code to clipboard

_projectile [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Deflected", { [params](https://community.bistudio.com/wiki/params) ["_projectile", "_position", "_velocity", "_hitObject"]; }];

- projectile: [Object](https://community.bistudio.com/wiki/Object)
- position: [Array](https://community.bistudio.com/wiki/Array) format [Position](https://community.bistudio.com/wiki/Position#PositionASL)
- velocity: [Array](https://community.bistudio.com/wiki/Array) format [Vector3D](https://community.bistudio.com/wiki/Vector3D)
- hitObject: [Object](https://community.bistudio.com/wiki/Object) - the object that deflected the projectile

### Explode[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Explode)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)

Copy code to clipboard

_projectile [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Explode", { [params](https://community.bistudio.com/wiki/params) ["_projectile", "_position", "_velocity"]; }];

- projectile: [Object](https://community.bistudio.com/wiki/Object)
- position: [Array](https://community.bistudio.com/wiki/Array) format [Position](https://community.bistudio.com/wiki/Position#PositionASL)
- velocity: [Array](https://community.bistudio.com/wiki/Array) format [Vector3D](https://community.bistudio.com/wiki/Vector3D)

### HitExplosion[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitExplosion)

Copy code to clipboard

_projectile [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HitExplosion", { [params](https://community.bistudio.com/wiki/params) ["_projectile", "_hitEntity", "_projectileOwner", "_hitSelections", "_instigator"]; }];

- projectile: [Object](https://community.bistudio.com/wiki/Object)
- hitEntity: [Object](https://community.bistudio.com/wiki/Object)
- projectileOwner: [Object](https://community.bistudio.com/wiki/Object)
- hitSelections: [Array](https://community.bistudio.com/wiki/Array) of [Array](https://community.bistudio.com/wiki/Array) - same list of FireGeometry components that [HitPart (Entity)](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitPart_(Entity)) gets but only contains:
  - position: [Array](https://community.bistudio.com/wiki/Array) format [Position](https://community.bistudio.com/wiki/Position#PositionASL) - position of impact
  - vector: [Array](https://community.bistudio.com/wiki/Array) format [Vector3D](https://community.bistudio.com/wiki/Vector3D) - vector that is orthogonal (perpendicular) to the surface struck. For example, if a wall was hit, vector would be pointing out of the wall at a 90 degree angle
  - selection: [String](https://community.bistudio.com/wiki/String) - named selection of the object that was hit, in the FireGeometry LOD.
  - radius: [Number](https://community.bistudio.com/wiki/Number) - radius (size) of component hit
  - surface: [String](https://community.bistudio.com/wiki/String) - surface type struck
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) instigator: [Object](https://community.bistudio.com/wiki/Object) - shot instigator

### HitPart (Projectile)[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitPart_(Projectile))

Triggered when the projectile hits any surface.

Copy code to clipboard

_projectile [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["HitPart", { [params](https://community.bistudio.com/wiki/params) ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius" ,"_surfaceType", "_instigator"]; }];

- projectile: [Object](https://community.bistudio.com/wiki/Object)
- hitEntity: [Object](https://community.bistudio.com/wiki/Object)
- projectileOwner: [Object](https://community.bistudio.com/wiki/Object)
- pos: [Array](https://community.bistudio.com/wiki/Array) format [Position](https://community.bistudio.com/wiki/Position#PositionASL)
- velocity: [Array](https://community.bistudio.com/wiki/Array) format [Vector3D](https://community.bistudio.com/wiki/Vector3D)
- normal: [Array](https://community.bistudio.com/wiki/Array) format [Vector3D](https://community.bistudio.com/wiki/Vector3D)
- components: [Array](https://community.bistudio.com/wiki/Array) of [String](https://community.bistudio.com/wiki/String) - the selections that were hit, in the FireGeometry LOD.
- radius: [Number](https://community.bistudio.com/wiki/Number) - radius (size) of the hitPoint
- surfaceType: [String](https://community.bistudio.com/wiki/String)
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) instigator: [Object](https://community.bistudio.com/wiki/Object) - shot instigator

⚠

This event handler only triggers for direct hits and not splash damage, unlike [HitPart (Entity)](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitPart_(Entity)). For splash damage, use [HitExplosion](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HitExplosion).

### Init (Projectile)[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Init_(Projectile))

Triggered whenever a projectile is created. Cannot be used in scripts, only inside class Eventhandlers in config.

```cpp
init = "params ['_projectile'];";
```

Copy code to clipboard

[params](https://community.bistudio.com/wiki/params) ["_projectile"];

- projectile: [Object](https://community.bistudio.com/wiki/Object) - object the event handler is assigned to

[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)

### MineActivated[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MineActivated)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality) [Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)

Copy code to clipboard

_projectile [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["MineActivated", { [params](https://community.bistudio.com/wiki/params) ["_projectile", "_isActive"]; }];

- projectile: [Object](https://community.bistudio.com/wiki/Object)
- isActive: [Boolean](https://community.bistudio.com/wiki/Boolean) - new active state of the mine

### Penetrated[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Penetrated)

This event fires as many times as the projectile penetrates a surface.

Copy code to clipboard

_projectile [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Penetrated", { [params](https://community.bistudio.com/wiki/params) ["_projectile", "_hitObject", "_surfaceType", "_entryPoint", "_exitPoint", "_exitVector"]; }];

- projectile: [Object](https://community.bistudio.com/wiki/Object)
- hitObject: [Object](https://community.bistudio.com/wiki/Object)
- surfaceType: [String](https://community.bistudio.com/wiki/String) - see [surfaceType](https://community.bistudio.com/wiki/surfaceType)
- entryPoint: [Array](https://community.bistudio.com/wiki/Array) format [Position](https://community.bistudio.com/wiki/Position#PositionASL) - the projectile's entry point
- exitPoint: [Array](https://community.bistudio.com/wiki/Array) format [Position](https://community.bistudio.com/wiki/Position#PositionASL) - the projectile's exit point
- exitVector: [Array](https://community.bistudio.com/wiki/Array) format [Vector3D](https://community.bistudio.com/wiki/Vector3D) - speed/angle exit vector (see [vectorMagnitude](https://community.bistudio.com/wiki/vectorMagnitude) to obtain the speed, in metre per second)

### SubmunitionCreated[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SubmunitionCreated)

This event fires as many times as submunitions are created.

Copy code to clipboard

_projectile [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["SubmunitionCreated", { [params](https://community.bistudio.com/wiki/params) ["_projectile", "_submunitionProjectile", "_position", "_velocity"]; }];

- projectile: [Object](https://community.bistudio.com/wiki/Object)
- subMunitionProjectile: [Object](https://community.bistudio.com/wiki/Object)
- position: [Array](https://community.bistudio.com/wiki/Array) format [Position](https://community.bistudio.com/wiki/Position#PositionASL)
- velocity: [Array](https://community.bistudio.com/wiki/Array) format [Vector3D](https://community.bistudio.com/wiki/Vector3D)

[Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10)[Category:Introduced with Arma 3 version 2.10](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.10)

## Group Event Handlers[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Group_Event_Handlers)

Commands:

- [addEventHandler](https://community.bistudio.com/wiki/addEventHandler)
- [removeEventHandler](https://community.bistudio.com/wiki/removeEventHandler)
- [removeAllEventHandlers](https://community.bistudio.com/wiki/removeAllEventHandlers)

### CombatModeChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CombatModeChanged)

Triggers when the group's **[AI Behaviour](https://community.bistudio.com/wiki/AI_Behaviour)** changes (see [behaviour](https://community.bistudio.com/wiki/behaviour), [setBehaviour](https://community.bistudio.com/wiki/setBehaviour))

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CombatModeChanged", { [params](https://community.bistudio.com/wiki/params) ["_group", "_newMode"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- newMode: [String](https://community.bistudio.com/wiki/String) - see [AI Behaviour](https://community.bistudio.com/wiki/AI_Behaviour) (**not** [Combat Modes](https://community.bistudio.com/wiki/Combat_Modes)!)

### CommandChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CommandChanged)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["CommandChanged", { [params](https://community.bistudio.com/wiki/params) ["_group", "_newCommand"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- newCommand: [String](https://community.bistudio.com/wiki/String), can be one of: | "NO CMD" | NoCommand |
| --- | --- |
| "WAIT" | Wait |
| "ATTACK" | Attack |
| "Suppress" | Suppress |
| "HIDE" | Hide |
| "MOVE" | Move |
| "HOOK CARGO" | HookCargo |
| "UNHOOK CARGO" | UnhookCargo |
| "VIV GETIN" | ViVGetIn |
| "VIV GETOUT" | ViVGetOut |
| "VIV UNLOAD" | ViVUnload |
| "HEAL" | Heal |
| "REPAIR" | Repair |
| "REFUEL" | Refuel |
| "REARM" | Rearm |
| "SUPPORT" | Support |
| "JOIN" | Join |
| "GET IN" | GetIn |
| "FIRE" | Fire |
| "GET OUT" | GetOut |
| "STOP" | Stop |
| "EXPECT" | Expect |
| "ACTION" | Action |
| "SCRIPTED" | Scripted |
| "DISMISS" | Dismiss |
| "HEAL SOLDIER" | HealSoldier |
| "PATCH SOLDIER" | PatchSoldier |
| "FIRST AID" | FirstAid |
| "HEAL SELF" | HealSoldierSelf |
| "ATTACK AND FIRE" | AttackAndFire |
| "CARRY SOLDIER" | CarrySoldier |
| "DROP CARRIED" | DropCarried |
| "TAKE BAG" | TakeBag |
| "ASSEMBLE" | Assemble |
| "DISASSEMBLE" | DisAssemble |
| "DROP BAG" | DropBag |
| "OPEN BAG" | OpenBag |
| "IRLASER ON" | IRLaserOn |
| "IRLASER OFF" | IRLaserOff |
| "GUN LIGHT ON" | GunLightOn |
| "GUN LIGHT OFF" | GunLightOff |
| "FIRE AT POSITION" | FireAtPosition |
| "REPAIR VEHICLE" | RepairVehicle |
| "OPEN PARA" | OpenParachute |
| "KEEP DEPTH LEADER" | KeepDepthLeader |
| "KEEP DEPTH UND SURF" | KeepDepthUnderSurface |
| "KEEP DEPTH ABV SURF" | KeepDepthAboveSurface |
| "KEEP DEPTH BOTTOM" | KeepDepthBottom |
| "PUT IN" | PutIn |
| "UNLOAD FROM" | UnloadFrom |
| "USE CONTAINER MAGAZINE" | UseContainerMagazine |
| "ACTIVATE MINE" | ActivateMine |
| "DISABLE MINE" | DisableMine |

[↑ Back to spoiler's top](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#bikisp6aaa783c6fa81)

### Deleted (Group)[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Deleted_(Group))

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Deleted", { [params](https://community.bistudio.com/wiki/params) ["_group"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)

### Empty[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Empty)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Empty", { [params](https://community.bistudio.com/wiki/params) ["_group"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)

### EnableAttackChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#EnableAttackChanged)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["EnableAttackChanged", { [params](https://community.bistudio.com/wiki/params) ["_group", "_attackEnabled"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- attackEnabled: [Boolean](https://community.bistudio.com/wiki/Boolean)

### EnemyDetected[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#EnemyDetected)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["EnemyDetected", { [params](https://community.bistudio.com/wiki/params) ["_group", "_newTarget"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- newTarget: [Object](https://community.bistudio.com/wiki/Object)

### Fleeing[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Fleeing)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Fleeing", { [params](https://community.bistudio.com/wiki/params) ["_group", "_fleeingNow"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- fleeingNow: [Boolean](https://community.bistudio.com/wiki/Boolean)

### FormationChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#FormationChanged)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["FormationChanged", { [params](https://community.bistudio.com/wiki/params) ["_group", "_newFormation"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- newFormation: [String](https://community.bistudio.com/wiki/String) - see [setFormation](https://community.bistudio.com/wiki/setFormation)

### GroupIdChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#GroupIdChanged)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["GroupIdChanged", { [params](https://community.bistudio.com/wiki/params) ["_group", "_newGroupId"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- newGroupId: [String](https://community.bistudio.com/wiki/String)

### KnowsAboutChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#KnowsAboutChanged)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["KnowsAboutChanged", { [params](https://community.bistudio.com/wiki/params) ["_group", "_targetUnit", "_newKnowsAbout", "_oldKnowsAbout"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- targetUnit: [Object](https://community.bistudio.com/wiki/Object)
- newKnowsAbout: [Number](https://community.bistudio.com/wiki/Number)
- oldKnowsAbout: [Number](https://community.bistudio.com/wiki/Number)

### LeaderChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#LeaderChanged)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["LeaderChanged", { [params](https://community.bistudio.com/wiki/params) ["_group", "_newLeader"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- newLeader: [Object](https://community.bistudio.com/wiki/Object)

### Local (Group)[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Local_(Group))

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["Local", { [params](https://community.bistudio.com/wiki/params) ["_group", "_isLocal"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)

### SpeedModeChanged[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SpeedModeChanged)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["SpeedModeChanged", { [params](https://community.bistudio.com/wiki/params) ["_group", "_newSpeedMode"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- newSpeedMode: [String](https://community.bistudio.com/wiki/String) - see [setSpeedMode](https://community.bistudio.com/wiki/setSpeedMode)

### UnitJoined[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#UnitJoined)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["UnitJoined", { [params](https://community.bistudio.com/wiki/params) ["_group", "_newUnit"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- newUnit: [Object](https://community.bistudio.com/wiki/Object)

[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)

### UnitKilled[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#UnitKilled)

[Multiplayer Scripting](https://community.bistudio.com/wiki/Multiplayer_Scripting#Locality)
 Triggered when a unit in the group is killed.

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["UnitKilled", { [params](https://community.bistudio.com/wiki/params) ["_group", "_unit", "_killer", "_instigator", "_useEffects"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group) - the group the event handler is assigned to
- unit: [Object](https://community.bistudio.com/wiki/Object) - the unit that was killed
- killer: [Object](https://community.bistudio.com/wiki/Object) - the object that killed the unit. Contains the unit itself in case of collisions.
- instigator: [Object](https://community.bistudio.com/wiki/Object) - the person who pulled the trigger
- useEffects: [Boolean](https://community.bistudio.com/wiki/Boolean) - same as *useEffects* in [setDamage](https://community.bistudio.com/wiki/setDamage) alt syntax

### UnitLeft[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#UnitLeft)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["UnitLeft", { [params](https://community.bistudio.com/wiki/params) ["_group", "_oldUnit"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- oldUnit: [Object](https://community.bistudio.com/wiki/Object)

### VehicleAdded[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#VehicleAdded)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["VehicleAdded", { [params](https://community.bistudio.com/wiki/params) ["_group", "_newVehicle"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- newVehicle: [Object](https://community.bistudio.com/wiki/Object)

### VehicleRemoved[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#VehicleRemoved)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["VehicleRemoved", { [params](https://community.bistudio.com/wiki/params) ["_group", "_oldVehicle"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- oldVehicle: [Object](https://community.bistudio.com/wiki/Object)

### WaypointComplete[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#WaypointComplete)

Copy code to clipboard

_group [addEventHandler](https://community.bistudio.com/wiki/addEventHandler) ["WaypointComplete", { [params](https://community.bistudio.com/wiki/params) ["_group", "_waypointIndex"]; }];

- group: [Group](https://community.bistudio.com/wiki/Group)
- waypointIndex: [Number](https://community.bistudio.com/wiki/Number)

## Game UI Event Handlers[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Game_UI_Event_Handlers)

In Game UI Event Handlers trigger when user scrolls or activates in game action menu.
 The following mission EHs are available in Arma 3:

- [Arma 3: Event Handlers/inGameUISetEventHandler](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers/inGameUISetEventHandler#PrevAction) - action menu scroll up event
- [Arma 3: Event Handlers/inGameUISetEventHandler](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers/inGameUISetEventHandler#Action) - action menu action event
- [Arma 3: Event Handlers/inGameUISetEventHandler](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers/inGameUISetEventHandler#NextAction) - action menu scroll down event

⚠

Only one event of each kind can exist, adding another will overwrite the existing one.

Commands:

- [inGameUISetEventHandler](https://community.bistudio.com/wiki/inGameUISetEventHandler)

ⓘ

See [Arma 3: Event Handlers/inGameUISetEventHandler](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers/inGameUISetEventHandler).

## Control/Display UI Event Handlers[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Control/Display_UI_Event_Handlers)

Commands:

- [ctrlAddEventHandler](https://community.bistudio.com/wiki/ctrlAddEventHandler)
- [ctrlRemoveEventHandler](https://community.bistudio.com/wiki/ctrlRemoveEventHandler)
- [ctrlRemoveAllEventHandlers](https://community.bistudio.com/wiki/ctrlRemoveAllEventHandlers)
- [displayAddEventHandler](https://community.bistudio.com/wiki/displayAddEventHandler)
- [displayRemoveEventHandler](https://community.bistudio.com/wiki/displayRemoveEventHandler)
- [displayRemoveAllEventHandlers](https://community.bistudio.com/wiki/displayRemoveAllEventHandlers)

ⓘ

See [User Interface Event Handlers](https://community.bistudio.com/wiki/User_Interface_Event_Handlers).

## Music Event Handlers[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Music_Event_Handlers)

Music event handler, always executed on the computer where it was added.

ⓘ

Does not apply to [hasInterface](https://community.bistudio.com/wiki/hasInterface) machines (dedicated server, headless client).

Commands:

- [setMusicEventHandler](https://community.bistudio.com/wiki/setMusicEventHandler)
- [addMusicEventHandler](https://community.bistudio.com/wiki/addMusicEventHandler)
- [removeMusicEventHandler](https://community.bistudio.com/wiki/removeMusicEventHandler)
- [removeAllMusicEventHandlers](https://community.bistudio.com/wiki/removeAllMusicEventHandlers)

[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)

### MusicStart[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MusicStart)

Triggers when [CfgMusic](https://community.bistudio.com/wiki/Description.ext#cfgMusic) sound starts playing, after being executed with [playMusic](https://community.bistudio.com/wiki/playMusic) command.

Copy code to clipboard

[addMusicEventHandler](https://community.bistudio.com/wiki/addMusicEventHandler) ["MusicStart", { [params](https://community.bistudio.com/wiki/params) ["_musicClassname", "_eventHandlerID", "_currentPosition", "_totalLength"]; }];

- musicClassName: [String](https://community.bistudio.com/wiki/String) - [CfgMusic](https://community.bistudio.com/wiki/Description.ext#Music) class name of the music that started
- eventHandlerID: [Number](https://community.bistudio.com/wiki/Number) - EH id returned by [addMusicEventHandler](https://community.bistudio.com/wiki/addMusicEventHandler)
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) currentPosition: [Number](https://community.bistudio.com/wiki/Number) - current playback position in 0...1 range (see also: [getMusicPlayedTime](https://community.bistudio.com/wiki/getMusicPlayedTime))
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) totalLength: [Number](https://community.bistudio.com/wiki/Number) - track total length in seconds

[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)[Category:Introduced with Arma 3 version 0.50](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_0.50)

### MusicStop[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MusicStop)

Triggers when [CfgMusic](https://community.bistudio.com/wiki/Description.ext#cfgMusic) sound finished playing, after being executed with [playMusic](https://community.bistudio.com/wiki/playMusic) command.
 [Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14)[Category:Introduced with Arma 3 version 2.14](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.14) Copy code to clipboard[playMusic](https://community.bistudio.com/wiki/playMusic) "" triggers this event if a music is currently playing.

Copy code to clipboard

[addMusicEventHandler](https://community.bistudio.com/wiki/addMusicEventHandler) ["MusicStop", { [params](https://community.bistudio.com/wiki/params) ["_musicClassname", "_eventHandlerID", "_currentPosition", "_totalLength"]; }];

- musicClassName: [String](https://community.bistudio.com/wiki/String) - [CfgMusic](https://community.bistudio.com/wiki/Description.ext#Music) class name of the music that stopped
- eventHandlerID: [Number](https://community.bistudio.com/wiki/Number) - EH id returned by [addMusicEventHandler](https://community.bistudio.com/wiki/addMusicEventHandler)
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) currentPosition: [Number](https://community.bistudio.com/wiki/Number) - current playback position in 0...1 range (see also: [getMusicPlayedTime](https://community.bistudio.com/wiki/getMusicPlayedTime))
- [Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18)[Category:Introduced with Arma 3 version 2.18](https://community.bistudio.com/wiki/Category:Introduced_with_Arma_3_version_2.18) totalLength: [Number](https://community.bistudio.com/wiki/Number) - track total length in seconds

## Eden Editor[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Eden_Editor)

Commands:

- [add3DENEventHandler](https://community.bistudio.com/wiki/add3DENEventHandler)
- [remove3DENEventHandler](https://community.bistudio.com/wiki/remove3DENEventHandler)
- [removeAll3DENEventHandlers](https://community.bistudio.com/wiki/removeAll3DENEventHandlers)

ⓘ

See also:

- [Arma 3: Event Handlers: Eden Editor](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers:_Eden_Editor)
- its sub-category [Arma 3: Event Handlers: Eden Editor](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers:_Eden_Editor#Object_Event_Handlers)
- [Category:Eden Editor](https://community.bistudio.com/wiki/Category:Eden_Editor)

## Public Variable Broadcast Event[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Public_Variable_Broadcast_Event)

Commands:

- [addPublicVariableEventHandler](https://community.bistudio.com/wiki/addPublicVariableEventHandler)

Triggers when [missionNamespace](https://community.bistudio.com/wiki/missionNamespace) variable EH is associated with is sent over network via [publicVariable](https://community.bistudio.com/wiki/publicVariable), [publicVariableServer](https://community.bistudio.com/wiki/publicVariableServer) or [publicVariableClient](https://community.bistudio.com/wiki/publicVariableClient) commands.

ⓘ

Unlike with other types of EHs, there is no way of removing added public variable event handler

## Weapon Muzzle Config Events[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Weapon_Muzzle_Config_Events)

There are six event handlers that can be set on weapon in config. Their parameters are the same as their entity EH equivalents.

- "Fired" - when muzzle fired - see [Fired](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Fired)
- "Reload" - before muzzle is reloaded - see [MagazineReloading](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MagazineReloading)
- "Reloaded" - after muzzle is reloaded - see [Reloaded](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Reloaded)
- "MagazineUnloaded" - when the magazine is removed - see [MagazineUnloaded](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MagazineUnloaded)
- "WeaponChanged" - when the weapon is switched to or from - see [WeaponChanged](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#WeaponChanged)
- "SlotItemChanged" - when one of the weapon's attachments is changed - see [SlotItemChanged](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#SlotItemChanged)

```cpp
class CfgWeapons
{
	class RifleCore;
	class TAG_Rifle : RifleCore
	{
		class EventHandlers
		{
			fired		= "systemChat format ['fired weapon EH output: %1 [time: %2]', _this, time]";
			reload		= "systemChat format ['reload weapon EH output: %1 [time: %2]', _this, time]";
			reloaded	= "systemChat format ['reloaded weapon EH output: %1 [time: %2]', _this, time]";
			magazineunloaded	= "systemChat format ['magazineunloaded weapon EH output: %1 [time: %2]', _this, time]";
			slotitemchanged	= "systemChat format ['slotitemchanged weapon EH output: %1 [time: %2]', _this, time]";
			weaponchanged	= "systemChat format ['weaponchanged weapon EH output: %1 [time: %2]', _this, time]";
		};
	};
};
```

## Ammo Config Events[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Ammo_Config_Events)

There are three event handlers that can be set on ammo in config:

- "init" - when the ammo is created, by any mean (fired, created, etc). Params: [shot]
- "fired" - when the ammo is fired (legacy). Params: same as in entity EH "Fired".
- "ammoHit" - when the ammo hits anything (can trigger multiple times). Params: [shot, shooter, hitobj, pos, velocity, hitComponents, [hit, indirecthit, indirecthitrange, explosive, name], normal, explode, instigator (since Arma 3 v2.18)]

```cpp
class CfgAmmo
{
	class BulletCore;
	class TAG_Bullet : BulletCore
	{
		class EventHandlers
		{
			init	= "systemChat format ['init ammo EH output: %1 [time: %2]', _this, time]";
			fired	= "systemChat format ['fired ammo EH output: %1 [time: %2]', _this, time]";
			ammoHit	= "systemChat format ['ammoHit EH output: %1 [time: %2]', _this, time]";
		};
	};
};
```

## BI Scripted Events[Link](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#BI_Scripted_Events)

Commands:

- [BIS fnc addScriptedEventHandler](https://community.bistudio.com/wiki/BIS_fnc_addScriptedEventHandler)
- [BIS fnc removeScriptedEventHandler](https://community.bistudio.com/wiki/BIS_fnc_removeScriptedEventHandler)
- [BIS fnc removeAllScriptedEventHandlers](https://community.bistudio.com/wiki/BIS_fnc_removeAllScriptedEventHandlers)
- [BIS fnc callScriptedEventHandler](https://community.bistudio.com/wiki/BIS_fnc_callScriptedEventHandler)

ⓘ

See also [Arma 3: Scripted Event Handlers](https://community.bistudio.com/wiki/Arma_3:_Scripted_Event_Handlers).

Jump to [the top](https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#top) of the page

Retrieved from "[https://community.bistudio.com/wiki?title=Arma_3:_Event_Handlers&oldid=378964](https://community.bistudio.com/wiki?title=Arma_3:_Event_Handlers&oldid=378964)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Event Handlers](https://community.bistudio.com/wiki/Category:Event_Handlers)