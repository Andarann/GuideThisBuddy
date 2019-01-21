extends Control

#Node that follows its parent on screen, if it is a Spatial node. Otherwise it wont move and act like a regular node

var parentInheritsSpatial : bool
var initialPos : Vector2

func _ready():
	initialPos = self.get_position()
	parentInheritsSpatial = false
	
	if get_parent() != null:
		if get_parent().has_method("get_translation"):
			parentInheritsSpatial = true
		else:
			parentInheritsSpatial = false
	else:
		parentInheritsSpatial = false
		
	set_process(parentInheritsSpatial)
	
func _process(delta):
	self.set_position(initialPos + get_viewport().get_camera().unproject_position(get_parent().get_global_transform().origin))
