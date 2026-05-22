extends Control


@onready var workspace = $Workspace

@onready var btn_dashboard = $Sidebar/VBoxContainer/btn_dashboard
@onready var btn_heat_transfer = $Sidebar/VBoxContainer/btn_heat_transfer
@onready var btn_mold_process = $Sidebar/VBoxContainer/btn_mold_process
@onready var btn_cure_cycle = $Sidebar/VBoxContainer/btn_cure_cycle
@onready var btn_resin_flow = $Sidebar/VBoxContainer/btn_resin_flow
@onready var btn_materials = $Sidebar/VBoxContainer/btn_materials
@onready var btn_reports = $Sidebar/VBoxContainer/btn_reports
#@onready var btn_settings = $Sidebar/VBoxContainer/btn_settings
@onready var new_button = $TopBar/TopBarContainer/btn_new_project
@onready var open_button = $TopBar/TopBarContainer/btn_open_project
@onready var save_button = $TopBar/TopBarContainer/btn_save_project
@onready var settings_button = $TopBar/TopBarContainer/btn_settings
@onready var btn_exit = $Sidebar/VBoxContainer/btn_exit
@onready var about_dialog = $AboutDialog


func _ready():
	ModuleManager.set_workspace(workspace)
	ModuleManager.load_module(
    "res://scenes/modules/dashboard/dashboard_module.tscn"
)
	
	new_button.pressed.connect(new_project)
	btn_heat_transfer.pressed.connect(open_heat_transfer)
	btn_mold_process.pressed.connect(open_mold_process)
	btn_cure_cycle.pressed.connect(open_cure_cycle)
	btn_resin_flow.pressed.connect(open_resin_flow)
	btn_materials.pressed.connect(open_materials)
	btn_reports.pressed.connect(open_reports)
	btn_dashboard.pressed.connect(open_dashboard)
	var about_button = $Sidebar/VBoxContainer/btn_about
	about_button.pressed.connect(show_about)
	btn_exit.pressed.connect(exit)
	show_about()


func show_about():
	$AboutDialog.popup_centered()

	$AboutDialog.position.y += 40

func open_heat_transfer():
	ModuleManager.load_module(
        "res://scenes/modules/heat_transfer/heat_transfer.tscn"
	)

func open_dashboard():
	ModuleManager.load_module(
        "res://scenes/modules/dashboard/dashboard_module.tscn"
	)

func open_mold_process():
	ModuleManager.load_module(
        "res://scenes/modules/mold_process/mold_process.tscn"
	)

func open_cure_cycle():
	ModuleManager.load_module(
        "res://scenes/modules/cure_cycle/cure_cycle.tscn"
		
	)

func open_resin_flow():
	ModuleManager.load_module(
        "res://scenes/modules/resin_flow/resin_flow.tscn"
		)

func open_materials():
	print("Materials Module")

func open_reports():
	print("Reports Module")

func new_project():

	get_tree().change_scene_to_file(
		"res://heat_transfer.tscn"
	)

func exit():
	get_tree().quit()
