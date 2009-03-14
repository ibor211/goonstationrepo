/mob/proc/unlock_medal(title, announce)
	/*
	causing a crash on FreeBSD so disabling for now.
	
	spawn ()
		if (ismob(src) && src.key)
			if (world.SetMedal(title, src, "Slurm.GoonStationMedals", "hnfrtpOkWVkfMTwm") == 1)
				if (announce)
					world << "<font color=olive><b>[src.key] earned the [title] medal.</b></font>"
	*/
