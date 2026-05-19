function PrintTbl(tbl,name)
	name = name or "top"
	for key, value in pairs(tbl) do
		if type(value) == "table" then
			print(name.."."..key..":")
			PrintTbl(value,"\t"..name.."."..key)
		else
			print(name.."."..key.." = "..tostring(value))
		end
	end
end

Roles = {
	[1] = "Prime Minister",
	[2] = "Vice Minister",
	[3] = "Secretary",
	[4] = "Historian",
	[5] = "Treasurer",
	[6] = "Head of Engineering",
}

function Roles.get(rl)
	if type(rl) == "string" then
		rl = string.lower(rl)
		if rl:sub(1,2) == "pr" then
			return Roles[1]
		end

		if rl:sub(1,2) == "vi" then
			return Roles[2]
		end

		if rl:sub(1,2) == "se" then
			return Roles[3]
		end

		if rl:sub(1,2) == "hi" then
			return Roles[4]
		end

		if rl:sub(1,2) == "tr" then
			return Roles[5]
		end

		if rl:sub(1,2) == "he" then
			return Roles[6]
		end
	elseif type(rl) == "number" then
		return Roles[rl]
	else
		return nil
	end
end

Vote = {}
Vote.ranks = 1
Vote.tally = {}

function Vote.new(n)
	local tbl = {
		ranks = n or 1,
		tally = {},
	}

	Vote.clearTally(tbl)

	return setmetatable(tbl, {__index = Vote, __call = Vote.vote})
end

function Vote:clearTally()
	for i = 1,self.ranks do
		self.tally[i] = 0
	end
end

function Vote:vote(r)
	if (r > 0) and (r <= self.ranks) then
		self.tally[r] = self.tally[r] + 1
	else
		-- invalid vote
	end
end

function Vote:sum(round)
	local sum = 0
	if round > self.ranks then
		return -1 -- Invalid Round
	end
	for i = 1,round do
		sum = sum + self.tally[i]
	end
	return sum
end

Election = {}
Election.rounds = 4
Election.List = {}
Election.List[Roles[1]] = {}
Election.List[Roles[2]] = {}
Election.List[Roles[3]] = {}
Election.List[Roles[4]] = {}
Election.List[Roles[5]] = {}
Election.List[Roles[6]] = {}

function Election.setRounds(r)
	Election.rounds = tonumber(r) or 4
end

function Election.newBid(n,r)
	local R = Roles.get(r)
	if R and n then
		for i,v in pairs(Election.List[R]) do
			if string.lower(v.name) == string.lower(n) then
				return	-- no duplicate bids
			end
		end

		table.insert(Election.List[R],{name = n, votes = Vote.new(Election.rounds), running = true})
	else
		-- invalid bid
	end
end

function Election.nthChoiceVote(name,role,nth)
	local R = Roles.get(role)
	if R and name then
		for i,v in pairs(Election.List[R]) do
			if string.lower(v.name) == string.lower(name) then
				v.votes:vote(nth)
			end
		end
	else
		-- invalid vote
	end
end

function Election.roundSummary(round)
	if round > Election.rounds then
		return -- Invalid round
	end
	for _,role in pairs(Election.List) do
		local sums = {}
		local total = 0
		for i,v in pairs(role) do
			if v.running then
				total = total + v.votes:sum(round)
				table.insert(sums,{n = v.name,v = v.votes:sum(round)})
			end
		end

		for i,v in pairs(sums) do
			print(v.n..": "..string.format("%d",v.v).." | "..string.format("%.3f",v.v/total))
			-- print(v.n,v.v,v.v/total)
		end
	end
end

function Election.drop(name,role)
	local R = Roles.get(role)
	if R and name then
		for i,v in pairs(Election.List[R]) do
			if string.lower(v.name) == string.lower(name) then
				v.running = false
			end
		end
	else
		-- invalid drop
	end
end

function Election.pickup(name,role)
	local R = Roles.get(role)
	if R and name then
		for i,v in pairs(Election.List[R]) do
			if string.lower(v.name) == string.lower(name) then
				v.running = true
			end
		end
	else
		-- invalid pickup
	end
end

Election.newBid("Fred","Pres")
Election.newBid("Bill","Pres")
Election.newBid("John","Pres")
Election.newBid("Eric","Pres")
Election.newBid("Greg","Pres")

Election.nthChoiceVote("Bill","Pres",1)
Election.nthChoiceVote("John","Pres",2)
Election.nthChoiceVote("Fred","Pres",3)
Election.nthChoiceVote("Eric","Pres",4)

Election.nthChoiceVote("John","Pres",1)
Election.nthChoiceVote("Bill","Pres",2)
Election.nthChoiceVote("Eric","Pres",3)
Election.nthChoiceVote("Fred","Pres",4)

Election.nthChoiceVote("Fred","Pres",1)
Election.nthChoiceVote("Bill","Pres",2)
Election.nthChoiceVote("Greg","Pres",3)
Election.nthChoiceVote("Fred","Pres",4)

PrintTbl(Election,"Election")

print("Round 1\n-------")
Election.roundSummary(1)
Election.drop("Eric","Pres")
Election.drop("Greg","Pres")

print("\nRound 2\n-------")
Election.roundSummary(2)
Election.drop("Fred","Pres")

print("\nRound 3\n-------")
Election.roundSummary(3)
