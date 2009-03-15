/world/proc/update_status()
	var/s = ""
	
	s += "Goon Station 13";
	s += " ([src.version])"

	var/list/features = list()

	if (!ticker)
		features += "<b>STARTING</b>"

	if (ticker && master_mode)
		features += master_mode

	if (config && config.enable_authentication)
		features += "goon only"

	if (!enter_allowed)
		features += "closed"

	if (abandon_allowed)
		features += abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	if (host)
		features += "hosted by <b>[host]</b>"
	else if (config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		s += ": [dd_list2text(features, ", ")]"
	
	src.status = s
