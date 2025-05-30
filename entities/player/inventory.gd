extends Node

@export var items : Array[String] = []
signal new_item(item_id)
signal remove_item(item_id)

var selected_item : String = ""

func pick_up_item(item_id: String) -> void: 
	if has_item(item_id): 
		return
	items.append(item_id)
	print("Picked up %s" % item_id)
	
	new_item.emit(item_id)
	
func use_item(item_id: String) -> void: 
	var index = items.find(item_id)
	if index == -1: 
		print("Couldn't find item %s" % item_id)
		return
	select_item("")
	items.remove_at(index)
	remove_item.emit(item_id)

func has_item(item_id: String) -> bool: 
	return items.any(func(x): return x == item_id)

func select_item(item_id: String): 
	if has_item(item_id): 
		selected_item = item_id
	else: 
		selected_item = ""
