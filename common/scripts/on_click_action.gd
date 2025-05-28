@tool
extends Resource
class_name OnClickAction

enum ClickEvent { StartDialog, TriggerSignal }

var click_event: ClickEvent:
	set(value):
		click_event = value
		notify_property_list_changed()

var timeline: String
var signal_name: String
var signal_args: Array = []

func _get_property_list() -> Array:
	var properties = []
	properties.append({
		"name": "click_event",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "StartDialog,TriggerSignal"
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
	return properties
	
func trigger(): 
	match click_event: 
		ClickEvent.StartDialog:
			Dialogic.start(timeline)
		ClickEvent.TriggerSignal:
			var args = [signal_name]
			args.append_array(signal_args)
			SignalBus.callv("emit_signal", args)
