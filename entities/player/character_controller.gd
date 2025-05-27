extends CharacterBody3D

const SPEED = 2.5
const ACCEL = 10

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@export var target: Marker3D
@onready var anim_player = $nicolas/AnimationPlayer
var camera : Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	nav.target_position = target.global_position
	camera = get_viewport().get_camera_3d()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = event.position
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000
		var space_state = get_world_3d().direct_space_state
		var params = PhysicsRayQueryParameters3D.create(from, to)
		params.exclude = [self]
		
		var result = space_state.intersect_ray(params)

		if result:
			target.global_position = result.position
			nav.target_position = result.position

func _physics_process(delta):
	if not nav.is_target_reached():
		anim_player.play("walk")
		var direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		var flat_direction = nav.get_next_path_position() - global_position
		flat_direction.y = 0
		flat_direction = flat_direction.normalized()
		if flat_direction.length() > 0:
			look_at(global_transform.origin - flat_direction, Vector3.UP)

		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
	else:
		anim_player.play("idle")
		velocity = Vector3.ZERO
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
