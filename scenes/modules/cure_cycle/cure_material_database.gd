extends Node


var cure_materials = {

	"Epoxy Resin": {
		"cure_temp": 140,
		"cure_time": 45,
		"heating_rate": 3.0,
		"cooling_rate": 2.0,
		"max_temp": 160
	},

	"Phenolic Resin": {
		"cure_temp": 180,
		"cure_time": 60,
		"heating_rate": 2.0,
		"cooling_rate": 1.5,
		"max_temp": 220
	},

	"Polyester Resin": {
		"cure_temp": 120,
		"cure_time": 35,
		"heating_rate": 4.0,
		"cooling_rate": 2.5,
		"max_temp": 140
	},

	"Carbon Epoxy": {
		"cure_temp": 160,
		"cure_time": 90,
		"heating_rate": 2.5,
		"cooling_rate": 1.0,
		"max_temp": 180
	},

	"Glass Fiber Epoxy": {
		"cure_temp": 150,
		"cure_time": 70,
		"heating_rate": 2.5,
		"cooling_rate": 1.2,
		"max_temp": 170
	},

	"Rubber Compound": {
		"cure_temp": 110,
		"cure_time": 25,
		"heating_rate": 5.0,
		"cooling_rate": 3.0,
		"max_temp": 130
	}
}



#func get_material(name):

	#return cure_materials[name]
