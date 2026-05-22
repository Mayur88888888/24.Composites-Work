extends Node

var current_module = null
var workspace = null


func set_workspace(target_workspace):
	workspace = target_workspace


func load_module(module_scene_path):
	
	if workspace == null:
		push_error("Workspace not assigned!")
		return

	# Remove old module
	if current_module != null:
		current_module.queue_free()

	# Load new scene
	var module_scene = load(module_scene_path)

	if module_scene == null:
		push_error("Failed to load module: " + module_scene_path)
		return

	current_module = module_scene.instantiate()

	workspace.add_child(current_module)
