/client/proc/ticklag(number as num)
	set category = "Debug"
	set name = "Ticklag"
	set desc = "Ticklag"
	if(src.authenticated)
		if(!src.mob)
			return
		world.tick_lag = number

