# Roles Module
Roles = {
	1 : "Prime Minister",
	2 : "Vice Minister",
	3 : "Secretary",
	4 : "Historian",
	5 : "Treasurer",
	6 : "Head of Engineering",
}

def getRole(rl):
	if type(rl) == str:
		rl = rl.lower()
		rc = rl[0:2]
		if rc == "pr":
			return Roles[1]

		if rc == "vi":
			return Roles[2]

		if rc == "se":
			return Roles[3]

		if rc == "hi":
			return Roles[4]

		if rc == "tr":
			return Roles[5]

		if rc == "he":
			return Roles[6]
		
	elif type(rl) == int:
		return Roles[rl]
	else:
		return None