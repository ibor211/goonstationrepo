var
	jobban_bannedmsg="<font color=red><big><tt>You have been banned from doing this job</tt></big></font>"
	jobban_runonce	// Updates legacy bans with new info
	jobban_keylist[0]		//to store the keys
	jobban_rank[0]		//to store the banned jobs for each key

/client/proc/showban()
	set category = "Debug"
	world <<	"JOBBANS<br>"
	for(var/t in jobban_keylist)
		world << "[t]<br>"
	world << "<br> BREAK <br>"
	for(var/f in jobban_rank)
		world << "[f]<br>"

/proc/jobban_fullban(mob/M, rank)
	if (!M || !M.key || !M.client) return
	if(!jobban_keylist.Find(M.ckey))
//		jobban_keylist.Add(M.ckey)
		jobban_rank[M.ckey] = rank
		jobban_keylist.Add(jobban_rank[M.ckey])
//	jobban_rank[M.ckey] += rank
//	jobban_keylist[M.ckey] += jobban_rank[rank]
//	jobban_rank[rank] += jobban_keylist[M.ckey]
	jobban_savebanfile()

/proc/jobban_isbanned(mob/M, rank)
//	if (jobban_rank[rank] in jobban_keylist[M.ckey])
	if (rank in jobban_keylist)//(M.ckey))
		return 1
	else
		return 0


/*
/proc/jobban_key(key as text,rank as text)
	var/ckey=ckey(key)
	if(!jobban_rank.Find(ckey, rank))
		jobban_rank.Add(ckey, rank)
		jobban_rank[M.ckey] = banner

	var/ckey=ckey(key)
	if (!crban_keylist.Find(ckey))
		crban_keylist.Add(ckey)
	jobban_keylist[ckey] = rank

	if(!crban_reason.Find(M.ckey))
		crban_reason.Add(M.ckey)
		crban_reason[M.ckey] = reason
*/


/proc/jobban_loadbanfile()
	var/savefile/S=new("data/job_full.ban")
	S["job[0]"] >> jobban_rank
	world.log_admin("Loading jobban_rank")
	S["keys[0]"] >> jobban_keylist
	world.log_admin("Loading jobban_rank")
	S["runonce"] >> jobban_runonce
	if (!length(jobban_rank))
		jobban_rank = list()
		world.log_admin("jobban_rank was empty")
	if (!length(jobban_keylist))
		jobban_keylist=list()
		world.log_admin("jobban_keylist was empty")

/proc/jobban_savebanfile()
	var/savefile/S=new("data/job_full.ban")
	S["job[0]"] << jobban_rank
	S["keys[0]"] << jobban_keylist

/proc/jobban_unban(key, rank)
	var/ckey = ckey(key)
	jobban_rank.Remove(rank, ckey)

/proc/jobban_updatelegacybans()
	if(!jobban_runonce)
		world.log_admin("Updating jobbanfile!")
		// Updates bans.. Or fixes them. Either way.
		for(var/T in jobban_rank)
			if(!T)	continue
		jobban_runonce++	//don't run this update again

/*
/proc/jobban_key(key as text,address as text)
	var/ckey=ckey(key)
	crban_unbanned.Remove(ckey)
	if (!crban_keylist.Find(ckey))
		crban_keylist.Add(ckey)
	crban_keylist[ckey] = address*/