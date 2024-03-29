/var/const/SHARED_TYPES_WEIGHT = 5
/var/const/CAMERA_PROXIMITY_PREFERENCE = 0.2
// the smaller this is, the more a straight line will be preferred over a closer camera when changing cameras
// if you set this to 0 the game will crash. don't do that.
// if you set it to be negative the algorithm will do completely nonsensical things (like choosing the camera that's
// the farthest away). don't do that.

/client/proc/AIMove(n,direct,var/mob/ai/user)
	if(!user) return

	var/min_dist = 1e8
	var/obj/machinery/camera/closest = null
	var/atom/old = (user.current?user.current : user.loc)

	if(!old) return

	var/dx = 0
	var/dy = 0
	if(direct & NORTH)
		dy = 1
	else if(direct & SOUTH)
		dy = -1
	if(direct & EAST)
		dx = 1
	else if(direct & WEST)
		dx = -1


	var/area/A = get_area(old)
	var/list/old_types = dd_text2list("[A.type]", "/")

	for(var/obj/machinery/camera/current in world)
		if(user.network != current.network)
			continue	//	different network (syndicate)
		if(ticker.mode.name == "AI malfunction")
			if(current.z != user.z && (user.network != "Prison") && (user.network != "SS13"))
				continue
		else
			if(current.z != user.z && (user.network != "Prison") && (user.network != "AI Satellite"))
				continue	//	different viewing plane
		if(!current.status)
			continue	//	ignore disabled cameras

		//make sure it's the right direction
		if(dx && (current.x * dx <= old.x * dx))
			continue
		if(dy && (current.y * dy <= old.y * dy))
			continue

		var/shared_types = 0 //how many levels deep the old camera and the closest camera's areas share
		//for instance, /area/A and /area/B would have shared_types = 2 (because of how dd_text2list works)
		//whereas area/A/B and /area/A/C would have it as 3

		var/area/cur_area = get_area(current)
		var/list/new_types = dd_text2list("[cur_area.type]", "/")
		for(var/i = 1; i <= old_types.len && i <= new_types.len; i++)
			if(old_types[i] == new_types[i])
				shared_types++
			else
				break

		//don't let it be too far from the current one in the axis perpindicular to the direction of travel,
		//but let it be farther from that if it's in the same area
		//something in the same hallway but farther away beats something in the same hallway

		var/distance = abs((current.y - old.y)/(CAMERA_PROXIMITY_PREFERENCE + abs(dy))) + abs((current.x - old.x)/(CAMERA_PROXIMITY_PREFERENCE + abs(dx)))
		distance -= SHARED_TYPES_WEIGHT * shared_types
		//weight things in the same area as this so they count as being closer - makes you stay in the same area
		//when possible

		if(distance < min_dist)
			//closer, or this is in the same area and the current closest isn't
			min_dist = distance
			closest = current

	if(!closest)
		return
	user.switchCamera(closest)
