/client/proc/telekinesis()
	set category = "Spells"
	set name = "Telekinesis"
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
	usr.verbs -= /client/proc/telekinesis
	spawn(600)
		usr.verbs += /client/proc/telekinesis
	usr.say("TALLI VERITHA")
	usr << text("\blue Your mind expands!")
	usr.telekinesis = 1
	spawn (300)
		usr.telekinesis = 0
	return
