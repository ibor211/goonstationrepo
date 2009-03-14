/turf
	icon = 'turfs.dmi'
	var/intact = 0
	var/firelevel = null
	var/oxygen = O2STANDARD
	var/oldoxy = null
	var/tmpoxy = null
	var/oldpoison = null
	var/tmppoison = null
	var/poison = 0.0
	var/co2 = 0.0
	var/oldco2 = null
	var/tmpco2 = null
	var/sl_gas = 0.0
	var/osl_gas = null
	var/tsl_gas = null
	var/n2 = N2STANDARD
	var/on2 = null
	var/tn2 = null
	var/temp = T20C
	var/otemp
	var/ttemp

	var/airdir = null
	var/airforce = null
	var/checkfire = 1.0
	var/atmoalt = null
	var/updatecell = null
	level = 1.0


	// the turfs to the N,S,E & W
	var/turf/linkN
	var/turf/linkS
	var/turf/linkE
	var/turf/linkW

	// whether those turfs are air-connected
	var/airN
	var/airS
	var/airE
	var/airW

	var/lit = "nothing"

	// whether to use special conduction heat transfer (through windows only)

	var/condN
	var/condS
	var/condE
	var/condW

/turf/space
	name = "space"
	icon_state = "space"
	var/previousArea = null
	updatecell = 1.0
	oxygen = 0.0
	n2 = 0.0
	checkfire = 0
	oldoxy = 0.0
	oldpoison = 0.0
	// CMB radiation temperature+
	temp = 2.7

/turf/station
	name = "station"
	intact = 1
	var/icon_old = null
	var/wet = 0

/turf/station/command
	name = "command"

/turf/station/command/floor
	name = "floor"
	icon = 'Icons.dmi'
	icon_state = "Floor3"
	updatecell = 1

/turf/station/command/floor/other
	icon_state = "Floor"

/turf/station/command/wall
	name = "wall"
	icon = 'wall.dmi'
	icon_state = "CCWall"
	opacity = 1
	density = 1
	updatecell = 0.0

/turf/station/command/wall/other
	icon_state = "r_wall"

/turf/station/engine
	name = "engine"
	icon = 'engine.dmi'

/turf/station/engine/floor
	name = "floor"
	icon_state = "floor"
	updatecell = 1

/turf/station/floor
	name = "floor"
	icon = 'Icons.dmi'
	icon_state = "Floor"
	var/health = 150.0
	var/burnt = null
	updatecell = 1

/turf/station/floor/grid
	icon = 'weap_sat.dmi'
	icon_state = "Floor"

/turf/station/floor/plasma_test

/turf/station/r_wall
	name = "r wall"
	icon = 'wall.dmi'
	icon_state = "r_wall"
	var/previousArea = null
	opacity = 1
	density = 1
	var/state = 2
	var/d_state = 0
	updatecell = 0

/turf/station/shuttle
	name = "shuttle"
	icon = 'shuttle.dmi'

/turf/station/shuttle/floor
	name = "floor"
	icon_state = "floor"
	updatecell = 1

/turf/station/shuttle/floor/rpg
	name = "ground"
	icon = 'rpg.dmi'
	icon_state = "carpet"
	updatecell = 1

/turf/station/shuttle/wall
	name = "wall"
	icon_state = "wall"
	opacity = 1
	density = 1
	updatecell = 0

/turf/station/shuttle/wall/rpg
	name = "wall"
	icon = 'rpg.dmi'
	icon_state = "409"
	opacity = 0
	density = 1
	updatecell = 0

/turf/station/wall
	name = "wall"
	icon = 'wall.dmi'
	var/previousArea = null
	opacity = 1
	density = 1
	var/state = 2
	updatecell = 0

/turf/DblClick()
	if(istype(usr, /mob/ai))
		return move_camera_by_click()
	if(usr.stat || usr.restrained() || usr.lying)
		return ..()
	if(usr.hand && istype(usr.l_hand, /obj/item/weapon/flamethrower))
		var/turflist = getline(usr,src)
		var/obj/item/weapon/flamethrower/F = usr.l_hand
		F.flame_turf(turflist)
		..()
	else if(!usr.hand && istype(usr.r_hand, /obj/item/weapon/flamethrower))
		var/turflist = getline(usr,src)
		var/obj/item/weapon/flamethrower/F = usr.r_hand
		F.flame_turf(turflist)
		..()
	else return ..()