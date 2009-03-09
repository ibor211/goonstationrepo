/mob/verb/listen_ooc()
	set name = "(Un)Mute OOC"

	if (src.client)
		src.client.listen_ooc = !src.client.listen_ooc
		if (src.client.listen_ooc)
			src << "\blue You are now listening to messages on the OOC channel."
		else
			src << "\blue You are no longer listening to messages on the OOC channel."

/mob/verb/ooc(msg as text)
	if (!src.client.authenticated)
		src << "You are not authorized to communicate over these channels."
		return
	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return
	else if (!src.client.listen_ooc)
		return
	else if (!ooc_allowed && !src.client.holder)
		return
	else if (src.muted)
		return
	world.log_ooc("[src.name]/[src.key] : [msg]")

	for (var/mob/M in world)
		if (M.client && M.client.listen_ooc && !ooc_allowed)
			M << "<span class='ooc_title'>ADMIN: [src.key]:</span> <span class='ooc_text'>[msg]</span>"
		else if (M.client && M.client.listen_ooc)
			M << "<span class='ooc_title'>OOC: [src.key]:</span> <span class='ooc_text'>[msg]</span>"

