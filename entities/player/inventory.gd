extends Node

@export var items : Array[String] = []

func _ready() -> void:
	SignalBus.connect("pick_up_item", pick_up_item)
	SignalBus.connect("use_item", pick_up_item)

func pick_up_item(item_id: String) -> void: 
	if has_item(item_id): 
		return
	items.append(item_id)
	print("Picked up %s" % item_id)
	
	SignalBus.emit_signal("inventory_update")
	
func use_item(item_id: String) -> void: 
	var index = items.find(item_id)
	if index == -1: 
		print("Couldn't find item %s" % item_id)
		return
	items.remove_at(index)
	SignalBus.emit_signal("inventory_update")

func has_item(item_id: String) -> bool: 
	return items.any(func(x): return x == item_id)
