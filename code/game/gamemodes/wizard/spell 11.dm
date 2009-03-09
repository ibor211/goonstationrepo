/client/proc/hulk()
	set category = "Spells"
	set name = "Transformation"
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
	usr.verbs -= /client/proc/hulk
	spawn(600)
		usr.verbs += /client/proc/hulk
	usr.say("BIRUZ BENNAR")
	usr << text("\blue You feel strong!")
	usr.ishulk = 1
	spawn (300)
		usr.ishulk = 0
	return
