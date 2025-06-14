@tool
extends EditorScenePostImport

var interactable_node: Resource = load("res://entities/interactable/interactable.tscn")

func _post_import(scene):
	iterate(scene, scene)
	return scene 

func iterate(node: Node3D, root):
	if node != null:
		if node.name.ends_with("-itbl"):
			var itbl = interactable_node.instantiate()
			node.get_parent().add_child(itbl) 
			itbl.set_owner(root)
			itbl.position = node.position
			itbl.rotation = node.rotation

			node.reparent(itbl)

			var collision = CollisionShape3D.new() 
			itbl.add_child(collision)
			collision.set_owner(root)
			collision.make_convex_from_siblings()
		else:
			for child in node.get_children():
				iterate(child, root)
