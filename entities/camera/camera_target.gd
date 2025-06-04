@tool
extends Marker3D

@export var orthographic_size: float = 6.0
@export_tool_button("Set Camera Position") var follow_cam = cam_follow
@export var cam_debug: Node 

func cam_follow():
	if cam_debug: 
		cam_debug.global_transform = self.global_transform 
		cam_debug.get_child(0).size = orthographic_size
