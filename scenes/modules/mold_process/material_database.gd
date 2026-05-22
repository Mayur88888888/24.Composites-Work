extends Node


var materials = {

	"Epoxy": {
		"density": 1200,
		"specific_heat": 1400,
		"cure_temp": 140
	},

	"Phenolic": {
		"density": 1350,
		"specific_heat": 1600,
		"cure_temp": 160
	},

	"SMC": {
		"density": 1900,
		"specific_heat": 1100,
		"cure_temp": 150
	}
}



func get_material(material_name):

	if materials.has(material_name):

		return materials[material_name]

	return null
