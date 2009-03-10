/client/proc/Debug2()
	set category = "Debug"
	set name = "Debug-Game"
	if(src.holder.rank == "Coder")
		Debug2 = !Debug2

		world << "Debugging [Debug2 ? "On" : "Off"]"
	else
		alert("Coders only baby")
		return

/client/proc/callproc()
	set category = "Debug"
	set name = "Advanced ProcCall"
	var/target = null
	var/arguments = null
	var/returnval = null
	//var/class = null

	switch(alert("Proc owned by obj?",,"Yes","No"))
		if("Yes")
			target = input("Enter target:","Target",null) as obj|mob|area|turf in world
		if("No")
			target = null

	var/procname = input("Procpath","path:", null)

	if (target)
		arguments = input("Arguments","Arguments:", null)
		usr << "\blue Calling '[procname]' with arguments '[arguments]' on '[target]'"
		returnval = call(target,procname)(arguments)
	else
		arguments = input("Arguments","Arguments:", null)
		usr << "\blue Calling '[procname]' with arguments '[arguments]'"
		returnval = call(procname)(arguments)

	usr << "\blue Proc returned: [returnval]"
/*
	var/argnum = input("Number of arguments:","Number",null) as num


	var/i
	for(i=0, i<argnum, i++)

		class = input("Type of Argument #[i]","Variable Type", default) in list("text","num","type","reference","mob reference", "icon","file","cancel")
		switch(class)
			if("cancel")
				return

			if("text")
				var/"argu"+i = input("Enter new text:","Text",null) as text

			if("num")
				O.vars[variable] = input("Enter new number:","Num",\
					O.vars[variable]) as num

			if("type")
				O.vars[variable] = input("Enter type:","Type",O.vars[variable]) \
					in typesof(/obj,/mob,/area,/turf)

			if("reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob|obj|turf|area in world

			if("mob reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob in world

			if("file")
				O.vars[variable] = input("Pick file:","File",O.vars[variable]) \
					as file

			if("icon")
				O.vars[variable] = input("Pick icon:","Icon",O.vars[variable]) \
					as icon
		spawn(0)
			call(T,wproc)(warg)
*/

/client/proc/fire(turf/T as turf in world)
	set category = "Admin-Game"
	set name = "Create Fire"
	usr << "\blue Fire created."
	spawn(0)
		T.poison += 30000000
		T.firelevel = T.poison
	world << "[usr.key] created some fire!"

/client/proc/co2(turf/T as turf in world)
	set category = "Admin-Game"
	set name = "Create CO2"
	usr << "\blue CO2 created."
	spawn(0)
		T.co2 += 300000000
	world << "[usr.key] created some co2!"

/client/proc/n2o(turf/T as turf in world)
	set category = "Admin-Game"
	set name = "Create N2O"
	usr << "\blue N2O created."
	spawn(0)
		T.sl_gas += 30000000
	world << "[usr.key] created some n2o!"

/client/proc/explosion(T as obj|mob|turf in world)
	set category = "Admin-Game"
	set name = "Create Explosion"
	usr << "\blue Explosion created."
	var/obj/item/weapon/tank/plasmatank/pt = new /obj/item/weapon/tank/plasmatank( T )
	pt.gas.temperature = 475+T0C
	pt.ignite()
	world << "[usr.key] created an explosion!"

/client/proc/droptarget(mob/M as mob in world)
	set category = "Admin-Player"
	set name = "Drop everything"
	usr << "\blue Target dropped items."
	for(var/obj/item/weapon/W in M)
		if (!istype(W,/obj/item/weapon/organ))
			M.u_equip(W)
			if (M.client)
				M.client.screen -= W
			if (W)
				W.loc = M.loc
				W.dropped(M)
				W.layer = initial(W.layer)
	world << "[usr.key] made [M.key] drop everything!"

/client/proc/tdome1(mob/M as mob in world)
	set category = "Admin-Player"
	set name = "Thunderdome (Team1)"
	for(var/obj/item/weapon/W in M)
		if (!istype(W,/obj/item/weapon/organ))
			M.u_equip(W)
			if (M.client)
				M.client.screen -= W
			if (W)
				W.loc = M.loc
				W.dropped(M)
				W.layer = initial(W.layer)
			del(W)
	var/mob/human/H = M
	for(var/A in H.organs)
		var/obj/item/weapon/organ/external/affecting = null
		if(!H.organs[A])    continue
		affecting = H.organs[A]
		if(!istype(affecting, /obj/item/weapon/organ/external))    continue
		affecting.heal_damage(1000, 1000)
	M.fireloss = 0
	M.toxloss = 0
	M.bruteloss = 0
	M.oxyloss = 0
	M.paralysis = 0
	M.stunned = 0
	M.weakened = 0
	M.health = 100
	M.radiation = 0
	M.updatehealth()
	M.buckled = null
	H.UpdateDamageIcon()
	if (M.stat) M.stat = 0
	M.loc = pick(tdome1)
	usr << "\blue Done."
	M << "\blue You have been sent to the Thunderdome."

/client/proc/tdome2(mob/M as mob in world)
	set category = "Admin-Player"
	set name = "Thunderdome (Team2)"
	for(var/obj/item/weapon/W in M)
		if (!istype(W,/obj/item/weapon/organ))
			M.u_equip(W)
			if (M.client)
				M.client.screen -= W
			if (W)
				W.loc = M.loc
				W.dropped(M)
				W.layer = initial(W.layer)
			del(W)
	var/mob/human/H = M
	for(var/A in H.organs)
		var/obj/item/weapon/organ/external/affecting = null
		if(!H.organs[A])    continue
		affecting = H.organs[A]
		if(!istype(affecting, /obj/item/weapon/organ/external))    continue
		affecting.heal_damage(1000, 1000)
	M.fireloss = 0
	M.toxloss = 0
	M.bruteloss = 0
	M.oxyloss = 0
	M.paralysis = 0
	M.stunned = 0
	M.weakened = 0
	M.health = 100
	M.radiation = 0
	M.updatehealth()
	M.buckled = null
	H.UpdateDamageIcon()
	if (M.stat) M.stat = 0
	M.loc = pick(tdome2)
	usr << "\blue Done."
	M << "\blue You have been sent to the Thunderdome."


/client/proc/nodamage(mob/M as mob in world)
	set category = "Admin-Player"
	set name = "Toggle No damage"
	if (M.nodamage == 1)
		M.nodamage = 0
		usr << "\blue Toggled OFF"
	else
		M.nodamage = 1
		usr << "\blue Toggled ON"
	world << "[usr.key] has toggled [M.key]'s nodamage to [M.nodamage]"

/client/proc/mute(mob/M as mob in world)
	set category = "Admin-Player"
	set name = "(Un)Mute"
	if (M.muted)
		M.muted = 0
		usr << "\blue Toggled OFF"
	else
		M.muted = 1
		usr << "\blue Toggled ON"

/client/proc/revent(number as num)
	set category = "Admin-Game"
	set name = "Change event %"
	if(src.authenticated && src.holder)
		eventchance = number
		usr << "\blue Set to [eventchance]%"
		world.log_admin("[src.key] set the random event chance to [eventchance]%")

/client/proc/funbutton()
	set category = "Admin-Game"
	set name = "Random Expl.(REMOVE ME)"
	for(var/turf/T in world)
		if(prob(4) && T.z == 1 && istype(T,/turf/station/floor))
			spawn(50+rand(0,3000))
				var/obj/item/weapon/tank/plasmatank/pt = new /obj/item/weapon/tank/plasmatank( T )
				pt.gas.temperature = 400+T0C
				pt.ignite()
				for(var/turf/P in view(3, T))
					if (P.poison)
						P.poison = 0
						P.oldpoison = 0
						P.tmppoison = 0
						P.oxygen = 755985
						P.oldoxy = 755985
						P.tmpoxy = 755985
	usr << "\blue Blowing up station ..."
	world << "[usr.key] is being a complete cock, blame them for anything that is about to happen"

/client/proc/removeplasma()
	set category = "Admin-Game"
	set name = "Stabilize Atmos."
	usr << "\blue Done."
	spawn(0)
		for(var/turf/T in view())
			T.poison = 0
			T.oldpoison = 0
			T.tmppoison = 0
			T.oxygen = 755985
			T.oldoxy = 755985
			T.tmpoxy = 755985
			T.co2 = 14.8176
			T.oldco2 = 14.8176
			T.tmpco2 = 14.8176
			T.n2 = 2.844e+006
			T.on2 = 2.844e+006
			T.tn2 = 2.844e+006
			T.tsl_gas = 0
			T.osl_gas = 0
			T.sl_gas = 0
			T.temp = 293.15
	world << "[usr.key] has stabilized the atmosphere"

/client/proc/addfreeform()
	set category = "Admin-Player"
	set name = "Add AI law"
	var/input = input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "")
	for(var/mob/ai/M in world)
		if (M.stat == 2)
			usr << "Upload failed. No signal is being detected from the AI."
		else if (M.see_in_dark == 0)
			usr << "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power."
		else
			M.addLaw(10,input)
			M << "\blue New law uploaded by Centcom: " + input
	world << "Admin [usr.key] has added a new AI law"

/client/proc/revivenear(mob/M as mob)
	set category = "Admin-Player"
	set name = "Revive/Heal Visible"
    //    All admins should be authenticated, but... what if?
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return

	if(!src.mob)
		return
	if(config.allow_admin_rev)
		if(istype(M, /mob/human))
			var/mob/human/H = M
			for(var/A in H.organs)
				var/obj/item/weapon/organ/external/affecting = null
				if(!H.organs[A])    continue
				affecting = H.organs[A]
				if(!istype(affecting, /obj/item/weapon/organ/external))    continue
				affecting.heal_damage(1000, 1000)    //fixes getting hit after ingestion, killing you when game updates organ health
			H.UpdateDamageIcon()
		M.fireloss = 0
		M.toxloss = 0
		M.bruteloss = 0
		M.oxyloss = 0
		M.paralysis = 0
		M.stunned = 0
		M.weakened = 0
		M.radiation = 0
		M.health = 100
		M.updatehealth()
		if(M.stat > 1) M.stat=0
		..()
		usr << "\blue Healing/Reviving [M]!"
		messageadmins("\red Admin [usr.key] Healed/Revived [M.key]!")
		world.log_admin("[usr.key] Healed/Revived [M.key]")
		return
	else
		alert("Admin revive disabled")

/client/proc/delete(obj/O as obj|mob|turf)
	del(O)