/datum/game_mode/proc/setup_game()
	spawn ( 0 )
		randomchems()
	spawn (3000)
		start_events()
	spawn ((18000+rand(3000)))
		force_event()
