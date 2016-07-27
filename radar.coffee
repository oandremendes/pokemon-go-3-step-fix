###
  Pokemon Go (c) ManInTheMiddle Radar "mod"
  Michael Strassburger <codepoet@cpan.org>

  Fixes Nearby Pokemon "3 Step Glitch"
###

PokemonGoMITM = require './lib/pokemon-go-mitm'
changeCase = require 'change-case'
moment = require 'moment'
LatLon = require('geodesy').LatLonSpherical
exec = require("sync-exec")

mysql = require('mysql')
connection = mysql.createConnection(
  host: 'localhost'
  user: 'YOUR_USER_HERE'
  password: 'YOUR_PASSWORD_HERE'
  database: 'pogo')

pokemons = []
currentLocation = null

server = new PokemonGoMITM port: 8081
	# Fetch our current location as soon as it gets passed to the API
	.addRequestHandler "GetMapObjects", (data) ->
		currentLocation = new LatLon data.latitude, data.longitude
		console.log "[+] Current position of the player #{currentLocation}"
		false

	# Parse the wild pokemons nearby
	.addResponseHandler "GetMapObjects", (data) ->
		pokemons = []
		seen = {}
		addPokemon = (pokemon) ->
			return if seen[hash = pokemon.spawnpoint_id + ":" + pokemon.pokemon_data.pokemon_id]
			return if pokemon.expiration_timestamp_ms < 0

			seen[hash] = true
			pokemons.push
				type: pokemon.pokemon_data.pokemon_id
				latitude: pokemon.latitude
				longitude: pokemon.longitude
				expirationMs: pokemon.time_till_hidden_ms
				data: pokemon.pokemon_data
				encID: pokemon.encounter_id
		for cell in data.map_cells
			addPokemon pokemon for pokemon in cell.wild_pokemons
			if pokemons.length
				for pokemon in pokemons
					pokemonInfo(pokemon)
					console.log "Pokemon found: ", pokemon.type, " encID = ", pokemon.encID, "\n"
			for nearby in cell.nearby_pokemons
				com = "php radar.php "
				command = com.concat(nearby.encounter_id)
				position = exec command
				positionStr = position.stdout
				array = positionStr.split ","
				latitude = array[0]
				longitude = array[1]
				if latitude != "error"
					pokeLocation = new LatLon latitude, longitude
					dist = Math.floor currentLocation.distanceTo pokeLocation
					nearby.distance_in_meters = dist
					console.log "Wild Pokemon ", nearby.pokemon_id, " is ", dist, "m away!\n"
		data

the_interval = 60 * 1000
setInterval (->
	console.log "Refreshing Db\n"
	d = (new Date).getTime()
	connection.query("DELETE FROM nearby WHERE expirationMs < ?", d)
	return
), the_interval

pokemonInfo = (pokemon) ->
	type = changeCase.titleCase pokemon.data.pokemon_id
	position = new LatLon pokemon.latitude, pokemon.longitude
	latitude = pokemon.latitude
	longitude = pokemon.longitude
	dist = Math.floor currentLocation.distanceTo position
	bearing = currentLocation.bearingTo position
	enc = pokemon.encID
	time = (new Date).getTime() + pokemon.expirationMs
	direction = switch true
		when bearing>330 then "N"
		when bearing>285 then "NW"
		when bearing>240 then "W"
		when bearing>195 then "SW"
		when bearing>150 then "S"
		when bearing>105 then "SE"
		when bearing>60 then "E"
		when bearing>15 then "NE"
		else "N"
	dbquery = 'INSERT IGNORE INTO nearby (type, encounterID, latitude, longitude, expirationMs) VALUES ("'
	runquery = dbquery.concat(type, '", "', enc, '", "', latitude, '", "', longitude, '", ', time, ')')
	connection.query(runquery)
	console.log "Putting ", type, " in Db.\n"
