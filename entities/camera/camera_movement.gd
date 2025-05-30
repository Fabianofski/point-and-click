extends Node

@export var camera_positions: Node3D
@export var index: int
@onready var camera : Camera3D = $Camera3D

func _ready() -> void:
	SignalBus.change_camera_pos.connect(change_camera_pos)

func change_camera_pos(pos_id: String):
	print("Change Camera Target to %s" % pos_id)
	var target = camera_positions.get_node(pos_id)
	if target == null: 
		print("Target %s not found" % pos_id)
		return
		
	var tween1 = get_tree().create_tween()
	tween1.tween_property(self, "global_transform", target.global_transform, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	var size = target.get("orthographic_size")
	if size != null:
		var tween2 = get_tree().create_tween()
		tween2.tween_property(camera, "size", size, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
