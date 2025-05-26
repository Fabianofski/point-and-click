extends Node3D

@onready var anim_player = $AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anim_player.play("walk")
	rotate_y(.5 * delta)
	pass
