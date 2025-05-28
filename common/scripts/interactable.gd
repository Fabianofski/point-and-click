extends Area3D

@onready var mesh: MeshInstance3D = $MeshInstance3D 
var outline_mat = load("res://common/shader/outline.tres")
var mouse_on_entity: bool = false

@export var on_click_actions: Array[OnClickAction] = []

func _unhandled_input(event):
	var left_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if not left_click or not mouse_on_entity:
		return 

	for action in on_click_actions: 
		action.trigger()

func _on_mouse_entered() -> void:
	mesh.material_overlay = outline_mat
	mouse_on_entity = true
	
func _on_mouse_exited() -> void:
	mesh.material_overlay = null
	mouse_on_entity = false
