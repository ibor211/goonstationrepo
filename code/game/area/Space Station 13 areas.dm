/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

*/

/area/prison/arrival_airlock
	name = "Prison Station Airlock"
	icon_state = "green"
	requires_power = 0

/area/prison/control
	name = "Prison Security Checkpoint"
	icon_state = "security"

/area/prison/crew_quarters
	name = "Prison Security Quarters"
	icon_state = "security"

/area/prison/closet
	name = "Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/hallway/north
	name = "Prison North Hallway"
	icon_state = "yellow"

/area/prison/hallway/south
	name = "Prison South Hallway"
	icon_state = "yellow"

/area/prison/hallway/west
	name = "Prison West Hallway"
	icon_state = "yellow"

/area/prison/morgue
	name = "Prison Morgue"
	icon_state = "morgue"

/area/prison/medical_research
	name = "Prison Genetic Research"
	icon_state = "medresearch"

/area/prison/medical
	name = "Prison Medbay"
	icon_state = "medbay"

/area/prison/solar
	name = "Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/podbay
	name = "Prison Podbay"
	icon_state = "dk_yellow"

/area/prison/solar_control
	name = "Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/cell_block/A
	name = "Prison Cell Block A"
	icon_state = "brig"

/area/prison/cell_block/B
	name = "Prison Cell Block B"
	icon_state = "brig"

/area/prison/cell_block/C
	name = "Prison Cell Block C"
	icon_state = "brig"

//

/area/centcom
	name = "Centcom"
	icon_state = "purple"
	requires_power = 0

/area/maintenance/north
	name = "North Maintenance"
	icon_state = "green"

/area/maintenance/northeast
	name = "NorthEast Maintenance"
	icon_state = "green"

/area/maintenance/west
	name = "West Maintenance"
	icon_state = "green"

/area/maintenance/south
	name = "South Maintenance"
	icon_state = "green"

/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"

/area/hallway/primary/north
	name = "North Primary Hallway"
	icon_state = "dk_yellow"

/area/hallway/primary/east
	name = "East Primary Hallway"
	icon_state = "dk_yellow"

/area/hallway/primary/south
	name = "South Primary Hallway"
	icon_state = "dk_yellow"

/area/hallway/primary/west
	name = "West Primary Hallway"
	icon_state = "dk_yellow"

/area/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "yellow"

/area/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "yellow"

/area/bridge
	name = "Bridge"
	icon_state = "bridge"

/area/crew_quarters/male
	name = "Male Quarters"
	icon_state = "crew_quarters"

/area/crew_quarters/female
	name = "Female Quarters"
	icon_state = "crew_quarters"

/area/crew_quarters/captain
	name = "Captain's Quarters"
	icon_state = "crew_quarters"

/area/crew_quarters/bar
	name= "Bar"
	icon_state = "crew_quarters"

/area/crew_quarters/heads
	name = "Head of Staff's Quarters"
	icon_state = "crew_quarters"

/area/crew_quarters/courtroom
	name = "Courtroom"
	icon_state = "crew_quarters"

/area/crew_quarters/AIsattele
	name = "AI Satellite Teleporter Room"
	icon_state = "crew_quarters"


/area/engine/engine_smes
	name = "Engine SMES Room"
	icon_state = "engine"

/area/engine/engine_walls
	name = "Engine Walls"
	icon_state = "engine"
	requires_power = 0

/area/engine/engine_gas_storage
	name = "Engine Storage"
	icon_state = "engine_gas_storage"

/area/engine/engine_hallway
	name = "Engine Hallway"
	icon_state = "engine_hallway"

/area/engine/engine_mon
	name = "Engine Monitoring"
	icon_state = "engine_monitoring"

/area/engine/combustion
	name = "Engine Combustion Chamber"
	icon_state = "combustion"

/area/engine/engine_control
	name = "Engine Control"
	icon_state = "engine_control"

/area/engine/launcher
	name = "Engine Launcher Room"
	icon_state = "engine_monitoring"

/area/gentlemansclub
	name = "Gentlemans Club"
	icon_state = "crew_quarters"
/area/prototype/prototype_engine
	name = "Prototype Engine"
	icon_state = "prototype_engine"

/area/teleporter
	name = "Teleporter"
	icon_state = "teleporter"

/area/tdome
	name = "Thunderdome"
	icon_state = "medbay"

/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomea
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/medical/medbay
	name = "Medbay"
	icon_state = "medbay"

/area/medical/research
	name = "Medical Research"
	icon_state = "medresearch"

/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"

/area/security/main
	name = "Security"
	icon_state = "security"

/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "security"

/area/security/checkpoint2
	name = "Security Checkpoint"
	icon_state = "security"

/area/security/forensics
	name = "Forensics"
	icon_state = "security"

/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/solar/north
	name = "North Solar Array"
	icon_state = "yellow"

/area/solar/south
	name = "South Solar Array"
	icon_state = "south"


/area/syndicate_station
	name = "Syndicate Station"
	icon_state = "yellow"
	requires_power = 0

/area/toxins/lab
	name = "Toxin Lab"
	icon_state = "toxlab"

/area/toxins/storage
	name = "Toxin Storage"
	icon_state = "toxlab"

/area/toxins/test_chamber
	name = "Toxin Test Chamber"
	icon_state = "toxlab"

/area/chapel/main
	name = "Chapel"
	icon_state = "chapel"

/area/chapel/office
	name = "Chapel Office"
	icon_state = "chapel"

/area/storage/tools
	name = "Tool Storage"
	icon_state = "storage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "storage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "storage"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "storage"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Foyer"
	icon_state = "ai_upload"

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai"
/area/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/AIsolar
	name = "AI Sat Solar"
	icon_state = "south"

/area/turret_protected/AIsatext
	name = "AI Sat Ext"
	icon_state = "storage"