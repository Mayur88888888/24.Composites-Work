extends Node


func calculate_degree_of_cure(peak_temp, cure_temp):

	var alpha = peak_temp / cure_temp

	alpha = clamp(alpha, 0.0, 1.0)

	return alpha



func get_cure_progression(alpha):

	if alpha < 0.2:
		return "Initial Cure"

	elif alpha < 0.6:
		return "Active Cure"

	elif alpha < 0.95:
		return "Advanced Cure"

	return "Fully Cured"



func get_resin_state(peak_temp):

	if peak_temp < 80:
		return "Solid"

	elif peak_temp < 140:
		return "Softening"

	elif peak_temp < 180:
		return "Flowing"

	return "Hardened"



func get_reaction_kinetics(heating_rate):

	if heating_rate < 2:
		return "Slow Reaction"

	elif heating_rate < 5:
		return "Moderate Reaction"

	return "Fast Reaction"
