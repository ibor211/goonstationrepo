/obj/item/weapon/cleaner/attack(mob/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/cleaner/afterattack(atom/A as mob|obj, mob/user as mob)
	if (src.water < 1)
		user << "\blue Add more water!"
		return
	if (istype(A, /mob/human))
		var/mob/human/M = A
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []'s hands</B>", user, M), 1)
		var/turf/T = user.loc
		sleep(40)
		if ((user.loc == T && user.equipped() == src && !( user.stat )))
			src.water -= 1
			if (M.gloves)
				M.gloves.clean_blood()
			else
				M.clean_blood()
	else if (istype(A, /obj/bloodtemplate))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		var/turf/T = user.loc
		sleep(40)
		if ((user.loc == T && user.equipped() == src && !( user.stat )))
			src.water -= 1
			del(A)
	return

/obj/item/weapon/cleaner/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.water)
	..()
	return

/obj/item/weapon/bucket/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.water)
	..()
	return

/obj/mopbucket/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.water)
	..()
	return

/obj/item/weapon/mop/attack(mob/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/mop/afterattack(atom/A as turf|area, mob/user as mob)
	if (src.wet < 1)
		user << "\blue Your mop is dry!"
		return
	if ((istype(A, /obj/item/weapon)) || (istype(A, /turf/station)))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		var/turf/T = user.loc
		sleep(40)
		if ((user.loc == T && user.equipped() == src && !( user.stat )))
			src.wet -= 1
			A.clean_blood()
	else if (istype(A, /obj/bloodtemplate))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		var/turf/T = user.loc
		sleep(40)
		if ((user.loc == T && user.equipped() == src && !( user.stat )))
			src.wet -= 1
			del(A)
	return