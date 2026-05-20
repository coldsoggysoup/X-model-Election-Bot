import discord
import election

misc_gifs = [
	"https://media.discordapp.net/attachments/735670248715583528/1118571965821747280/angry_goober.gif",
	"https://media.discordapp.net/attachments/805848605922820126/962846359088664596/IMG_7736.gif",
	"https://tenor.com/view/scuba-cat-scuba-cat-kitten-cute-gif-6808830743234487843",
	"https://tenor.com/view/get-real-diary-of-a-wimpy-kid-gif-19457757",
]

tok = str(open('tok.txt').read())
intents = discord.Intents.default()
intents.message_content = True

client = discord.Client(intents=intents)

@client.event
async def on_ready():
	print(f'Logged in as {client.user}')

@client.event
async def on_message(message):
	if message.author == client.user:
		return

	if message.content.startswith('$hello'):
		await message.channel.send('Hello!')
	
	if message.content.startswith('$echo '):
		await message.channel.send(message.content[6:])
	
	if message.content.startswith('$echod '):
		await message.delete()
		await message.channel.send(message.content[6:])

client.run(tok)
