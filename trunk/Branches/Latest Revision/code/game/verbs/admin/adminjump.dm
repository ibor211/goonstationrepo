/client/proc/Jump(var/area/A in world)
	set desc = "Area to jump to"
	set category = "Admin-Player"
	set src = usr

	if(src.authenticated && src.holder)
		if(config.allow_admin_jump)
			var/list/L = list()
			for(var/turf/T in A)
				if(!T.density)
					var/clear = 1
					for(var/obj/O in T)
						if(O.density)
							clear = 0
							break
					if(clear)
						L+=T

			usr << "\blue Jumping to [A]!"
			world.log_admin("[usr.key] jumped to [A]")
			messageadmins("[usr.key] jumped to [A]")

			usr.loc = pick(L)

			var/obj/effects/sparks/O = new /obj/effects/sparks( usr.loc )
			O.dir = pick(1, 2, 4, 8)
			spawn( 0 )
				O.Life()
		else
			alert("Admin jumping disabled")

/client/proc/Jumptomob(var/mob/M in world)
	set category = "Admin-Player"
	set name = "Jump to Mob"
	set desc = "Mob to jump to"
	set src = usr

	if(src.authenticated && src.holder)
		if(config.allow_admin_jump)

			usr << "\blue Jumping to [M]!"
			world.log_admin("[usr.key] jumped to [M]")
			messageadmins("[usr.key] jumped to [M]")

			usr.loc = M.loc

			var/obj/effects/sparks/O = new /obj/effects/sparks( usr.loc )
			O.dir = pick(1, 2, 4, 8)
			spawn( 0 )
				O.Life()
		else
			alert("Admin jumping disabled")

/client/proc/Getmob(var/mob/M in world)
	set category = "Admin-Player"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	set src = usr

	if(src.authenticated && src.holder)
		if(config.allow_admin_jump)

			usr << "\blue Teleporting [M]!"
			world.log_admin("[usr.key] teleported [M]")
			messageadmins("[usr.key] teleported [M]")

			M.loc = usr.loc

			var/obj/effects/sparks/O = new /obj/effects/sparks( usr.loc )
			O.dir = pick(1, 2, 4, 8)
			spawn( 0 )
				O.Life()
		else
			alert("Admin jumping disabled")

/client/proc/sendmob(var/mob/M in world, var/area/A in world)
	set category = "Admin-Player"
	set name = "Send Mob"
	set src = usr

	if(src.authenticated && src.holder)
		if(config.allow_admin_jump)
			var/list/L = list()
			for(var/turf/T in A)
				if(!T.density)
					var/clear = 1
					for(var/obj/O in T)
						if(O.density)
							clear = 0
							break
					if(clear)
						L+=T

			usr << "\blue Done."
			M.loc = pick(L)

			var/obj/effects/sparks/O = new /obj/effects/sparks( usr.loc )
			O.dir = pick(1, 2, 4, 8)
			spawn( 0 )
				O.Life()
		else
			alert("Admin jumping disabled")