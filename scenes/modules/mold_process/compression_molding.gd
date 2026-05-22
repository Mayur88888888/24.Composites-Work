extends Control

@onready var material_db = $MaterialDatabase

@onready var process_calc = $ProcessCalculator

@onready var thermal_solver = $ThermalSolver

@onready var cure_solver = $CureSolver

func _ready():

	print("Compression Molding Module Ready")

	update_results_defaults()



# =========================================================
# DEFAULT RESULTS
# =========================================================

func update_results_defaults():

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGrid/label_cycle_time.text = "--"

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGrid/label_peak_temp.text = "--"

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGrid/label_pressure.text = "--"

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGrid/label_cure.text = "--"

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGrid/label_energy.text = "--"

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/WarningsPanel/warnings_text.text = "System Ready..."



# =========================================================
# RUN SIMULATION
# =========================================================

func run_simulation():

	# -----------------------------------------------------
	# READ UI VALUES
	# -----------------------------------------------------

	var length_mm = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/PanelContainer/VBoxContainer/GridContainer/spin_length.value

	var width_mm = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/PanelContainer/VBoxContainer/GridContainer/spin_width.value

	var thickness_mm = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/PanelContainer/VBoxContainer/GridContainer/spin_thickness.value

	var heater_power = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/HeatingCoolingPanel/VBoxContainer/GridContainer/Heater_power.value

	var heating_rate = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/HeatingCoolingPanel/VBoxContainer/GridContainer/spin_heating_rate.value

	var ram_speed = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/HeatingCoolingPanel/VBoxContainer/GridContainer/spin_ram_speed.value

	var hold_time = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/HeatingCoolingPanel/VBoxContainer/GridContainer/spin_hold_time.value


	# -----------------------------------------------------
	# BASIC VALIDATION
	# -----------------------------------------------------

	if length_mm <= 0 or width_mm <= 0 or thickness_mm <= 0:

		show_warning("Invalid geometry dimensions")
		return


	# -----------------------------------------------------
	# ENGINEERING CALCULATIONS
	# -----------------------------------------------------

	#var volume_mm3 = (length_mm * width_mm * thickness_mm ) / 1000000000.0

	#var volume_m3 = process_calc.calculate_volume(
	#length_mm,
	#width_mm,
	#thickness_mm
#)

	var estimated_pressure = process_calc.calculate_pressure(ram_speed)

	var peak_temperature = thermal_solver.calculate_peak_temperature(
		25,
		heating_rate
		)

	var cycle_time = process_calc.calculate_cycle_time(
		hold_time,
		peak_temperature,
		heating_rate
		)

	var energy_used = process_calc.calculate_energy(
		heater_power,
		cycle_time
		)
		
		
	var degree_of_cure = cure_solver.calculate_degree_of_cure(
		peak_temperature,
		140
		)

	var cure_progression = cure_solver.get_cure_progression(
		degree_of_cure
		)

	var resin_state = cure_solver.get_resin_state(
		peak_temperature
		)

	var reaction_kinetics = cure_solver.get_reaction_kinetics(
		heating_rate
		)

	var cure_state = "COMPLETE"

	if peak_temperature < 120:

		cure_state = "UNDER CURED"


	# -----------------------------------------------------
	# UPDATE RESULTS UI
	# -----------------------------------------------------

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGrid/label_cycle_time.text = str(round(cycle_time)) + " sec"

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGrid/label_peak_temp.text = str(round(peak_temperature)) + " °C"

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGrid/label_pressure.text = str(round(estimated_pressure)) + " MPa"

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGrid/label_cure.text = cure_state

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGrid/label_energy.text = str(snapped(energy_used, 0.01)) + " Wh"


	# -----------------------------------------------------
	# STATUS MESSAGE
	# -----------------------------------------------------

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/WarningsPanel/warnings_text.text = \
	"Simulation Completed\n\n" + \
	"Cure Progression : " + cure_progression + "\n" + \
	"Resin State      : " + resin_state + "\n" + \
	"Degree of Cure   : " + str(snapped(degree_of_cure, 0.01)) + "\n" + \
	"Reaction Kinetics: " + reaction_kinetics
	print("Simulation Finished")



# =========================================================
# WARNING DISPLAY
# =========================================================

func show_warning(message):

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/WarningsPanel/warnings_text.text = message

	print(message)



# =========================================================
# RESET SIMULATION
# =========================================================

func reset_simulation():

	update_results_defaults()

	print("Simulation Reset")


func _on_button_4_pressed() -> void:
	run_simulation()


func _on_button_6_pressed() -> void:
	reset_simulation()
