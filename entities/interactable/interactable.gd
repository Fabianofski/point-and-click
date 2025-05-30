@tool
extends Area3D

@onready var mesh: MeshInstance3D = null
var outline_mat = load("res://common/shader/outline.tres")
var mouse_on_entity: bool = false

@export var object_id: String
@export var on_click_action: OnClickAction

func _ready():
	SignalBus.connect("destroy_object", destroy)
	
	for child in get_children():
		if child is MeshInstance3D:
			mesh = child
			break
	
func destroy(id: String) -> void: 
	if id == object_id: 
		self.queue_free()

func _unhandled_input(event):
	var left_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if not left_click or not mouse_on_entity:
		return 

	on_click_action.trigger()

func _on_mouse_entered() -> void:
	mesh.material_overlay = outline_mat
	mouse_on_entity = true
	
func _on_mouse_exited() -> void:
	mesh.material_overlay = null
	mouse_on_entity = false
