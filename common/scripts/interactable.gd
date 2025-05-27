extends Area3D

@onready var mesh: MeshInstance3D = $MeshInstance3D 
var outline_mat = load("res://common/shader/outline.tres")
var mouse_on_entity: bool = false

enum OnClickEvent { StartDialogue, TriggerSignal }
@export var on_click_event: OnClickEvent
@export var timeline: String 

func _unhandled_input(event):
	var left_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if not left_click or not mouse_on_entity:
		return 

	match on_click_event: 
		OnClickEvent.StartDialogue: 
			Dialogic.start(timeline)
		OnClickEvent.TriggerSignal: 
			# SignalBus.
			pass

func _on_mouse_entered() -> void:
	mesh.material_overlay = outline_mat
	mouse_on_entity = true
	
func _on_mouse_exited() -> void:
	mesh.material_overlay = null
	mouse_on_entity = false
