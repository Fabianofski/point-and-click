extends Area3D

@onready var mesh: MeshInstance3D = $MeshInstance3D 
var outline_mat = load("res://scenes/common/outline.tres")

func _on_mouse_entered() -> void:
	mesh.material_overlay = outline_mat
	
func _on_mouse_exited() -> void:
	mesh.material_overlay = null
