extends Node


func calculate_volume(length_mm, width_mm, thickness_mm):

	var volume_mm3 = length_mm * width_mm * thickness_mm

	return volume_mm3 / 1000000000.0



func calculate_cycle_time(hold_time, peak_temperature, heating_rate):

	return hold_time + (peak_temperature / heating_rate)



func calculate_energy(heater_power, cycle_time):

	return heater_power * cycle_time / 3600.0



func calculate_pressure(ram_speed):

	return ram_speed * 2.5
