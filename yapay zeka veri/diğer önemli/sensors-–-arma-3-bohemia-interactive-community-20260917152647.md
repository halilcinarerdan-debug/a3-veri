# Sensors – Arma 3 - Bohemia Interactive Community

[Jump to content](https://community.bistudio.com/wiki/Arma_3:_Sensors#content)

[ ]

[ ]

Link

From Bohemia Interactive Community

Category: [Category:Arma 3](https://community.bistudio.com/wiki/Category:Arma_3)

## Overview[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Overview)

Vehicle and ammo sensors for target detection and tracking.

### **> [OPREP](https://dev.arma3.com/post/oprep-sensor-overhaul)**[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#%3E_OPREP)

### **> [Forum thread](https://forums.bistudio.com/topic/200467-jets-sensor-overhaul/)**[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#%3E_Forum_thread)

### **> [Arma 3: Sensors config reference](https://community.bistudio.com/wiki/Arma_3:_Sensors_config_reference)**[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#%3E_Configuration)

# User Interface[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#User_Interface)

[Link](https://community.bistudio.com/wiki/File:Arma_3_Sensors_Sensor_Display_symbology.png)

## Action keybinds (default)[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Action_keybinds_(default))

| **R** | Select next target (targets are prioritized according to the currently selected weapon and the target threat) |
| --- | --- |
| **T** | Select target under the cursor / center of view |
| **LCTRL + R** | Toggle radar on/off |

See **[Arma 3: Custom Info](https://community.bistudio.com/wiki/Arma_3:_Custom_Info)** page for more info about controlling the Sensor display.

# Mechanics[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Mechanics)

### Active Radar[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Active_Radar)

- only sensor that can be switched ON and OFF.
- only sensor that provides information about a target's speed, altitude, and distance
- to be able to lock on target the radar-guided (ARH) missiles require the radar to be switched ON
- activated radar makes your vehicle detectable by RWR or Passive radars at up to twice the range of your own radar.

### RWR and Passive Radar[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#RWR_and_Passive_Radar)

- detects anyone who has a radar ON at twice the distance of the tracked radar's own range.
- provides unique indication to targets with active radars
- most often the RWR can detect radar threat in 360° field-of-view
- additional passive radar (less common than RWR) allows you to mark the radar threat and use it for targeting your weapons

### Infrared sensor[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Infrared_sensor)

- can only detect 'hot' targets - vehicles that have been heated up by a running engine or fired weapon
- susceptible to environmental conditions (fog)
- often with field-of-view limited to the optics field-of-view
- often coupled with Visual sensor

### Visual sensor[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Visual_sensor)

- can detect cold targets
- susceptible to environmental conditions (fog, light), in most cases useless at night
- often with field-of-view limited to the optics field-of-view
- often coupled with IR sensor

### Laser and strobe tracker[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Laser_and_strobe_tracker)

- detect a spot lased by a laser designator or an IR grenade (as a homing beacon)
- usually with a 180° front hemisphere field-of-view

### Human sensor[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Human_sensor)

- able to detect and track human targets
- *doesn't fully work with data link*

### Data Link[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Data_Link)

- with **send position** capability - broadcasts own position to everyone on the same side who has a receive capability
  - *Can be adjusted in-game via [vehicleReportOwnPosition](https://community.bistudio.com/wiki/vehicleReportOwnPosition), [setVehicleReportOwnPosition](https://community.bistudio.com/wiki/setVehicleReportOwnPosition) or in Eden editor vehicle attributes - Electronics & Sensors*
- with **send** capability - broadcasts all targets acquired by own sensor suite to everyone on the same side who has a receive capability
  - *Can be adjusted in-game via [vehicleReportRemoteTargets](https://community.bistudio.com/wiki/vehicleReportRemoteTargets), [setVehicleReportRemoteTargets](https://community.bistudio.com/wiki/setVehicleReportRemoteTargets) or in Eden editor vehicle attributes - Electronics & Sensors*
- with **receive** capability - receives targets from send-enabled units on the same side; the targets will be displayed on [Arma 3 Custom Info](https://community.bistudio.com/wiki/Arma_3_Custom_Info#Modules) - meaning the vehicle has to have the sensor panel in the first place
  - *Can be adjusted in-game via [vehicleReceiveRemoteTargets](https://community.bistudio.com/wiki/vehicleReceiveRemoteTargets), [setVehicleReceiveRemoteTargets](https://community.bistudio.com/wiki/setVehicleReceiveRemoteTargets) or in Eden editor vehicle attributes - Electronics & Sensors*
- with **targeting** ([Arma 3 Sensors config reference](https://community.bistudio.com/wiki/Arma_3_Sensors_config_reference#componentType)) capability - conditioned by the receive capability; adds an ability to mark targets received via data link and achieve an easier lock-on or engage these targets with [A3 Targeting config reference](https://community.bistudio.com/wiki/A3_Targeting_config_reference#autoSeekTarget) ammo.

# Vehicles[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Vehicles)

| Name | Sensors | FoV hor./vert. | Range sky/gnd (m) | target ID range (m) | Notes |
| --- | --- | --- | --- | --- | --- |
| xH-9 helicopters, Caesar | N/A |  |  |  |  |
| UH-80, CH-49, CH-67, PO-30, Mi-290, WY-55 | RWR | 360 | 16000 | 12000 |  |
| IFV-6a, ZSU-39 | Radar | 360/100 | 9000/6000 | 5000 | up looking |
| IFV-6a, ZSU-39 |  |  |  |  |  |
| Data Link | 360 | 16000 |  |  |  |
| AH-99 | RWR | 360 | 16000 | 12000 |  |
| AH-99 |  |  |  |  |  |
| AH-99 |  |  |  |  |  |
| AH-99 |  |  |  |  |  |
| Laser + Strobe | 180 | 6000 |  | front hemisphere |  |
| IR + Visual | 46/34 | 3000/2000 + 2000/1500 | 2000 | targeting camera |  |
| Radar | 180/90 | 5000/4000 | 3000 | down looking |  |
| Mi-48 | RWR | 360 | 16000 | 12000 |  |
| Mi-48 |  |  |  |  |  |
| Mi-48 |  |  |  |  |  |
| Mi-48 |  |  |  |  |  |
| Laser + Strobe | 180 | 6000 |  | front hemisphere |  |
| IR + Visual | 26/26 | 4000/3000 + 3000/2000 | 2000 | targeting camera |  |
| Radar | 120/90 | 5000/4000 | 3000 | down looking |  |
| A-143 | RWR | 360 | 16000 | 12000 |  |
| A-143 |  |  |  |  |  |
| A-143 |  |  |  |  |  |
| A-143 |  |  |  |  |  |
| Laser + Strobe | 180 | 6000 |  | front hemisphere |  |
| IR + Visual | 26/20 | 4000/3000 + 3000/2000 | 2000 | targeting camera |  |
| Radar | 90 | 8000/4000 | 3000 |  |  |
| A-164, To-199 | RWR + Anti-radiation | 360 + 90 | 16000 + 8000 | 12000 |  |
| A-164, To-199 |  |  |  |  |  |
| A-164, To-199 |  |  |  |  |  |
| Laser + Strobe | 180 | 6000 |  | front hemisphere |  |
| IR + Visual | 50/37 | 5000/4000 + 4000/3000 | 2000 | targeting camera |  |
| F/A-181 | RWR | 360 | 16000 | 12000 |  |
| F/A-181 |  |  |  |  |  |
| F/A-181 |  |  |  |  |  |
| F/A-181 |  |  |  |  |  |
| F/A-181 |  |  |  |  |  |
| Laser + Strobe | 180 | 6000 |  | front hemisphere |  |
| IR | 360/90 | 2500/2000 | 2000 |  |  |
| Visual | 26/20 | 4000/3000 | 2000 | targeting camera |  |
| Radar | 45 | 15000/8000 | 8000 |  |  |
| To-201 | RWR | 360 | 16000 | 12000 |  |
| To-201 |  |  |  |  |  |
| To-201 |  |  |  |  |  |
| To-201 |  |  |  |  |  |
| To-201 |  |  |  |  |  |
| Laser + Strobe | 180 | 6000 |  | front hemisphere |  |
| IR | 360/120 | 5000/3000 | 2000 |  |  |
| Visual | 26/20 | 4000/3000 | 2000 | targeting camera |  |
| Radar | 60 | 13000/9000 | 6000 |  |  |
| A-149 | RWR | 360 | 16000 | 12000 |  |
| A-149 |  |  |  |  |  |
| A-149 |  |  |  |  |  |
| A-149 |  |  |  |  |  |
| A-149 |  |  |  |  |  |
| Laser + Strobe | 180 | 6000 |  | front hemisphere |  |
| IR | 90/60 | 4000/3000 | 2000 |  |  |
| Visual | 26/20 | 4000/3000 | 2000 | targeting camera |  |
| Radar | 45 | 12000/8000 | 4000 |  |  |
| Sentinel | RWR | 360 | 16000 | 12000 |  |
| Sentinel |  |  |  |  |  |
| Sentinel |  |  |  |  |  |
| Sentinel |  |  |  |  |  |
| Laser + Strobe | 180 | 6000 |  | front hemisphere |  |
| IR + Visual | 51/37 | 4000/3000 + 3500/3000 | 4000 + 3000 | targeting camera |  |
| Radar | 60 | 8000/6000 | 6000 | down looking |  |
| Praetorian 1C | Radar | 360/100 | 10000/7000 | 10000 | up looking |
| Praetorian 1C |  |  |  |  |  |
| Praetorian 1C |  |  |  |  |  |
| IR | 60/40 | 4000/3500 | 3500 |  |  |
| Data Link | 360 | 16000 |  |  |  |
| Mk21 | Radar | 15 | 14000/11000 | 11000 |  |
| Mk21 |  |  |  |  |  |
| Mk21 |  |  |  |  |  |
| Visual | 60/40 | 4000/3500 | 4000 |  |  |
| Data Link | 360 | 16000 |  |  |  |
| Mk49 | IR | 60/40 | 4000/3500 | 3500 |  |
| Mk49 |  |  |  |  |  |
| Data Link | 360 | 16000 |  |  |  |
| WIP |  |  |  |  |  |

# Precision guided munitions[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#Precision_guided_munitions)

| Name | Seeker | Cone (degrees) | Min-Max range (m) | Target speed (km/h) | Notes |
| --- | --- | --- | --- | --- | --- |
| PCML | Visual | 5° | 20-600 | 126 |  |
| Titan AT | IR | 4° | 50-4000 | 126 | + manual guidance |
| Titan AP | N/A |  |  |  | manual guidance only |
| DAGR | IR + Laser | 30° | 100-5000 | 126 | + manual guidance |
| Scalpel | IR + Laser | 30° | 250-6000 | 198 | + manual guidance |
| Macer | IR | 30° | 350-6000 | 198 |  |
| KH25 / Sharur | IR | 20° | 300-6000 | 144 |  |
| Jian | IR + Laser | 30° | 350-8000 | 126 | + manual guidance |
| GBU-12 | Laser | 180° | 250-8000 | 108 | doesn't require full lock |
| LOM-250 | Laser | 180° | 250-8000 | 108 | doesn't require full lock |
| Titan AA | IR | 4° | 100-3500 | 900 |  |
| Titan AA Long | IR | 30° | 100-4500 | 1800 |  |
| Zephyr | Radar (ARH) | 40° | 500-10000 | 3006 |  |
| ASRAAM | IR | 90° | 200-6000 | 2160 |  |
| AMRAAM | Radar (ARH) | 70° | 800-12000 |  |  |
| Falchion-22 | IR | 30° | 150-4500 | 1602 |  |
| Sahr-3 | IR | 45° | 150-5000 | 2520 |  |
| RIM-116 | IR | 180° | 250-4000 | 2160 |  |
| RIM-162 | Radar (ARH) | 120° | 1000-12000 | 3240 |  |
| BIM-9X | IR | 180° | 250-5000 | 2160 |  |
| BIM-120C | Radar (ARH) | 50° | 1000-12000 | 2880 |  |
| BIM-120D | Radar (ARH) | 100° | 1000-13000 | 2880 |  |
| R73 | IR | 150° | 75-6000 | 2160 |  |
| R77 | Radar (ARH) | 65° | 1000-10000 | 2880 |  |

# See Also[Link](https://community.bistudio.com/wiki/Arma_3:_Sensors#See_Also)

- [Arma 3: Custom Info](https://community.bistudio.com/wiki/Arma_3:_Custom_Info)
- [Arma 3: Targeting](https://community.bistudio.com/wiki/Arma_3:_Targeting)
- [Category:Command Group: Sensors](https://community.bistudio.com/wiki/Category:Command_Group:_Sensors)
- [Arma 3: Sensors config reference](https://community.bistudio.com/wiki/Arma_3:_Sensors_config_reference)
- [Sensor Overhaul thread](https://forums.bistudio.com/topic/200467-jets-sensor-overhaul/)
- [Sensor Overhaul OPREP](https://dev.arma3.com/post/oprep-sensor-overhaul)

Retrieved from "[https://community.bistudio.com/wiki?title=Arma_3:_Sensors&oldid=373211](https://community.bistudio.com/wiki?title=Arma_3:_Sensors&oldid=373211)"

[Special:Categories](https://community.bistudio.com/wiki/Special:Categories)

:

- [Category:Arma 3](https://community.bistudio.com/wiki/Category:Arma_3)