/proc/start_events() //add stuff
	if (!event && prob(5))
		meteor_wave()
		event = 1
		spawn(1200)
			event = 0
	spawn(1200)
		start_events()
