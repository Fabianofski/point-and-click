extends Node

@export var item_container: Node 
@export var tween_duration := 0.2

func _ready() -> void:
	Inventory.new_item.connect(on_new_item)
	Inventory.remove_item.connect(on_remove_item)

func on_new_item(item_id: String) -> void:
	var item = preload("res://scenes/ui/inventory/item.tscn")

	var instance = item.instantiate()
	instance.name = item_id
	var icon = load("res://scenes/ui/inventory/icons/%s.png" % item_id)
	instance.icon = icon
	
	item_container.add_child(instance)
	instance.pressed.connect(func(): Inventory.select_item(item_id))
	
	print("added child %s" % item_id)

func on_remove_item(item_id: String) -> void: 
	var node = item_container.get_node(item_id)
	node.queue_free()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var tween = get_tree().create_tween()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			tween.tween_property(self, "position", Vector2(self.position.x, -self.size.y), tween_duration)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			tween.tween_property(self, "position", Vector2(self.position.x, 0), tween_duration)
