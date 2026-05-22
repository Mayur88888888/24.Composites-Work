extends Control

# =========================================================
# UI REFERENCES
# =========================================================

@onready var initial_temp = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/HBoxContainer2/InitialTempInput
@onready var heater_temp = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/HBoxContainer2/HeaterTempInput
@onready var watt_input = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/HBoxContainer2/Wattage

@onready var sim_time = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/SimulationTimeRow/SimulationTimeInput

@onready var run_button = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/ControlButtons/RunButton
@onready var stop_button = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/ControlButtons/StopButton
@onready var cancel_button = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/ControlButtons/CancelButton

@onready var length_input = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/LengthRow/LengthInput
@onready var width_input = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/WidthRow/WidthInput
@onready var thickness_input = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/HeightRow/HeightInput

@onready var result_label = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/ResultLabel

@onready var heat_bar_container = $MainContainer/MainSplit/ViewportPanel/MarginContainer/ViewportContent/SimulationView/HeatBarContainer

@onready var material_selector = $MainContainer/MainSplit/ParameterPanel/MarginContainer/ParameterScroll/ParameterContent/HBoxContainer/MaterialSelector

@onready var sim_timer = $SimulationTimer


# =========================================================
# SIMULATION VARIABLES
# =========================================================

var temperatures = []

var node_count = 20

var current_time = 0.0

var dt = 0.1

var running = false

var simulation_speed = 50.0

var estimated_total_time = 0.0


# =========================================================
# MATERIAL DATABASE
# =========================================================

var material_database = {

	"Steel": {
		"density": 7850.0,
		"cp": 500.0,
		"diffusivity": 0.06
	},

	"Aluminum": {
		"density": 2700.0,
		"cp": 900.0,
		"diffusivity": 0.14
	},

	"Copper": {
		"density": 8960.0,
		"cp": 385.0,
		"diffusivity": 0.20
	},

	"Titanium": {
		"density": 4500.0,
		"cp": 520.0,
		"diffusivity": 0.03
	}
}


# =========================================================
# READY
# =========================================================

func _ready():

	run_button.pressed.connect(run_simulation)

	stop_button.pressed.connect(stop_simulation)

	cancel_button.pressed.connect(cancel_simulation)

	sim_timer.timeout.connect(simulation_step)

	sim_timer.wait_time = dt

	create_heat_bars()

	reset_temperature_bars()

	result_label.text = "Ready"


# =========================================================
# RUN SIMULATION
# =========================================================

func run_simulation():

	# =====================================================
	# ALWAYS READ FRESH VALUES FROM UI
	# =====================================================

	var block_length = float(length_input.value)
	var block_width = float(width_input.value)
	var block_thickness = float(thickness_input.value)

	var ambient_temperature = float(initial_temp.value)
	var heater_temperature = float(heater_temp.value)

	var heater_power = float(watt_input.value)

	var selected_material = material_selector.get_item_text(
		material_selector.selected
	)

	var mat = material_database[selected_material]

	var density = mat["density"]

	var specific_heat = mat["cp"]

	var thermal_diffusivity = mat["diffusivity"]


	# =====================================================
	# VALIDATION
	# =====================================================

	if heater_temperature <= ambient_temperature:

		result_label.text = "Heater Temp must exceed Plate Temp"

		return


	if heater_power <= 0:

		result_label.text = "Invalid Wattage"

		return


	# =====================================================
	# RESET SIMULATION
	# =====================================================

	current_time = 0.0

	temperatures.clear()

	for i in range(node_count):

		temperatures.append(
			ambient_temperature
		)


	# =====================================================
	# ENGINEERING CALCULATIONS
	# =====================================================

	# Convert mm → meters
	var length_m = block_length / 1000.0
	var width_m = block_width / 1000.0
	var thickness_m = block_thickness / 1000.0


	# Total plate volume
	var total_volume = (
		length_m *
		width_m *
		thickness_m
	)


	# Plate mass
	var mass = (
		total_volume * density
	)


	# Temperature rise required
	var delta_required = (
		heater_temperature -
		ambient_temperature
	)


	# Required energy
	var required_energy = (
		mass *
		specific_heat *
		delta_required
	)


	# Estimated heating time
	estimated_total_time = (
		required_energy /
		heater_power
	)


	# =====================================================
	# DEBUG
	# =====================================================

	print("=================================")

	print("MATERIAL =", selected_material)

	print("Length =", block_length)

	print("Width =", block_width)

	print("Thickness =", block_thickness)

	print("Volume =", total_volume)

	print("Mass =", mass)

	print("Power =", heater_power)

	print("Estimated Time =", estimated_total_time)

	print("=================================")


	# =====================================================
	# STORE RUNTIME DATA
	# =====================================================

	set_meta("length_m", length_m)

	set_meta("width_m", width_m)

	set_meta("thickness_m", thickness_m)

	set_meta("ambient_temperature", ambient_temperature)

	set_meta("heater_temperature", heater_temperature)

	set_meta("heater_power", heater_power)

	set_meta("density", density)

	set_meta("specific_heat", specific_heat)

	set_meta("thermal_diffusivity", thermal_diffusivity)


	running = true

	sim_timer.start()

	update_visualization()


# =========================================================
# SIMULATION STEP
# =========================================================

func simulation_step():

	if not running:
		return


	var heater_temperature = get_meta("heater_temperature")

	#var ambient_temperature = get_meta("ambient_temperature")

	var heater_power = get_meta("heater_power")

	var density = get_meta("density")

	var specific_heat = get_meta("specific_heat")

	var thermal_diffusivity = get_meta("thermal_diffusivity")

	var length_m = get_meta("length_m")

	var width_m = get_meta("width_m")

	var thickness_m = get_meta("thickness_m")


	var new_temps = temperatures.duplicate()


	# =====================================================
	# SEGMENT VOLUME
	# =====================================================

	var total_volume = (
		length_m *
		width_m *
		thickness_m
	)

	var segment_volume = (
		total_volume / node_count
	)

	var segment_mass = (
		segment_volume * density
	)


	# =====================================================
	# HEAT INPUT
	# =====================================================

	var energy_input = (
		heater_power *
		dt *
		simulation_speed
	)


	var delta_temp = (
		energy_input /
		(segment_mass * specific_heat)
	)


	# =====================================================
	# APPLY HEAT TO FIRST SEGMENT
	# =====================================================

	new_temps[0] += delta_temp

	new_temps[0] = min(
		new_temps[0],
		heater_temperature
	)


	# =====================================================
	# THERMAL DIFFUSION
	# =====================================================

	var alpha = thermal_diffusivity * 0.02

	alpha = clamp(alpha, 0.001, 0.05)


	for i in range(1, node_count - 1):

		new_temps[i] = temperatures[i] + alpha * (

			temperatures[i - 1] +

			temperatures[i + 1] -

			2.0 * temperatures[i]
		)


	# Clamp temperatures
	for i in range(node_count):

		new_temps[i] = min(
			new_temps[i],
			heater_temperature
		)


	temperatures = new_temps


	current_time += (
		dt * simulation_speed
	)


	update_visualization()


	# =====================================================
	# AUTO STOP
	# =====================================================

	var avg_temp = get_average_temperature()


	if avg_temp >= heater_temperature * 0.98:

		running = false

		sim_timer.stop()

		result_label.text = "Plate Fully Heated"

		return


	if current_time >= sim_time.value:

		running = false

		sim_timer.stop()

		result_label.text = "Simulation Complete"


# =========================================================
# VISUALIZATION
# =========================================================

func update_visualization():

	if temperatures.is_empty():
		return


	var ambient_temperature = get_meta("ambient_temperature")

	var heater_temperature = get_meta("heater_temperature")


	for i in range(node_count):

		var temp = temperatures[i]

		var normalized = clamp(

			(temp - ambient_temperature) /

			(heater_temperature - ambient_temperature),

			0.0,
			1.0
		)

		var rect = heat_bar_container.get_child(i)

		rect.color = Color(
			normalized,
			0.0,
			1.0 - normalized
		)


	var avg_temp = get_average_temperature()


	result_label.text = (

		"Time: %.1f s | Avg Temp: %.1f °C | Est Time: %.1f s"

		% [

			current_time,

			avg_temp,

			estimated_total_time
		]
	)


# =========================================================
# AVG TEMPERATURE
# =========================================================

func get_average_temperature():

	if temperatures.is_empty():
		return 0.0


	var total = 0.0


	for temp in temperatures:

		total += float(temp)


	return total / temperatures.size()


# =========================================================
# CREATE HEAT BARS
# =========================================================

func create_heat_bars():

	for child in heat_bar_container.get_children():

		child.queue_free()


	for i in range(node_count):

		var rect = ColorRect.new()

		rect.custom_minimum_size = Vector2(12, 80)

		rect.color = Color.BLUE

		heat_bar_container.add_child(rect)


# =========================================================
# RESET BARS
# =========================================================

func reset_temperature_bars():

	for i in range(node_count):

		if i < heat_bar_container.get_child_count():

			var rect = heat_bar_container.get_child(i)

			rect.color = Color.BLUE


# =========================================================
# STOP
# =========================================================

func stop_simulation():

	running = false

	sim_timer.stop()

	result_label.text = "Simulation Paused"


# =========================================================
# CANCEL
# =========================================================

func cancel_simulation():

	running = false

	sim_timer.stop()

	current_time = 0.0

	temperatures.clear()

	reset_temperature_bars()

	result_label.text = "Simulation Cancelled"
