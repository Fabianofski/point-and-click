extends Node

@onready var label: Label = $Label 

func _ready() -> void:
	SignalBus.connect("inventory_update", on_inventory_update)
	on_inventory_update()

func on_inventory_update(): 
	label.text = '\n'.join(Inventory.items)
