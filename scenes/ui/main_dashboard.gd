extends Control


@onready var workspace = $Workspace


func _ready():
	ModuleManager.set_workspace(workspace)
