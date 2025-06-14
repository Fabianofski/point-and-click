@tool
extends MeshInstance3D

func _ready() -> void:
	if not Engine.is_editor_hint(): 
		self.visible = true
