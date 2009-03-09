client/proc/hide(obj/item/weapon/T as obj in view(1))

	set category = "Spells"
	set name = "Hide"
	set desc = "Hide object:"
	if(usr.stat >= 2)
		usr << "Not when you're dead!"
		return
	if(!istype(usr:wear_suit, /obj/item/weapon/clothing/suit/wizrobe))
		usr << "I don't feel strong enough to use this spell"
		return
	if(!istype(usr:shoes, /obj/item/weapon/clothing/shoes/sandal))
		usr << "I don't feel strong enough to use this spell"
		return
	if(!istype(usr:head, 	/obj/item/weapon/clothing/head/wizhat))
		usr << "I don't feel strong enough to use this spell"
		return
	var/backup = T.icon_state
	var/mob/human/G = usr
	usr.verbs -= /client/proc/hide
	spawn(200)
		usr.verbs += /client/proc/hide
	if (istype(T,/obj/item/weapon))
		var/backuptwo = T.s_istate
		T.s_istate= "nothing"
		T.icon_state = "nothing"
		G.say("OLIOCH MINTERIDAS")
		sleep(600)
		if (T)
			T.icon_state = backup
			T.s_istate = backuptwo
		return
	G.say("OLIOCH MINTERIDAS")
	T.icon_state = "nothing"
	sleep(600)
	T.icon_state = backup
	return