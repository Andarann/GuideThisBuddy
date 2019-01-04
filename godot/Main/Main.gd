extends Spatial

func _ready():
	$GameCamera.setTarget($Slime)
	$Slime.hide()
	$GUI.connect("launch_level", self, "loadLevel")

func loadLevel(levelPath : String):
	#Unloading the previous level
	while $CurrentLevel.get_child_count() != 0:
		$CurrentLevel.remove_child($CurrentLevel.get_child(0))
	
	#Loading the level and adding it as a child
	var level = load(levelPath).instance()
	$CurrentLevel.add_child(level)
	
	#Applying the parameters of the level
	$Slime.translation = level.get_node("PlayerStart").translation
	$Slime.show()
	
func _process(delta):
	pass