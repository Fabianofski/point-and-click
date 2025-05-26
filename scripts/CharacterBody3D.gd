extends CharacterBody3D

const SPEED = 2.5
const ACCEL = 10

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@export var target: Marker3D

func _ready():
	nav.target_position = target.global_position

func _physics_process(delta):
	print(nav.is_target_reached())
	if not nav.is_target_reached():
		var direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		look_at(global_transform.origin + direction, Vector3.UP)
	
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
	else: 
		velocity = Vector3.ZERO
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
