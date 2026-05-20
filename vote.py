# vote class
class Vote:
	def __init__(self, n = 1):
		self.ranks = n
		self.tally = []
		for i in range(0,self.ranks):
			self.tally.append(0)
	
	def clearTally(self):
		for i in range(0,self.ranks):
			self.tally[i + 1] = 0
	
	def vote(self, r = 1):
		if (r > 0) and (r <= self.ranks):
			self.tally[r - 1] = self.tally[r - 1] + 1
		else:
			pass #invalid vote
	
	def sum(self, round):
		sum = 0
		if round > self.ranks:
			return -1
		for i in range(0,round):
			sum = sum + self.tally[i]
		return sum
