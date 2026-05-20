import roles
import vote

class Election:
	def __init__(self,r = 4):
		self.rounds = r
		self.List = {
			Roles[1]: [],
			Roles[2]: [],
			Roles[3]: [],
			Roles[4]: [],
			Roles[5]: [],
			Roles[6]: [],
		}

	def setRounds(self,r = 4):
		self.rounds = r

	def newBid(self,n,r):
		R = getRole(r)
		if not(R == None) and not(n == None):
			for i in self.List[R]:
				if i["name"].lower() == n.lower():
					return	# no duplicate bids
			
			self.List[R].append({"name": n, "votes": Vote(self.rounds), "running": True})

	def nthChoiceVote(self,name,role,nth):
		R = getRole(role)
		if not(R == None) and not(name == None):
			for i in self.List[R]:
				if i["name"].lower() == name.lower():
					i["votes"].vote(nth)
		else:
			pass # invalid vote

	def roundSummary(self,round):
		if round > self.rounds:
			return	# Invalid round
		
		for role in self.List:
			sums = []
			total = 0
			for i in self.List[role]:
				if i["running"]:
					total = total + i["votes"].sum(round)
					sums.append({"n": i["name"], "v": i["votes"].sum(round)})
			for i in sums:
				print(f'{i["n"]}: {i["v"]} | {i["v"]/total}')

	def drop(self,name,role):
		R = getRole(role)
		if not(R == None) and not(name == None):
			for i in self.List[R]:
				if i["name"].lower() == name.lower():
					i["running"] = False
		else:
			pass # invalid drop

	def pickup(self,name,role):
		R = getRole(role)
		if not(R == None) and not(name == None):
			for i in self.List[R]:
				if i["name"].lower() == name.lower():
					i["running"] = True
		else:
			pass # invalid pickup
