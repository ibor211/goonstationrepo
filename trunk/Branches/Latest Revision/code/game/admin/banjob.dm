var
	jobban_bannedmsg="<font color=red><big><tt>You have been banned from doing this job</tt></big></font>"
	jobban_preventbannedclients = 0 // Don't enable this, it'll throw null runtime errors due to the convolted way ss13 logs you in
	jobban_keylist[0]  // Banned keys and their associated IP addresses
	jobban_rank[0][0]
	jobban_runonce	// Updates legacy bans with new info

/proc/jobban_fullban(mob/M, rank)
	if (!M || !M.key || !M.client) return
	jobban_key(M.ckey, rank)			//does this work? I have no idea!
	jobban_client(M.client)
	jobban_savebanfile()
	del M

/proc/jobban_client(client/C)
	var/F=C.Import()
	var/savefile/S = F ? new(F) : new()
	S["[ckey(world.url)]"]<<1
	C.Export(S)

/proc/jobban_key(key as text,rank as text)
	var/ckey=ckey(key)
	if (!jobban_keylist.Find(ckey))
		jobban_keylist.Add(ckey)
	jobban_rank.Add(rank, ckey)

/proc/jobban_isbanned(X, rank)
	if (istype(X,/mob)) X=X:ckey
	if (istype(X,/client)) X=X:ckey
	if ((rank && ckey(X)) in jobban_rank) return 1
	else return 0

/proc/jobban_loadbanfile()
	var/savefile/S=new("data/job_full.ban")
	S["key[0]"] >> jobban_keylist
	world.log_admin("Loading jobban_keylist")
	S["job[0]"] >> jobban_rank
	world.log_admin("Loading jobban_rank")
	S["runonce"] >> jobban_runonce
	if (!length(jobban_keylist))
		jobban_keylist=list()
		world.log_admin("jobban_keylist was empty")

/proc/jobban_savebanfile()
	var/savefile/S=new("data/job_full.ban")
	S["key[0]"] << jobban_keylist
	S["rank[0]"] << jobban_rank

/proc/jobban_unban(key, rank)
	var/ckey = ckey(key)
	jobban_rank.Remove(rank, ckey)

/proc/jobban_updatelegacybans()
	if(!jobban_runonce)
		world.log_admin("Updating jobbanfile!")
		// Updates bans.. Or fixes them. Either way.
		for(var/T in jobban_keylist)
			if(!T)	continue
		jobban_runonce++	//don't run this update again

/*
/proc/jobban_key(key as text,address as text)
	var/ckey=ckey(key)
	crban_unbanned.Remove(ckey)
	if (!crban_keylist.Find(ckey))
		crban_keylist.Add(ckey)







	crban_keylist[ckey] = address*/