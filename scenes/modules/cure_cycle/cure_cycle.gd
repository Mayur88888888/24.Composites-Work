extends Control

@onready var material_database = $MaterialDatabase
@onready var label_cure_stage = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGridPanel/ResultsGrid/label_cure_stage
@onready var label_degree_cure = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGridPanel/ResultsGrid/label_degree_cure
@onready var label_resin_state = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGridPanel/ResultsGrid/label_resin_state
@onready var label_cycle_status = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGridPanel/ResultsGrid/label_cycle_status

@onready var label_cure_time = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGridPanel/ResultsGrid/label_cure_time

@onready var label_peak_temp = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGridPanel/ResultsGrid/label_peak_temp
@onready var warnings_text = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/WarningsPanel/WarningsVBox/warnings_text
@onready var cycle_status_label = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGridPanel/ResultsGrid/label_cycle_status
@onready var status_label = $MainVBox/BottomStatusBar/StatusHBox/status_label




func _ready():
	@warning_ignore("shadowed_variable")
	var status_label = $MainVBox/BottomStatusBar/StatusHBox/status_label
	status_label.text = "System Ready"

func run_cycle():
	

	# READ UI VALUES
	

	
	
	
	
	
	
	

	var material_name = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/MaterialPanel/MaterialVBox/material_selector.get_item_text(
		$MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/MaterialPanel/MaterialVBox/material_selector.selected
		)

	@warning_ignore("unused_variable")
	var thickness = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/MaterialPanel/MaterialVBox/input_thickness.value

	@warning_ignore("unused_variable")
	var initial_temp = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/MaterialPanel/MaterialVBox/input_initial_temp.value

	var target_temp = $MainVBox/MainSplit/LeftPanel/ScrollContainer/LeftVBox/ProcessPanel/ProcessVBox/target_temp.value
	
	
	
	
	
	# LOAD MATERIAL DATA

	@warning_ignore("shadowed_variable_base_class")
	var material = material_database.get_material(material_name)

	var cure_temp = material["cure_temp"]

	var cure_time = material["cure_time"]

	var heating_rate = material["heating_rate"]

	var cooling_rate = material["cooling_rate"]


	# DEGREE OF CURE

	var degree_of_cure = target_temp / cure_temp

	degree_of_cure = clamp(degree_of_cure, 0.0, 1.0)


	# DETERMINE CURE STAGE

	var cure_stage = "Initial"

	if degree_of_cure > 0.25:
		cure_stage = "Heating"

	if degree_of_cure > 0.5:
		cure_stage = "Active Cure"

	if degree_of_cure > 0.85:
		cure_stage = "Post Cure"

	if degree_of_cure >= 1.0:
		cure_stage = "Fully Cured"


	# RESIN STATE

	var resin_state = "Solid"

	if target_temp > 80:
		resin_state = "Softening"

	if target_temp > 120:
		resin_state = "Flowing"

	if degree_of_cure >= 1.0:
		resin_state = "Hardened"


	# UPDATE RESULTS

	$MainVBox/MainSplit/ResultsPanel/ResultsVBox/ResultsGridPanel/ResultsGrid/label_cure_stage.text = cure_stage

	label_degree_cure.text = str(snapped(degree_of_cure, 0.01))

	label_resin_state.text = resin_state

	label_cycle_status.text = "Completed"

	label_cure_time.text = str(cure_time) + " min"

	label_peak_temp.text = str(target_temp) + " °C"


	# STATUS TEXT

	warnings_text.text = \
	"Material Loaded : " + material_name + "\n\n" + \
	"Cure Stage : " + cure_stage + "\n" + \
	"Resin State : " + resin_state + "\n" + \
	"Heating Rate : " + str(heating_rate) + " °C/min\n" + \
	"Cooling Rate : " + str(cooling_rate) + " °C/min\n" + \
	"Cycle Completed Successfully"


	# VIEWPORT STATUS

	cycle_status_label.text = "Cycle Status : " + cure_stage


	# MATERIAL COLOR

	update_material_visualization(degree_of_cure)


	status_label.text = "Simulation Completed"



func update_material_visualization(degree):

	var block = $MainVBox/MainSplit/CenterPanel/CenterVBox/SimulationViewport/ViewportContent/CureChamber/MaterialBlock


	var cold_color = Color(0.2, 0.3, 0.8)

	var hot_color = Color(1.0, 0.2, 0.1)


	block.color = cold_color.lerp(hot_color, degree)



func reset_cycle():

	label_cure_stage.text = "-"

	label_degree_cure.text = "-"

	label_resin_state.text = "-"

	label_cycle_status.text = "Idle"

	label_cure_time.text = "-"

	label_peak_temp.text = "-"

	warnings_text.text = "Waiting for simulation..."

	cycle_status_label.text = "Cycle Status : Idle"

	status_label.text = "System Reset"


	var block = $MainVBox/MainSplit/CenterPanel/CenterVBox/SimulationViewport/ViewportContent/CureChamber/MaterialBlock

	block.color = Color(0.2, 0.3, 0.8)


func _on_btn_run_cycle_pressed() -> void:
	run_cycle()


func _on_btn_reset_pressed() -> void:
	reset_cycle()
