/proc/start_events()
	world << "Event."
	if (!event && prob(5))
		meteor_wave()
		world << "Meteors."
		event = 1
		spawn(1200)
			event = 0
	spawn(1200)
		start_events()
