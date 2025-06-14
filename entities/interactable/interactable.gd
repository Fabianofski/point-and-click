extends Area3D

@onready var mesh: MeshInstance3D = null
var outline_mat = preload("res://common/shader/outline.tres")
var mouse_on_entity: bool = false

@export var level: String
@export var object_id: String
@onready var res: Interactable = load("res://interactables/%s/%s.tres" % [level, object_id])

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
	res.active = cam_pos == res.camera_layer or res.camera_layer == "all"

func _unhandled_input(event):
	if not res.active: 
		return 

	var left_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if not left_click or not mouse_on_entity:
		return 

	res.on_click_action.trigger()

func _on_mouse_entered() -> void:
	if not res.active: 
		mesh.material_overlay = null 
		mouse_on_entity = false
		return
	mesh.material_overlay = outline_mat
	mouse_on_entity = true
	
func _on_mouse_exited() -> void:
	if not res.active: 
		return
	mesh.material_overlay = null
	mouse_on_entity = false
