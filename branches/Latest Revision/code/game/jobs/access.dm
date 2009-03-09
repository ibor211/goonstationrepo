/var/const
	access_security = 1
	access_brig = 2
	access_security_lockers = 3
	access_forensics_lockers= 4
	access_security_records = 5
	access_medical_supplies = 6
	access_medical_records = 7
	access_morgue = 8
	access_tox = 9
	access_tox_storage = 10
	access_medlab = 11
	access_engine = 12
	access_eject_engine = 13
	access_maint_tunnels = 14
	access_external_airlocks = 15
	access_emergency_storage = 16
	access_apcs = 17
	access_change_ids = 18
	access_ai_upload = 19
	access_teleporter = 20
	access_eva = 21
	access_heads = 22
	access_captain = 23
	access_all_personal_lockers = 24
	access_chapel_office = 25
	access_tech_storage = 26
	access_atmospherics = 27
	access_bar = 28
	access_janitor = 29
	access_disposal_units = 30
/obj/var/list/req_access = null
/obj/var/req_access_txt = "0"
/obj/New()
	if(src.req_access_txt)
		var/req_access_str = params2list(req_access_txt)
		var/req_access_changed = 0
		for(var/x in req_access_str)
			var/n = text2num(x)
			if(n)
				if(!req_access_changed)
					req_access = list()
				req_access += n
	..()

//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return 1
	if(istype(M, /mob/ai))
		//AI can do whatever he wants
		return 1
	else if(istype(M, /mob/human))
		var/mob/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(src.check_access(H.equipped()) || src.check_access(H.wear_id))
			return 1
	else if(istype(M, /mob/monkey))
		var/mob/monkey/george = M
		//they can only hold things :(
		if(george.equipped() && istype(george.equipped(), /obj/item/weapon/card/id) && src.check_access(george.equipped()))
			return 1
	return 0

/obj/proc/check_access(obj/item/weapon/card/id/I)
	if(!src.req_access) //no requirements
		return 1
	if(!istype(src.req_access, /list)) //something's very wrong
		return 1

	var/list/L = src.req_access
	if(!L.len) //no requirements
		return 1
	if(!I || !istype(I, /obj/item/weapon/card/id) || !I.access) //not ID or no access
		return 0
	for(var/req in src.req_access)
		if(!(req in I.access)) //doesn't have this access
			return 0
	return 1

/proc/get_access(job)
	switch(job)
		if("Genetic Researcher")
			return list(access_medical_supplies, access_morgue, access_medlab)
		if("Station Engineer")
			return list(access_engine, access_eject_engine, access_apcs, access_tech_storage, access_maint_tunnels, access_external_airlocks)
		if("Assistant")
			return list(access_maint_tunnels)
		if("Chaplain")
			return list(access_morgue, access_chapel_office)
		if("Forensic Technician")
			return list(access_security, access_forensics_lockers, access_morgue, access_security_records)
		if("Medical Doctor")
			return list(access_medical_supplies, access_morgue, access_medical_records)
		if("Captain")
			return get_all_accesses()
		if("Security Officer")
			return list(access_security, access_brig, access_security_lockers, access_security_records)
		if("Toxin Researcher")
			return list(access_tox, access_tox_storage)
		if("Head of Research")
			return list(access_medical_supplies, access_morgue, access_tox, access_tox_storage, access_medlab,
			            access_teleporter, access_heads, access_tech_storage, access_security, access_atmospherics,
			            access_maint_tunnels, access_bar, access_janitor, access_disposal_units)
		if("Head of Personnel")
			return list(access_security, access_brig, access_security_lockers, access_forensics_lockers,
						access_security_records, access_tox, access_tox_storage, access_medlab, access_engine,
						access_emergency_storage, access_change_ids, access_ai_upload, access_eva, access_heads,
						access_all_personal_lockers, access_tech_storage, access_maint_tunnels, access_bar, access_janitor, access_disposal_units)
		if("Atmospheric Technician")
			return list(access_atmospherics, access_maint_tunnels, access_emergency_storage)
		if("Barman")
			return list(access_bar)
		if("Chemist")
			return list(access_medical_supplies, access_morgue, access_medlab)
		if("Janitor")
			return list(access_janitor, access_disposal_units)
		else
			return list()

/proc/get_all_accesses()
	return list(access_security, access_brig, access_security_lockers, access_forensics_lockers,
	            access_security_records, access_medical_supplies, access_medical_records, access_morgue, access_tox,
	            access_tox_storage, access_medlab, access_engine, access_eject_engine, access_maint_tunnels,
	            access_external_airlocks, access_emergency_storage, access_apcs, access_change_ids, access_ai_upload,
	            access_teleporter, access_eva, access_heads, access_captain, access_all_personal_lockers,
	            access_tech_storage, access_chapel_office, access_atmospherics, access_bar, access_janitor, access_disposal_units)

/proc/get_access_desc(A)
	switch(A)
		if(access_security)
			return "access security"
		if(access_brig)
			return "access the brig"
		if(access_security_lockers)
			return "open security lockers"
		if(access_forensics_lockers)
			return "open forensics lockers"
		if(access_security_records)
			return "access security records"
		if(access_medical_supplies)
			return "access medical supplies"
		if(access_medical_records)
			return "access medical records"
		if(access_morgue)
			return "access the morgue"
		if(access_tox)
			return "access toxins"
		if(access_bar)
			return "access bar"
		if(access_janitor)
			return "access custodial closet"
		if(access_disposal_units)
			return "access disposal units"
		if(access_tox_storage)
			return "access toxins storage"
		if(access_medlab)
			return "access medlab"
		if(access_engine)
			return "access the engine"
		if(access_eject_engine)
			return "eject the engine"
		if(access_maint_tunnels)
			return "access maintenance tunnels"
		if(access_external_airlocks)
			return "open external airlocks"
		if(access_emergency_storage)
			return "access emergency storage"
		if(access_apcs)
			return "access APCs"
		if(access_change_ids)
			return "change ID cards"
		if(access_ai_upload)
			return "access the AI upload"
		if(access_teleporter)
			return "access the teleporter"
		if(access_eva)
			return "access EVA storage"
		if(access_heads)
			return "access the heads' quarters"
		if(access_captain)
			return "access the captain's quarters"
		if(access_all_personal_lockers)
			return "open all personal lockers"
		if(access_chapel_office)
			return "access the chapel office"
		if(access_tech_storage)
			return "access technical storage"
		if(access_atmospherics)
			return "access atmospherics"

/proc/get_all_jobs()
	return list("Assistant", "Station Engineer", "Forensic Technician", "Medical Doctor", "Captain", "Security Officer", "Genetic Researcher", "Toxin Researcher", "Head of Research", "Head of Personnel", "Atmospheric Technician", "Chaplain", "Barman", "Chemist", "Janitor")

