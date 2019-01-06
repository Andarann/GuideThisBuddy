extends Spatial

var currentLevel

func _ready():
	$Slime.hide()
	$Slime.set_sleeping(true)
	
	$GUI.loadGui($GUI.mainMenu)

func loadLevel(levelPath : String):
	#Loading the new level and adding it as a child
	var currentLevel = load(levelPath).instance()
	self.add_child(currentLevel)
	
	#Applying the parameters of the level
	$Slime.translation = currentLevel.get_node("PlayerStart").translation
	
	#Preparing the start of the Plater placement phase
	$Slime.show()
	$GUI.loadGui($GUI.platerPlacement)
	$GameCamera.centerOn($Slime)

func launchLevel():
	$Slime.set_sleeping(false)
	$GameCamera.setTarget($Slime)
	
func getLevelAvailablePlaters():
	return currentLevel
	
func _process(delta):
	pass