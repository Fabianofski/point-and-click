@tool
extends Resource
class_name OnClickAction

enum ClickEvent { StartDialog, ChangeCamera, PickUpItem, UseItem, DestroyObject, TriggerSignal }

var click_event: ClickEvent:
	set(value):
		click_event = value
		notify_property_list_changed()

var timeline: String

var signal_name: String
var signal_args: Array = []

var item_id: String

var cam_pos: String

var object_id: String

var next_action: OnClickAction

func _get_property_list() -> Array:
	var properties = []
	properties.append({
		"name": "click_event",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Start Dialog, Change Camera, Pick up Item, Use Item, Destroy Object, Trigger Signal"
	})
	if click_event == ClickEvent.StartDialog:
		properties.append({
			"name": "timeline",
			"type": TYPE_STRING
		})
	elif click_event == ClickEvent.TriggerSignal:
		properties.append({
			"name": "signal_name",
			"type": TYPE_STRING
		})
		properties.append({
			"name": "signal_args",
			"type": TYPE_ARRAY
		})
	elif click_event == ClickEvent.PickUpItem or click_event == ClickEvent.UseItem:
		properties.append({
			"name": "item_id",
			"type": TYPE_STRING
		})
	elif click_event == ClickEvent.DestroyObject: 
		properties.append({
			"name": "object_id",
			"type": TYPE_STRING
		})
	elif click_event == ClickEvent.ChangeCamera: 
		properties.append({
			"name": "cam_pos",
			"type": TYPE_STRING
		})
	properties.append({
		"name": "next_action",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "OnClickAction",
	})
	return properties
	
func trigger(): 
	match click_event: 
		ClickEvent.StartDialog:
			Dialogic.start(timeline)
			Dialogic.timeline_ended.connect(func(): if next_action: next_action.trigger())
			return
		ClickEvent.TriggerSignal:
			var args = [signal_name]
			args.append_array(signal_args)
			SignalBus.callv("emit_signal", args)
		ClickEvent.PickUpItem: 
			Inventory.pick_up_item(item_id)
		ClickEvent.ChangeCamera: 
			SignalBus.emit_signal("change_camera_pos", cam_pos)
		ClickEvent.DestroyObject: 
			SignalBus.emit_signal("destroy_object", object_id)

	if next_action: 
		next_action.trigger()
