extends Area3D

@onready var mesh: MeshInstance3D = null
var outline_mat = load("res://common/shader/outline.tres")
var mouse_on_entity: bool = false

@export var object_id: String
@export var on_click_action: OnClickAction

@export var camera_layer: String = "all" 
@export var active: bool = true

func _ready():
	SignalBus.connect("destroy_object", destroy)
	SignalBus.connect("change_camera_pos", activate)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	for child in get_children():
		if child is MeshInstance3D:
			mesh = child
			break
	
func destroy(id: String) -> void: 
	if id == object_id: 
		self.queue_free()

func activate(cam_pos: String): 
	active = cam_pos == camera_layer or camera_layer == "all"

func _unhandled_input(event):
	if not active: 
		return 

	var left_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if not left_click or not mouse_on_entity:
		return 

	on_click_action.trigger()

func _on_mouse_entered() -> void:
	if not active: 
		mesh.material_overlay = null 
		mouse_on_entity = false
		return
	mesh.material_overlay = outline_mat
	mouse_on_entity = true
	
func _on_mouse_exited() -> void:
	if not active: 
		return
	mesh.material_overlay = null
	mouse_on_entity = false
