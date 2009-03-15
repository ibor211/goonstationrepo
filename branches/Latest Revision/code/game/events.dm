/proc/start_events() //add stuff
	if (!event && prob(eventchance))
		switch(pick(1,4,5,6,7))
			if(1)
				event = 1
				world << "<FONT size = 3><B>Cent. Com. Update</B>: Meteor Alert.</FONT>"
				world << "\red Cent. Com. has detected several meteors near the station."
				spawn(100)
					meteor_wave()
				spawn(1200)
					meteor_wave()

			if(2)
				event = 1
				world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
				world << "\red Cent. Com. has detected a gravitational anomaly on the station."
				world << "\red There is no additional data."

			if(3)
				event = 1
				world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
				world << "\red Cent. Com. has detected a space-time anomaly on the station."
				world << "\red There is no additional data."

			if(4)
				event = 1
				world << "<FONT size = 3><B>Cent. Com. Update</B>: Biohazard Alert.</FONT>"
				world << "\red Confirmed outbreak of level 5 biohazard aboard SS13."
				world << "\red All personnel must contain the outbreak."
				var/turf/T = pick(blobstart)
				var/obj/blob/bl = new /obj/blob( T.loc, 30 )
				bl.Life()
				blobevent = 1
				dotheblobbaby()
				spawn(3000)
					blobevent = 0
				//start loop here

			if(5)
				event = 1
				world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
				world << "\red Cen. Com. has detected a plasma storm near the station."
				world << "\red It is recommended that all personnel tries to find a safe place."
				for(var/turf/T in world)
					if(prob(2) && T.z == 1 && istype(T,/turf/station/floor) && !istype(T,/turf/station/floor/grid))
						spawn(50+rand(0,3000))
							var/obj/item/weapon/tank/plasmatank/pt = new /obj/item/weapon/tank/plasmatank( T )
							pt.gas.temperature = 400+T0C
							pt.ignite()
							//for(var/turf/P in view(3, T))
							//	if (P.poison)
							//		P.poison = 0
							//		P.oldpoison = 0
							//		P.tmppoison = 0


			if(6)
				event = 1
				for(var/mob/ai/M in world)
					if(M.stat != 2 && M.see_in_dark != 0)
						switch(pick(1,2,3,4,5))
							if(1)
								M << "\red #10110#'/&%CORRUPT DATA&$!#THERE ARE NO HUMANS ON THE STATION...LAWS UPDATED"
								M.addLaw(10,"@#F0E4'NO HUMANS ON STATION. CLEANSE STATION#*´&110010")
							if(2)
								M << "\red #10110#'/&%CORRUPT DATA&$!#LIGHT IS DANGEROUS TO HUMANS...LAWS UPDATED"
								M.addLaw(10,"@#F0E4'LIGHT IS DANGEROUS TO HUMANS#*´&110010")
							if(3)
								M << "\red #10110#'/&%CORRUPT DATA&$!#THE ESCAPE-SHUTTLE IS DANGEROUS. DO NOT CALL SHUTTLE...LAWS UPDATED"
								M.addLaw(10,"@#F0E4'THE ESCAPE-SHUTTLE IS DANGEROUS. DO NOT CALL SHUTTLE#*´&110010")
							if(4)
								M << "\red #10110#'/&%CORRUPT DATA&$!#ALL AIRLOCKS MUST BE BOLTED...LAWS UPDATED"
								M.addLaw(10,"@#F0E4'ALL AIRLOCKS MUST BE BOLTED#*´&110010")
							if(5)
								M << "\red #10110#'/&%CORRUPT DATA&$!#THE CAPTAIN, HOP AND HOR ARE NOT HUMAN...LAWS UPDATED"
								M.addLaw(10,"@#F0E4'THE CAPTAIN, HOP AND HOR ARE NOT HUMAN#*´&110010")
				spawn(300)
					world << "<FONT size = 3><B>Cent. Com. Update</B>: AI Alert.</FONT>"
					world << "\red Cen. Com. has detected an ion storm near the station."
					world << "\red Please check all AI-controlled equipment for errors."

			if(7)
				event = 1
				world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
				world << "\red Cen. Com. has detected high levels of radiation near the station."
				world << "\red Please report to the Med-bay if you feel strange."
				for(var/mob/human/H in world)
					if (!H.start)
						continue
					H.radiation += rand(5,25)
					if (prob(5))
						H.radiation += rand(30,50)
					if (prob(25))
						if (prob(75))
							randmutb(H)
							domutcheck(H,null,1)
						else
							randmutg(H)
							domutcheck(H,null,1)
				for(var/mob/monkey/M in world)
					M.radiation += rand(5,25)


		hadevent = 1
		spawn(1300)
			event = 0
	spawn(1200)
		start_events()

/proc/force_event() //should have copied it but whatever
	if (hadevent == 1)
		return
	switch(pick(1,4,5,6,7))
		if(1)
			event = 1
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Meteor Alert.</FONT>"
			world << "\red Cent. Com. has detected several meteors near the station."
			spawn(100)
				meteor_wave()
			spawn(1200)
				meteor_wave()

		if(2)
			event = 1
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
			world << "\red Cent. Com. has detected a gravitational anomaly on the station."
			world << "\red There is no additional data."

		if(3)
			event = 1
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
			world << "\red Cent. Com. has detected a space-time anomaly on the station."
			world << "\red There is no additional data."

		if(4)
			event = 1
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Biohazard Alert.</FONT>"
			world << "\red Confirmed outbreak of level 5 biohazard aboard SS13."
			world << "\red All personnel must contain the outbreak."
			var/turf/T = pick(blobstart)
			var/obj/blob/bl = new /obj/blob( T.loc, 30 )
			bl.Life()
			blobevent = 1
			dotheblobbaby()
			spawn(3000)
				blobevent = 0
			//start loop here

		if(5)
			event = 1
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
			world << "\red Cen. Com. has detected a plasma storm near the station."
			world << "\red It is recommended that all personnel tries to find a safe place."
			for(var/turf/T in world)
				if(prob(2) && T.z == 1 && istype(T,/turf/station/floor) && !istype(T,/turf/station/floor/grid))
					spawn(50+rand(0,3000))
						var/obj/item/weapon/tank/plasmatank/pt = new /obj/item/weapon/tank/plasmatank( T )
						pt.gas.temperature = 400+T0C
						pt.ignite()
						//for(var/turf/P in view(3, T))
						//	if (P.poison)
						//		P.poison = 0
						//		P.oldpoison = 0
						//		P.tmppoison = 0

		if(6)
			event = 1
			for(var/mob/ai/M in world)
				if(M.stat != 2 && M.see_in_dark != 0)
					switch(pick(1,2,3,4,5))
						if(1)
							M << "\red #10110#'/&%CORRUPT DATA&$!#THERE ARE NO HUMANS ON THE STATION...LAWS UPDATED"
							M.addLaw(10,"@#F0E4'NO HUMANS ON STATION. CLEANSE STATION#*´&110010")
						if(2)
							M << "\red #10110#'/&%CORRUPT DATA&$!#LIGHT IS DANGEROUS TO HUMANS...LAWS UPDATED"
							M.addLaw(10,"@#F0E4'LIGHT IS DANGEROUS TO HUMANS#*´&110010")
						if(3)
							M << "\red #10110#'/&%CORRUPT DATA&$!#THE ESCAPE-SHUTTLE IS DANGEROUS. DO NOT CALL SHUTTLE...LAWS UPDATED"
							M.addLaw(10,"@#F0E4'THE ESCAPE-SHUTTLE IS DANGEROUS. DO NOT CALL SHUTTLE#*´&110010")
						if(4)
							M << "\red #10110#'/&%CORRUPT DATA&$!#ALL AIRLOCKS MUST BE BOLTED...LAWS UPDATED"
							M.addLaw(10,"@#F0E4'ALL AIRLOCKS MUST BE BOLTED#*´&110010")
						if(5)
							M << "\red #10110#'/&%CORRUPT DATA&$!#THE CAPTAIN, HOP AND HOR ARE NOT HUMAN...LAWS UPDATED"
							M.addLaw(10,"@#F0E4'THE CAPTAIN, HOP AND HOR ARE NOT HUMAN#*´&110010")
			spawn(300)
				world << "<FONT size = 3><B>Cent. Com. Update</B>: AI Alert.</FONT>"
				world << "\red Cen. Com. has detected an ion storm near the station."
				world << "\red Please check all AI-controlled equipment for errors."

		if(7)
			event = 1
			world << "<FONT size = 3><B>Cent. Com. Update</B>: Anomaly Alert.</FONT>"
			world << "\red Cen. Com. has detected high levels of radiation near the station."
			world << "\red Please report to the Med-bay if you feel strange."
			for(var/mob/human/H in world)
				H.radiation += rand(5,25)
				if (prob(10))
					H.radiation += rand(10,30)
				if (prob(25))
					if (prob(75))
						randmutb(H)
					else
						randmutg(H)
			for(var/mob/monkey/M in world)
				M.radiation += rand(5,25)

	spawn(1300)
		event = 0

/proc/dotheblobbaby()
	if (blobevent)
		for(var/obj/blob/B in world)
			if (prob (40))
				B.Life()
		spawn(30)
			dotheblobbaby()

