extends Node


func calculate_peak_temperature(initial_temp, heating_rate):

	return initial_temp + heating_rate * 3.0



func evaluate_cure_state(peak_temp, cure_temp):

	if peak_temp >= cure_temp:

		return "COMPLETE"

	return "UNDER CURED"
