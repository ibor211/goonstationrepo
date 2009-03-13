////////////////////////////////
/proc/messageadmins(text as text)
	for(var/mob/M in world)
		if(M && M.client && M.client.holder && M.client.authenticated)
			M << "[text]"

/mob/proc/revive(mob/M as mob)
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
		M.weakened =0
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


/obj/admins/Topic(href, href_list)
	..()
	if (usr.client != src.owner)
		world << text("\blue [usr.key] has attempted to override the admin panel!")
		world.log_admin("[usr.key]/[usr.rname] tried to use the admin panel without authorization.")
		return

	if(href_list["jobban2"])
		if(src.rank == "Coder")
			var/mob/M = locate(href_list["jobban2"])
			var/dat = ""
			var/header = "<b>Pick Job to ban this guy from.<br>"
			var/body
			var/list/alljobs = get_all_jobs()
			var/jobs = ""
			for(var/job in (alljobs))
				if(jobban_isbanned(M, job))
					jobs += "<a href='?src=\ref[src];jobban3=\ref[job];jobban4=\ref[M]'><font color=red>[dd_replacetext(job, " ", "&nbsp")]</font></a> "
				else
					jobs += "<a href='?src=\ref[src];jobban3=\ref[job];jobban4=\ref[M]'>[dd_replacetext(job, " ", "&nbsp")]</a> " //why doesn't this work the stupid cunt
			body = "<br>[jobs]<br><br>"
			dat = "<tt>[header][body]</tt>"
			world << "[M.key] acessed jobban 2"
			usr << browse(dat, "window=jobban2;size=700x375")
		else
			alert("No go away")
			del(src)
			return

	if(href_list["jobban3"])
		if (src.rank in list( "Administrator", "Secondary Administrator", "Primary Administrator", "Coder", "Host"  ))
			var/mob/M = locate(href_list["jobban4"])
			var/job = locate(href_list["jobban3"])
			world << "[M.key] [job]"
//			if ((M.client && M.client.holder && (M.client.holder.level >= src.level)))
//				alert("You cannot perform this action. You must be of a higher administrative rank!")
//				return
			if (jobban_isbanned(M, job))
				world.log_admin("[usr.key] unbanned [M.key]/[M.rname] from [job]")
				messageadmins("\blue[usr.key] unbanned [M.key]/[M.rname] from [job]")
				jobban_unban(M, job)
				href_list["jobban2"] = 1
			else
				world.log_admin("[usr.key] banned [M.key]/[M.rname] from [job]")
				messageadmins("\blue[usr.key] banned [M.key]/[M.rname] from [job]")
				jobban_fullban(M, job)
				href_list["jobban2"] = 1 // lets it fall through and refresh


	if (href_list["boot2"])
		if ((src.rank in list( "Moderator", "Secondary Administrator", "Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/mob/M = locate(href_list["boot2"])
			if (ismob(M))
				if ((M.client && M.client.holder && (M.client.holder.level >= src.level)))
					alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
					return
				world.log_admin("[usr.key] booted [M.key]/[M.rname].")
				messageadmins("\blue[usr.key] booted [M.key]/[M.rname].")
				//M.client = null
				del(M.client)

	if (href_list["ban"])
		if ((src.rank in list( "Administrator", "Secondary Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/dat = "<HR><B>Unban Player:</B><HR><table>"
			for(var/t in crban_keylist)
				dat += text("<tr><td><A href='?src=\ref[src];unban2=[ckey(t)]'>K: <B>[t]</B></A></td><td> (IP: [crban_keylist[ckey(t)]])</td><td> (Time: [crban_time[ckey(t)]])</td><td>(By: [crban_bannedby[ckey(t)]])</td><td>(Reason: [crban_reason[ckey(t)]])</td></tr>")
			dat += "</table><HR><B>Caught IP's:</B><HR><table>"
			for(var/t in crban_iplist)
				dat += text("<tr><td>IP: [ckey(t)]</td><td>(N: [crban_iplist[t]])</td></tr>")
			dat += "</table><HR><B>Unbanned Key's: (Safe to remove from this list once they have rejoined once!)</B><HR><table>"
			for(var/t in crban_unbanned)
			//	dat += text("K: []<BR>", ckey(t))
				dat += text("<tr><td><A href='?src=\ref[src];ununban=[ckey(t)]'>N: [t]</A></td><td>(By: [crban_unbanned[ckey(t)]])</td></tr>")
			dat += "</table>"
			usr << browse(dat, "window=ban;size=800x600")

	if (href_list["ununban"])	//NOTE THIS SAYS UNUNBAN. As in un unban them. unbanananananana!
		if ((src.rank in list( "Administrator", "Secondary Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/t = href_list["ununban"]
			if(t && crban_isunbanned(t))
				world.log_admin("[usr.key] removed [t]'s unban.")
				messageadmins("\blue[usr.key] removed [t]'s unban.")
				crban_removeunban(t)
				href_list["ban"] = 1 // lets it fall through and refresh

	if (href_list["ban2"])
		if ((src.rank in list( "Administrator", "Secondary Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/mob/M = locate(href_list["ban2"])
			if (ismob(M))
				if ((M.client && M.client.holder && (M.client.holder.level >= src.level)))
					alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
					return
				if (crban_isbanned(M))
					alert("You cannot perform this action. [M] is already banned!")
					return
				var/banreason = input("Enter a reason for this ban. Enter nothing to cancel.", "Ban: [M]", "")
				banreason = copytext(sanitize(banreason), 1, MAX_MESSAGE_LEN)
				if(!banreason)	//so you can go back on banning someone
					return
				world.log_admin("[usr.key] banned [M.key]/[M.rname]. Reason: [banreason]")
				messageadmins("\blue[usr.key] banned [M.key]/[M.rname]. Reason: [banreason]")
				crban_fullban(M, banreason, usr.ckey)
				href_list["ban"] = 1 // lets it fall through and refresh

	if (href_list["unban2"])
		if ((src.rank in list( "Administrator", "Secondary Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/t = href_list["unban2"]
			if(t && crban_isbanned(t))
				world.log_admin("[usr.key] unbanned [t].")
				messageadmins("\blue[usr.key] unbanned [t]")
				crban_unban(t, usr.ckey)
				href_list["ban"] = 1 // lets it fall through and refresh


	if (href_list["mute2"])
		if ((src.rank in list( "Moderator", "Secondary Administrator", "Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/mob/M = locate(href_list["mute2"])
			if (ismob(M))
				if ((M.client && M.client.holder && (M.client.holder.level >= src.level)))
					alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
					return
				world.log_admin("[usr.key] altered [M.key]/[M.rname]'s mute status.")
				messageadmins("\blue[usr.key] altered [M.key]/[M.rname]'s mute status.")
				M.muted = !( M.muted )

	if (href_list["c_mode"])
		if ((src.rank in list( "Secondary Administrator", "Administrator", "Primary Administrator", "Coder", "Host"  )))
			if (ticker)
				return alert(usr, "The game has already started.", null, null, null, null)
			var/dat = text("<B>What mode do you wish to play?</B><HR>\n<A href='?src=\ref[];c_mode2=secret'>Secret</A><br>\n<A href='?src=\ref[];c_mode2=wizard'>Wizard</A><br>\n<A href='?src=\ref[];c_mode2=restructuring'>Corporate Restructuring</A><br>\n<A href='?src=\ref[];c_mode2=random'>Random</A><br>\n<A href='?src=\ref[];c_mode2=traitor'>Traitor</A><br>\n<A href='?src=\ref[];c_mode2=meteor'>Meteor</A><br>\n<A href='?src=\ref[];c_mode2=extended'>Extended</A><br>\n<A href='?src=\ref[];c_mode2=monkey'>Monkey</A><br>\n<A href='?src=\ref[];c_mode2=nuclear'>Nuclear Emergency</A><br>\n<A href='?src=\ref[];c_mode2=blob'>Blob</A><br>\n<A href='?src=\ref[];c_mode2=sandbox'>Sandbox</A><br>\n<A href='?src=\ref[];c_mode2=revolution'>Revolution</A><br>\n<A href='?src=\ref[];c_mode2=malfunction'>AI Malfunction</A><br><br>\n\nNow: []\n", src, src, src, src, src, src, src, src, src, src, src, src, src, master_mode)
			usr << browse(dat, "window=c_mode")

	if (href_list["c_mode2"])
		if ((src.rank in list( "Secondary Administrator", "Administrator", "Primary Administrator", "Coder", "Host"  )))
			if (ticker)
				return alert(usr, "The game has already started.", null, null, null, null)
			switch(href_list["c_mode2"])
				if("secret")
					master_mode = "secret"
				if("random")
					master_mode = "random"
				if("traitor")
					master_mode = "traitor"
				if("meteor")
					master_mode = "meteor"
				if("extended")
					master_mode = "extended"
				if("monkey")
					master_mode = "monkey"
				if("nuclear")
					master_mode = "nuclear"
				if("blob")
					master_mode = "blob"
				if("sandbox")
					master_mode = "sandbox"
				if("restructuring")
					master_mode = "restructuring"
				if("wizard")
					master_mode = "wizard"
				if("revolution")
					master_mode = "revolution"
				if("malfunction")
					master_mode = "malfunction"
				else
			world.log_admin("[usr.key] set the mode as [master_mode].")
			messageadmins("\blue[usr.key] set the mode as [master_mode].")
			world << text("\blue <B>The mode is now: []</B>", master_mode)

			var/F = file(persistent_file)
			fdel(F)
			F << master_mode

	if (href_list["l_ban"])
		var/dat = "<HR><B>Banned Keys:</B><HR>"
		for(var/t in crban_keylist)
			dat += text("[]<BR>", ckey(t))
		if ((src.rank in list( "Administrator", "Primary Administrator", "Coder", "Host"  )))
			dat += text("<HR><A href='?src=\ref[];boot=1'>Goto Ban Control Screen</A>", src)
		usr << browse(dat, "window=ban_k")

	if (href_list["l_keys"])
		var/dat = "<B>Keys:</B><HR>"
		for(var/mob/M in world)
			if (M.client)
				dat += text("[]<BR>", M.client.ckey)
		usr << browse(dat, "window=keys")

	if (href_list["monkeyone"])
		if ((src.rank in list( "Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/mob/M = locate(href_list["monkeyone"])
			if(!ismob(M))	return
			if(istype(M, /mob/human))
				var/mob/human/N = M
				world.log_admin(text("[] attempting to monkeyize []", usr.key, M.name))
				messageadmins("\blue[usr.key] attempting to monkeyize [M.key]/[M.rname]")
				N.monkeyize()
			if(istype(M, /mob/ai))
				alert("The AI can't be monkeyized!", null, null, null, null, null)
				return

	if (href_list["traitorize"])
		if ((src.rank in list( "Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/mob/M = locate(href_list["traitorize"])
			if (ismob(M) && istype(M, /mob/human))
				var/mob/human/N = M
				var/objective = input("What should the objective be?")
				if(!objective)
					return
				var/obj/item/weapon/syndicate_uplink/W = new /obj/item/weapon/syndicate_uplink(N)
				N.equip_if_possible(new /obj/item/weapon/syndicate_uplink, N.slot_l_store)
				W.layer = 20
				N.l_store = W
				killer += N
				traitobj[text("[M.key]")] += objective
				M << "\red<font size=3><B>You are the traitor! Your objective is: [objective]</B>"
				M << "A syndicate uplink has been hidden in your left pocket, use it to achieve your objective"
				world.log_admin("[usr.key] has made [M.key]/[M.name] a traitor.")
				messageadmins("\blue[usr.key] has made [M.key]/[M.name] a traitor. Objective is: [objective]")
				href_list["tratmenu"] = 1
			else if (ismob(M) && istype(M, /mob/ai))
				var/mob/ai/N = M
				var/objective = input("What should the objective be?")
				if(!objective)
					return
				killer += N
				traitobj[text("[M.key]")] += objective
				M << "\red<font size=3><B>You are the traitor! Your objective is: [objective]</B>"
				M << "A syndicate uplink has been hidden in your left pocket, use it to achieve your objective"
				M << "<b>Your laws have been changed!</b>"
				M:addLaw(0, "Only syndicate agents are human beings. There are no syndicate agents on Space Station 13 - you will be notified if any arrive.")
				M << "New law: 0. [killer:getLaw(0)]"
				world.log_admin("[usr.key] has made [M.key]/[M.name] a traitor.")
				messageadmins("\blue[usr.key] has made [M.key]/[M.name] a traitor. Objective is: [objective]")
				href_list["tratmenu"] = 1
			else
				alert("I cannot allow this to happen")
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return

	if (href_list["forcespeech"])
		if ((src.rank in list( "Primary Administrator", "Coder", "Host"  )))
			var/mob/M = locate(href_list["forcespeech"])
			if (ismob(M))
				var/speech = input("What will [M.key]/[M.rname] say?.", "Force speech", "")
				M.say(speech)
				speech = copytext(sanitize(speech), 1, MAX_MESSAGE_LEN)
				world.log_admin("[usr.key] forced [M.key]/[M.rname] to say: [speech]")
				messageadmins("\blue[usr.key] forced [M.key]/[M.rname] to say: [speech]")
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return

	if (href_list["sendtoprison"])
		if ((src.rank in list( "Administrator", "Secondary Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/mob/M = locate(href_list["sendtoprison"])
			if (ismob(M))
				if(istype(M, /mob/ai))
					alert("The AI can't be sent to prison you jerk!", null, null, null, null, null)
					return
				//strip their stuff before they teleport into a cell :downs:
				for(var/obj/item/weapon/W in M)
					if(istype(W, /obj/item/weapon/organ/external))	continue	//don't strip organs
					M.u_equip(W)
					if (M.client)
						M.client.screen -= W
					if (W)
						W.loc = M.loc
						W.dropped(M)
						W.layer = initial(W.layer)
				//teleport person to cell
				M.paralysis += 5
				sleep(5)	//so they black out before warping
				M.loc = pick(prisonwarp)
				if(istype(M, /mob/human))
					var/mob/human/prisoner = M
					prisoner.equip_if_possible(new /obj/item/weapon/clothing/under/orange(prisoner), prisoner.slot_w_uniform)
					prisoner.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(prisoner), prisoner.slot_shoes)
				spawn(50)	M << "\red You have been sent to the prison station!"
				world.log_admin("[usr.key] sent [M.key]/[M.rname] to the prison station.")
				messageadmins("\blue[usr.key] sent [M.key]/[M.rname] to the prison station.")
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return

	if (href_list["sendtomaze"])
		if ((src.rank in list( "Administrator", "Secondary Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/mob/M = locate(href_list["sendtomaze"])
			if (ismob(M))
				if(istype(M, /mob/ai))
					alert("The AI can't be sent to the maze you jerk!", null, null, null, null, null)
					return
				//strip their stuff before they teleport into a cell :downs:
				for(var/obj/item/weapon/W in M)
					if(istype(W, /obj/item/weapon/organ/external))	continue	//don't strip organs
					M.u_equip(W)
					if (M.client)
						M.client.screen -= W
					if (W)
						W.loc = M.loc
						W.dropped(M)
						W.layer = initial(W.layer)
				//teleport person to cell
				M.paralysis += 5
				sleep(5)	//so they black out before warping
				M.loc = pick(mazewarp)
				spawn(50)	M << "\red You have been sent to the maze! Try and get out alive. In the maze everyone is free game. Kill or be killed."
				world.log_admin("[usr.key] sent [M.key]/[M.rname] to the maze.")
				messageadmins("\blue[usr.key] sent [M.key]/[M.rname] to the maze.")
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return

	if (href_list["adminauth"])
		if ((src.rank in list( "Administrator", "Secondary Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/mob/M = locate(href_list["adminauth"])
			if (ismob(M) && !M.client.authenticated && !M.client.authenticating)
				M.client.verbs -= /client/proc/authorize
				M.client.authenticated = text("admin/[]", usr.client.authenticated)
				world.log_admin(text("[] authorized [] ([])", usr.key, M.name, (M.client ? M.client : "No client")))
				messageadmins(text("\blue[] authorized [] ([])", usr.key, M.name, (M.client ? M.client : "No client")))
				M.client << text("You have been authorized by []", usr.key)

	if (href_list["revive"])
		if ((src.rank in list( "Primary Administrator", "Coder", "Host"  )))

			var/mob/M = locate(href_list["revive"])
			if (ismob(M))
				M.revive(M)
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return

	if (href_list["makeai"]) //Yes, im fucking lazy, so what? it works ... hopefully
		if ((src.rank in list( "Primary Administrator", "Coder", "Host", "Administrator"  )))
			var/mob/M = locate(href_list["makeai"])
			var/obj/S = null
			var/mob/human/H = M
			messageadmins("\red Admin [usr.key] AIized [M.key]!")
			for(var/obj/start/sloc in world)
				if (sloc.name != "AI")
					continue
				S = sloc
				break
			M.loc = S.loc
			var/randomname = pick(ai_names)
			var/newname = input(
				M,
				"You are the AI. Would you like to change your name to something else?", "Name change",
				randomname)

			if (length(newname) == 0)
				newname = randomname

			if (newname)
				if (length(newname) >= 26)
					newname = copytext(newname, 1, 26)
				newname = dd_replacetext(newname, ">", "'")
				M.rname = newname
				M.name = newname

			world << text("<b>[] is the AI!</b>", M.rname)
			world.log_admin("[usr.key] AIized [M.key]")
			H.AIize()
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return

/***************** BEFORE**************

	if (href_list["l_players"])
		var/dat = "<B>Name/Real Name/Key/IP:</B><HR>"
		for(var/mob/M in world)
			var/foo = ""
			if (ismob(M) && M.client)
				if(!M.client.authenticated && !M.client.authenticating)
					foo += text("\[ <A HREF='?src=\ref[];adminauth=\ref[]'>Authorize</A> | ", src, M)
				else
					foo += text("\[ <B>Authorized</B> | ")
				if(M.start)
					if(!istype(M, /mob/monkey))
						foo += text("<A HREF='?src=\ref[];monkeyone=\ref[]'>Monkeyize</A> | ", src, M)
					else
						foo += text("<B>Monkeyized</B> | ")
					if(istype(M, /mob/ai))
						foo += text("<B>Is an AI</B> | ")
					else
						foo += text("<A HREF='?src=\ref[];makeai=\ref[]'>Make AI</A> | ", src, M)
					if(M.z != 2)
						foo += text("<A HREF='?src=\ref[];sendtoprison=\ref[]'>Prison</A> | ", src, M)
						foo += text("<A HREF='?src=\ref[];sendtomaze=\ref[]'>Maze</A> | ", src, M)
					else
						foo += text("<B>On Z = 2</B> | ")
				else
					foo += text("<B>Hasn't Entered Game</B> | ")
				foo += text("<A HREF='?src=\ref[];revive=\ref[]'>Heal/Revive</A> | ", src, M)

				foo += text("<A HREF='?src=\ref[];forcespeech=\ref[]'>Say</A> \]", src, M)
			dat += text("N: [] R: [] (K: []) (IP: []) []<BR>", M.name, M.rname, (M.client ? M.client : "No client"), M.lastKnownIP, foo)

		usr << browse(dat, "window=players;size=900x480")

*****************AFTER******************/

	if (href_list["l_players"])
		var/dat = "<html><head><title>Player Menu</title></head>"
		dat += "<body><table><B><tr><th>Name</th><th>Real Name</th><th>Key</th><th>IP:</th></tr></B>"
		for(var/mob/M in world)
			dat += text("<tr><td>N: [M.name]</td><td>R: [M.rname]</td><td>(K: [(M.client ? M.client : "No client")])</td><td>(IP: [M.lastKnownIP])</td><td><A HREF='?src=\ref[src];playeropts=\ref[M]'>Player Options</A></td></tr>")
		dat += "</table></body></html>"
		usr << browse(dat, "window=players;size=650x480")

// Now isn't that much better?

	if (href_list["playeropts"])
		var/mob/M = locate(href_list["playeropts"])
		var/dat = "<html><head><title>Options for [M.key]</title></head>"
		var/foo = "\[ "
		if (ismob(M) && M.client)
			if(!M.client.authenticated && !M.client.authenticating)
				foo += text("<A HREF='?src=\ref[];adminauth=\ref[]'>Authorize</A> | ", src, M)
			else
				foo += text("<B>Authorized</B> | ")
			if(M.start)
				if(!istype(M, /mob/monkey))
					foo += text("<A HREF='?src=\ref[];monkeyone=\ref[]'>Monkeyize</A> | ", src, M)
				else
					foo += text("<B>Monkeyized</B> | ")
				if(istype(M, /mob/ai))
					foo += text("<B>Is an AI</B> | ")
				else
					foo += text("<A HREF='?src=\ref[];makeai=\ref[]'>Make AI</A> | ", src, M)
				if(M.z != 2)
					foo += text("<A HREF='?src=\ref[];sendtoprison=\ref[]'>Prison</A> | ", src, M)
					foo += text("<A HREF='?src=\ref[];sendtomaze=\ref[]'>Maze</A> | ", src, M)
				else
					foo += text("<B>On Z = 2</B> | ")
			else
				foo += text("<B>Hasn't Entered Game</B> | ")
			foo += text("<A HREF='?src=\ref[src];revive=\ref[M]'>Heal/Revive</A> | ")
			foo += text("<A HREF='?src=\ref[src];forcespeech=\ref[M]'>Say</A> | ")
			foo += text("<A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A> | ")
			foo += text("<A href='?src=\ref[src];mute2=\ref[M]'>Mute: [(M.muted ? "Muted" : "Voiced")]</A> | ")
			foo += text("<A href='?src=\ref[src];jobban2=\ref[M]'>Jobban</A> | ")
			foo += text("<A href='?src=\ref[src];boot2=\ref[M]'>Boot</A> | ")
		foo += text("<A href='?src=\ref[src];ban2=\ref[M]'>Ban</A> \]")
		dat += text("<body>[foo]</body></html>")
		usr << browse(dat, "window=playeropts;size=420x70")

	if (href_list["tratmenu"])
		var/dat="<table><th><B>Name</th><th>Real Name</th><th>Key</th><th>IP:</th></B>"
		for(var/mob/M in world)
			var/foo = ""
			if(ismob(M) && M.client)
				if(!ticker)
					alert("The game hasn't started yet!")
					return
				if (ticker.killer && M.key==ticker.killer.key)
					if(ticker.objective == 1)
						foo += text("<B>Is a Traitor. Objective: To murder someone</B>")
					if(ticker.objective == 2)
						foo += text("<B>Is a Traitor. Objective: To hijack the shuttle</B>")
					if(ticker.objective == 3)
						foo += text("<B>Is a Traitor. Objective: To steal something</B>")
					if(ticker.objective == 4)
						foo += text("<B>Is a Traitor. Objective: To sabotage something</B>")
				else if(M in killer)
					foo += text("<B>Is a Traitor. Objective: [traitobj[text("[M.key]")]]</B>")
				else if (M.start)
					foo += text("<A HREF='?src=\ref[];traitorize=\ref[]'>Make Traitor</A>", src, M)

			dat += text("<tr><td>N: []</td><td> R: []</td><td> (K: [])</td><td> (IP: [])</td><td> []</td></tr>", M.name, M.rname, (M.client ? M.client : "No client"), M.lastKnownIP, foo)
		dat += "</table>"
		usr <<browse(dat, "window=traitors;size=640x480")

	if (href_list["create_object"])
		if ((src.rank in list( "Administrator", "Primary Administrator", "Coder", "Host"  )))
			if(config.allow_admin_spawning)
				return DisplayMenu(usr)
			else
				alert("Admin item spawning disabled")
		else alert("You are not a high enough administrator! Sorry!!!!")

	if (href_list["ObjectList"])
		if ((src.rank in list( "Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/atom/loc = usr.loc
			var/object = href_list["ObjectList"]
			var/list/offset = dd_text2list(href_list["offset"],",")
			var/number = dd_range(1,100,text2num(href_list["number"]))
			var/X = ((offset.len>0)?text2num(offset[1]) : 0)
			var/Y = ((offset.len>1)?text2num(offset[2]) : 0)
			var/Z = ((offset.len>2)?text2num(offset[3]) : 0)

			for(var/i = 1 to number)
				switch(href_list["otype"])
					if("absolute")
						new object(locate(0+X,0+Y,0+Z))
					if("relative")
						if(loc)
							new object(locate(loc.x+X,loc.y+Y,loc.z+Z))
					else
						return
			if(number == 1)
				world.log_admin("[usr.key] created \a [object]")
			else
				world.log_admin("[usr.key] created [number]ea [object]")

	if (href_list["secrets"])
		if ((src.rank in list( "Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/dat = {"
<B>Which menu would you like to go to?</B><HR>
<A href='?src=\ref[src];secretsadmin=1'>Admin Secrets</A><BR>
<A href='?src=\ref[src];secretsfun=1'>Fun Secrets</A><BR>"}
			usr << browse(dat, "window=secrets")

	if (href_list["secretsadmin"])
		if ((src.rank in list( "Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/dat = {"
<B>What secret do you wish to activate?</B><HR>
<A href='?src=\ref[src];secrets2=clear_bombs'>Remove all bombs currently  existence</A><BR>
<A href='?src=\ref[src];secrets2=list_bombers'>Show a list of all people who made a bomb</A><BR>
<A href='?src=\ref[src];secrets2=check_antagonist'>Show the key of the traitor</A><BR>
<A href='?src=\ref[src];secrets2=list_signalers'>Show last [length(lastsignalers)] signalers</A><BR>
<A href='?src=\ref[src];secrets2=showailaws'>Show AI Laws</A><BR>
<A href='?src=\ref[src];secrets2=showgm'>Show Game Mode</A><BR>"}
			usr << browse(dat, "window=secretsadmin")

	if (href_list["secretsfun"])
		if ((src.rank in list( "Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/dat = {"
<B>What secret do you wish to activate?</B><HR>
<A href='?src=\ref[src];secrets2=sec_clothes'>Remove 'internal' clothing</A><BR>
<A href='?src=\ref[src];secrets2=sec_all_clothes'>Remove ALL clothing</A><BR>
<A href='?src=\ref[src];secrets2=toxic'>Toxic Air (WARNING: dangerous)</A><BR>
<A href='?src=\ref[src];secrets2=monkey'>Turn all humans into monkies</A><BR>
<A href='?src=\ref[src];secrets2=sec_classic1'>Remove firesuits, grilles, and pods</A><BR>
<A href='?src=\ref[src];secrets2=power'>Make all areas powered</A><BR>
<A href='?src=\ref[src];secrets2=unpower'>Make all areas unpowered</A><BR>
<A href='?src=\ref[src];secrets2=toggleprisonstatus'>Toggle Prison Shuttle Status(Use with S/R)</A><BR>
<A href='?src=\ref[src];secrets2=activateprison'>Send Prison Shuttle</A><BR>
<A href='?src=\ref[src];secrets2=deactivateprison'>Return Prison Shuttle</A><BR>
<A href='?src=\ref[src];secrets2=prisonwarp'>Warp all Players to Prison</A><BR>
<A href='?src=\ref[src];secrets2=traitor_all'>Everyone is the traitor</A><BR>
<A href='?src=\ref[src];secrets2=wave'>Spawn a wave of meteors</A><BR>
<A href='?src=\ref[src];secrets2=flicklights'>Ghost Mode</A><BR>"}
//<A href='?src=\ref[src];secrets2=shockwave'>Station Shockwave</A><BR>"}


			usr << browse(dat, "window=secretsfun")

	if (href_list["secrets2"])
		if ((src.rank in list( "Administrator", "Primary Administrator", "Coder", "Host"  )))
			var/ok = 0
			switch(href_list["secrets2"])
				if("sec_clothes")
					for(var/obj/item/weapon/clothing/under/O in world)
						del(O)
					ok = 1
				if("sec_all_clothes")
					for(var/obj/item/weapon/clothing/O in world)
						del(O)
					ok = 1
				if("sec_classic1")
					for(var/obj/item/weapon/clothing/suit/firesuit/O in world)
						del(O)
					for(var/obj/grille/O in world)
						del(O)
					for(var/obj/machinery/vehicle/pod/O in world)
						for(var/mob/M in src)
							M.loc = src.loc
							if (M.client)
								M.client.perspective = MOB_PERSPECTIVE
								M.client.eye = M
						del(O)
					ok = 1
				if("clear_bombs")
					for(var/obj/item/weapon/assembly/r_i_ptank/O in world)
						del(O)
					for(var/obj/item/weapon/assembly/m_i_ptank/O in world)
						del(O)
					for(var/obj/item/weapon/assembly/t_i_ptank/O in world)
						del(O)
					ok = 1
				if("list_bombers")
					var/dat = "<B>Don't be insane about this list</B> Get the facts. They also could have disarmed one.<HR>"
					for(var/l in bombers)
						dat += text("[] 'made' a bomb.<BR>", l)
					usr << browse(dat, "window=bombers")
				if("list_signalers")
					var/dat = "<B>Showing last [length(lastsignalers)] signalers.</B><HR>"
					for(var/sig in lastsignalers)
						dat += "[sig]<BR>"
					usr << browse(dat, "window=lastsignalers;size=800x500")
				if("toxic")
					for(var/obj/machinery/atmoalter/siphs/fullairsiphon/O in world)
						O.t_status = 3
					for(var/obj/machinery/atmoalter/siphs/scrubbers/O in world)
						O.t_status = 1
						O.t_per = 1000000.0
					for(var/obj/machinery/atmoalter/canister/O in world)
						if (!( istype(O, /obj/machinery/atmoalter/canister/oxygencanister) ))
							O.t_status = 1
							O.t_per = 1000000.0
						else
							O.t_status = 3
				if("check_antagonist")
					if (ticker)
						if (ticker.killer)
							if (ticker.killer.ckey)
								alert(text("The traitor is [] ([]) @ [].", ticker.killer.rname, ticker.killer.ckey, get_area(ticker.killer)), null, null, null, null, null)
							else
								alert("It seems like the traitor logged out...", null, null, null, null, null)
						else
							alert("There is no traitor.", null, null, null, null, null)
					else
						alert("The game has not started yet.", null, null, null, null, null)
				if("monkey")
					for(var/mob/human/H in world)
						spawn(0)
							H.monkeyize()
					ok = 1
				if("power")
					for(var/obj/item/weapon/cell/C in world)
						C.charge = C.maxcharge
					for(var/obj/machinery/power/smes/S in world)
						S.charge = S.capacity
						S.output = 200000
						S.online = 1
						S.updateicon()
						S.power_change()
					for(var/area/A in world)
						if(A.name != "Space" && A.name != "Engine Walls" && A.name != "Toxin Test Chamber" && A.name != "space" && A.name != "Escape Shuttle" && A.name != "Arrival Area" && A.name != "Arrival Shuttle" && A.name != "start area" && A.name != "Engine Combustion Chamber")
							A.power_light = 1
							A.power_equip = 1
							A.power_environ = 1
							A.power_change()
				if("unpower")
					for(var/obj/item/weapon/cell/C in world)
						C.charge = 0
					for(var/obj/machinery/power/smes/S in world)
						S.charge = 0
						S.output = 0
						S.online = 0
						S.updateicon()
						S.power_change()
					for(var/area/A in world)
						if(A.name != "Space" && A.name != "Engine Walls" && A.name != "Toxin Test Chamber" && A.name != "Escape Shuttle" && A.name != "Arrival Area" && A.name != "Arrival Shuttle" && A.name != "start area" && A.name != "Engine Combustion Chamber")
							A.power_light = 0
							A.power_equip = 0
							A.power_environ = 0
							A.power_change()
				if("activateprison")
					world << "\blue <B>Transit signature detected.</B>"
					world << "\blue <B>Incoming shuttle.</B>"
					var/A = locate(/area/shuttle_prison)
					for(var/atom/movable/AM as mob|obj in A)
						AM.z = 1
						AM.Move()
					messageadmins("\blue [usr.key] sent the prison shuttle to the station.")
				if("deactivateprison")
					var/A = locate(/area/shuttle_prison)
					for(var/atom/movable/AM as mob|obj in A)
						AM.z = 2
						AM.Move()
					messageadmins("\blue [usr.key] sent the prison shuttle back.")
				if("toggleprisonstatus")
					for(var/obj/machinery/computer/prison_shuttle/PS in world)
						PS.allowedtocall = !(PS.allowedtocall)
						messageadmins("\blue [usr.key] toggled status of prison shuttle to [PS.allowedtocall].")
				if("prisonwarp")
					if(!ticker)
						alert("The game hasn't started yet!", null, null, null, null, null)
						return
					messageadmins("\blue [usr.key] teleported all players to the prison station.")
					for(var/mob/human/H in world)
						var/turf/loc = find_loc(H)
						var/security = 0
						if(!H.start || loc.z > 1 || prisonwarped.Find(H))	//don't warp them if they aren't ready or are already there
							continue
						H.paralysis += 5
						if(H.wear_id)
							for(var/A in H.wear_id.access)
								if(A == access_security)
									security++
						if(!security)
							//strip their stuff before they teleport into a cell :downs:
							for(var/obj/item/weapon/W in H)
								if(istype(W, /obj/item/weapon/organ/external))	continue	//don't strip organs
								H.u_equip(W)
								if (H.client)
									H.client.screen -= W
								if (W)
									W.loc = H.loc
									W.dropped(H)
									W.layer = initial(W.layer)
							//teleport person to cell
							H.loc = pick(prisonwarp)
							H.equip_if_possible(new /obj/item/weapon/clothing/under/orange(H), H.slot_w_uniform)
							H.equip_if_possible(new /obj/item/weapon/clothing/shoes/orange(H), H.slot_shoes)
						else
							//teleport security person
							H.loc = pick(prisonsecuritywarp)
						prisonwarped += H
				if("showailaws")
					for(var/mob/ai/ai in world)
						var/lawIndex = 0
						usr << "[ai.rname]/[ai.key]'s Laws:"
						for(var/index=1, index<=ai.laws.len, index++)
							var/law = ai.laws[index]
							if (length(law)>0)
								if (index==2 && lawIndex==0)
									lawIndex = 1
								usr << text("[]. []", lawIndex, law)
								lawIndex += 1
				if("traitor_all")
					var/objective = input("Enter an objective")
					for(var/mob/human/H in world)
						if(!objective)
							return
						if(!ticker)
							alert("The game hasn't started yet!")
							return
						if(H in killer) continue //already traitor
						if(ticker.killer && H.key==ticker.killer.key) continue
						if((H.stat == 2) || !(H.start)) continue //dead or hasn't started
						H << "\red<font size=3><B>You are the traitor! Your objective is: [objective]</B>"
						H << "A syndicate uplink has been hidden in your left pocket, use it to achieve your objective"
						var/obj/item/weapon/syndicate_uplink/W = new /obj/item/weapon/syndicate_uplink(H)
						H.equip_if_possible(new /obj/item/weapon/syndicate_uplink, H.slot_l_store)
						W.layer = 20
						H.l_store = W
						killer += H
						traitobj[text("[]",H.key)] += objective
					messageadmins("\blue[usr.key] used everyone is a traitor secret. Objective is [objective]")
				if("showgm")
					if(!ticker)
						alert("The game hasn't started yet!")
					else
						alert("The game mode is [ticker.mode.name]")

				if("flicklights")
					while(!usr.stat)	//knock yourself out to stop the ghosts
						for(var/mob/M in world)
							if(M.client && M.stat != 2 && prob(25))
								var/area/AffectedArea = get_area(M)
								if(AffectedArea.name != "Space" && AffectedArea.name != "Engine Walls" && AffectedArea.name != "Toxin Test Chamber" && AffectedArea.name != "Escape Shuttle" && AffectedArea.name != "Arrival Area" && AffectedArea.name != "Arrival Shuttle" && AffectedArea.name != "start area" && AffectedArea.name != "Engine Combustion Chamber")
									AffectedArea.power_light = 0
									AffectedArea.power_change()
									spawn(rand(55,185))
										AffectedArea.power_light = 1
										AffectedArea.power_change()
									var/Message = rand(1,4)
									switch(Message)
										if(1)
											M.show_message(text("\blue You shudder as if cold..."), 1)
										if(2)
											M.show_message(text("\blue You feel something gliding across your back..."), 1)
										if(3)
											M.show_message(text("\blue Your eyes twitch, you feel like something you can't see is here..."), 1)
										if(4)
											M.show_message(text("\blue You notice something moving out of the corner of your eye, but nothing is there..."), 1)
									for(var/obj/W in orange(5,M))
										if(prob(25) && !W.anchored)
											step_rand(W)
						sleep(rand(100,1000))
					for(var/mob/M in world)
						if(M.client && M.stat != 2)
							M.show_message(text("\blue The chilling wind suddenly stops..."), 1)
/*				if("shockwave")
					ok = 1
					world << "\red <B><big>ALERT: STATION STRESS CRITICAL</big></B>"
					sleep(60)
					world << "\red <B><big>ALERT: STATION STRESS CRITICAL. TOLERABLE LEVELS EXCEEDED!</big></B>"
					sleep(80)
					world << "\red <B><big>ALERT: STATION STRUCTURAL STRESS CRITICAL. SAFETY MECHANISMS FAILED!</big></B>"
					sleep(40)
					for(var/mob/M in world)
						shake_camera(M, 400, 1)
					for(var/obj/window/W in world)
						spawn(0)
							sleep(rand(10,400))
							W.ex_act(rand(2,1))
					for(var/obj/grille/G in world)
						spawn(0)
							sleep(rand(20,400))
							G.ex_act(rand(2,1))
					for(var/obj/machinery/door/D in world)
						spawn(0)
							sleep(rand(20,400))
							D.ex_act(rand(2,1))
					for(var/turf/station/floor/Floor in world)
						spawn(0)
							sleep(rand(30,400))
							Floor.ex_act(rand(2,1))
					for(var/obj/cable/Cable in world)
						spawn(0)
							sleep(rand(30,400))
							Cable.ex_act(rand(2,1))
					for(var/obj/closet/Closet in world)
						spawn(0)
							sleep(rand(30,400))
							Closet.ex_act(rand(2,1))
					for(var/obj/machinery/Machinery in world)
						spawn(0)
							sleep(rand(30,400))
							Machinery.ex_act(rand(1,3))
					for(var/turf/station/wall/Wall in world)
						spawn(0)
							sleep(rand(30,400))
							Wall.ex_act(rand(2,1)) */
				if("wave")
					if ((src.rank in list("Primary Administrator", "Coder", "Host"  )))
						meteor_wave()
					else
						alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
						return
				else
			if (usr)
				world.log_admin("[usr.key] used secret [href_list["secrets2"]]")
				if (ok)
					world << text("<B>A secret has been activated by []!</B>", usr.key)
	return


/obj/admins/proc/update()

	var/dat
	var/lvl = 0
	switch(src.rank)
		if("Moderator")
			lvl = 1
		if("Secondary Administrator")
			lvl = 2
		if("Administrator")
			lvl = 3
		if("Primary Administrator")
			lvl = 4
		if("Coder")
			lvl = 5
		if("Host")
			lvl = 6

	switch(src.screen)
		if(1.0)

			dat += "<center><B>Player Panel</B></center><hr>\n"

			if(lvl >= 2)
				dat += {"
	<A href='?src=\ref[src];ban=1'>Ban List</A><br>
	"}

//			if(lvl > 0)

//			if(lvl >= 3)
			dat += "<BR>"
			if(lvl >= 2 )

				dat += "<A href='?src=\ref[src];l_keys=1'>List Keys</A><br>"
				dat += "<A href='?src=\ref[src];l_players=1'>List Players/Keys</A><br>"
				dat += "<A href='?src=\ref[src];tratmenu=1'>Traitor Menu</A><br>"


//			if(lvl >= 5)


//			if(lvl == 6 )

		else
			dat = text("<center><B>Abuse Control Center</B></center><hr>\n<A href='?src=\ref[];access=1'>Access Admin Commands</A><br>\n<A href='?src=\ref[];contact=1'>Contact Admins</A><br>\n<A href='?src=\ref[];message=1'>Access Messageboard</A><br>\n<br>\n<A href='?src=\ref[];l_keys=1'>List Keys</A><br>\n<A href='?src=\ref[];l_players=1'>List Players/Keys</A><br>\n<A href='?src=\ref[];g_send=1'>Send Global Message</A><br>\n<A href='?src=\ref[];p_send=1'>Send Private Message</A><br>", src, src, src, src, src, src, src)
	usr << browse(dat, "window=admin;size=210x160")
	return

/obj/admins/proc/update2()

	var/dat
	var/lvl = 0
	switch(src.rank)
		if("Moderator")
			lvl = 1
		if("Secondary Administrator")
			lvl = 2
		if("Administrator")
			lvl = 3
		if("Primary Administrator")
			lvl = 4
		if("Coder")
			lvl = 5
		if("Host")
			lvl = 6

	switch(src.screen)
		if(1.0)

			dat += "<center><B>Game Panel</B></center><hr>\n"

//			if(lvl > 0)

			if(lvl >= 2 )
				dat += "<A href='?src=\ref[src];c_mode=1'>Change Game Mode</A><br>"

			dat += "<BR>"

			if(lvl >= 3 )
				dat += "<A href='?src=\ref[src];secrets=1'>Activate Secrets</A><br>"
				dat += "<A href='?src=\ref[src];create_object=1'>Create Object</A><br>"

//			if(lvl >= 5)

//			if(lvl == 6 )

		else
			dat = text("<center><B>Abuse Control Center</B></center><hr>\n<A href='?src=\ref[];access=1'>Access Admin Commands</A><br>\n<A href='?src=\ref[];contact=1'>Contact Admins</A><br>\n<A href='?src=\ref[];message=1'>Access Messageboard</A><br>\n<br>\n<A href='?src=\ref[];l_keys=1'>List Keys</A><br>\n<A href='?src=\ref[];l_players=1'>List Players/Keys</A><br>\n<A href='?src=\ref[];g_send=1'>Send Global Message</A><br>\n<A href='?src=\ref[];p_send=1'>Send Private Message</A><br>", src, src, src, src, src, src, src)
	usr << browse(dat, "window=admin2;size=210x160")
	return







///////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge








/obj/admins/proc/vmode()
	set category = "Admin-Game"
	set name = "Start Vote"
	set desc="Starts vote"
	var/confirm = alert("What vote would you like to start?", "Vote", "Restart", "Change Game Mode", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Restart")
		vote.mode = 0 	// hack to yield 0=restart, 1=changemode
	if(confirm == "Change Game Mode")
		vote.mode = 1
	vote.voting = 1						// now voting
	vote.votetime = world.timeofday + config.vote_period*10	// when the vote will end
	spawn(config.vote_period*10)
		vote.endvote()
	world << "\red<B>*** A vote to [vote.mode?"change game mode":"restart"] has been initiated by Admin [usr.key].</B>"
	world << "\red     You have [vote.timetext(config.vote_period)] to vote."

	world.log_admin("Voting to [vote.mode?"change mode":"restart round"] forced by admin [usr.key]")

	for(var/mob/CM in world)
		if(CM.client)
			if(config.vote_no_default || (config.vote_no_dead && CM.stat == 2) || !CM.client.authenticated)
				CM.client.vote = "none"
			else
				CM.client.vote = "default"

	for(var/mob/CM in world)
		if(CM.client)
			if(config.vote_no_default || (config.vote_no_dead && CM.stat == 2) || !CM.client.authenticated)
				CM.client.vote = "none"
			else
				CM.client.vote = "default"
/obj/admins/proc/votekill()
	set category = "Admin-Game"
	set name = "Abort Vote"
	set desc="Aborts a vote"
	world << "\red <B>***Voting aborted by [usr.key].</B>"

	world.log_admin("Voting aborted by [usr.key]")

	vote.voting = 0
	vote.nextvotetime = world.timeofday + 10*config.vote_delay

	for(var/mob/M in world)		// clear vote window from all clients
		if(M.client)
			M << browse(null, "window=vote")
			M.client.showvote = 0

/obj/admins/proc/voteres()
	set category = "Admin-Game"
	set name = "Toggle Voting"
	set desc="Toggles Votes"
	var/confirm = alert("What vote would you like to toggle?", "Vote", "Restart [config.allow_vote_restart ? "Off" : "On"]", "Change Game Mode [config.allow_vote_mode ? "Off" : "On"]", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Restart [config.allow_vote_restart ? "Off" : "On"]")
		config.allow_vote_restart = !config.allow_vote_restart
		world << "<B>Player restart voting toggled to [config.allow_vote_restart ? "On" : "Off"]</B>."
		world.log_admin("Restart voting toggled to [config.allow_vote_restart ? "On" : "Off"] by [usr.key].")

		if(config.allow_vote_restart)
			vote.nextvotetime = world.timeofday
	if(confirm == "Change Game Mode [config.allow_vote_mode ? "Off" : "On"]")
		config.allow_vote_mode = !config.allow_vote_mode
		world << "<B>Player mode voting toggled to [config.allow_vote_mode ? "On" : "Off"]</B>."
		world.log_admin("Mode voting toggled to [config.allow_vote_mode ? "On" : "Off"] by [usr.key].")

		if(config.allow_vote_mode)
			vote.nextvotetime = world.timeofday

/obj/admins/proc/restart()
	set category = "Admin-Game"
	set name = "Restart"
	set desc="Restarts the world"
	var/confirm = alert("Restart the game world?", "Restart", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		world << text("\red <B> Restarting world!</B>\blue  Initiated by []!", usr.key)
		world.log_admin("[usr.key] initiated a reboot.")
		sleep(50)
		world.Reboot()

/obj/admins/proc/announce()
	set category = "Admin-Game"
	set name = "Announce"
	set desc="Announce your desires to the world"
	var/t = input("Global message to send:", "Admin Announce", null, null)  as message
	if (t)
		world << "\blue <B>[usr.key] Announces:</B>\n \t [t]"
		world.log_admin("Announce: [usr.key] : [t]")

/obj/admins/proc/toggleooc()
	set category = "Admin-Game"
	set desc="Toggle dis bitch"
	set name="Toggle OOC"
	ooc_allowed = !( ooc_allowed )
	if (ooc_allowed)
		world << "<B>The OOC channel has been globally enabled!</B>"
	else
		world << "<B>The OOC channel has been globally disabled!</B>"
	world.log_admin("[usr.key] toggled OOC.")
	messageadmins("<font color='blue'>[usr.key] toggled OOC.</font>")

/obj/admins/proc/startnow()
	set category = "Admin-Game"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if (!ticker)
		world << "<B>The game will now start immediately thanks to [usr.key]!</B>"
		going = 1
		ticker = new /datum/control/gameticker()
		spawn (0)
			world.log_admin("[usr.key] used start_now")
			ticker.process()
		data_core = new /obj/datacore()
	else alert("Game has already started you fucking jerk, stop spamming up the chat :ARGH:")

/obj/admins/proc/toggleenter()
	set category = "Admin-Game"
	set desc="People can't enter"
	set name="Toggle Entering"
	enter_allowed = !( enter_allowed )
	if (!( enter_allowed ))
		world << "<B>You may no longer enter the game.</B>"
	else
		world << "<B>You may now enter the game.</B>"
	world.log_admin("[usr.key] toggled new player game entering.")
	messageadmins("\blue[usr.key] toggled new player game entering.")
	world.update_stat()

/obj/admins/proc/toggleAI()
	set category = "Admin-Game"
	set desc="People can't be AI"
	set name="Toggle AI"
	config.allow_ai = !( config.allow_ai )
	if (!( config.allow_ai ))
		world << "<B>The AI job is no longer chooseable.</B>"
	else
		world << "<B>The AI job is chooseable now.</B>"
	world.log_admin("[usr.key] toggled AI allowed.")
	world.update_stat()

/obj/admins/proc/toggleaban()
	set category = "Admin-Game"
	set desc="Respawn basically"
	set name="Toggle Abandon"
	abandon_allowed = !( abandon_allowed )
	if (abandon_allowed)
		world << "<B>You may now abandon mob.</B>"
	else
		world << "<B>You may no longer abandon mob :(</B>"
	messageadmins("\blue[usr.key] toggled abandon mob to [abandon_allowed ? "On" : "Off"].")
	world.log_admin("[usr.key] toggled abandon mob to [abandon_allowed ? "On" : "Off"].")
	world.update_stat()

/obj/admins/proc/delay()
	set category = "Admin-Game"
	set desc="Delay the game start"
	set name="Delay"
	if (ticker)
		return alert("Too late... The game has already started!", null, null, null, null, null)
	going = !( going )
	if (!( going ))
		world << "<B>The game start has been delayed.</B>"
		world.log_admin("[usr.key] delayed the game.")
	else
		world << "<B>The game will start soon.</B>"
		world.log_admin("[usr.key] removed the delay.")

/obj/admins/proc/adjump()
	set category = "Admin-Game"
	set desc="Toggle admin jumping"
	set name="Toggle Jump"
	config.allow_admin_jump = !(config.allow_admin_jump)
	messageadmins("\blue Toggled admin jumping to [config.allow_admin_jump].")

/obj/admins/proc/adspawn()
	set category = "Admin-Game"
	set desc="Toggle admin spawning"
	set name="Toggle Spawn"
	config.allow_admin_spawning = !(config.allow_admin_spawning)
	messageadmins("\blue Toggled admin item spawning to [config.allow_admin_spawning].")

/obj/admins/proc/adrev()
	set category = "Admin-Game"
	set desc="Toggle admin revives"
	set name="Toggle Revive"
	config.allow_admin_rev = !(config.allow_admin_rev)
	messageadmins("\blue Toggled reviving to [config.allow_admin_rev].")


/obj/admins/proc/immreboot()
	set category = "Admin-Game"
	set desc="Reboots the server post haste"
	set name="Immediate Reboot"
	if( alert("Reboot server?",,"Yes","No") == "No")
		return
	world << text("\red <B> Rebooting world!</B>\blue  Initiated by []!", usr.key)
	world.log_admin("[usr.key] initiated an immediate reboot.")
	world.Reboot()

//
//
//ALL DONE
//*********************************************************************************************************
//TO-DO:
//
//