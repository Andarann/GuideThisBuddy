extends Spatial

func _ready():
	$Slime.hide()
	$Slime.set_sleeping(true)
	
	$GUI.loadGui($GUI.mainMenu)

func loadLevel(levelPath : String):
	#Loading the new level and adding it as a child
	var newLevel = load(levelPath).instance()
	$CurrentLevel.add_child(newLevel)
	
	launchPlaterPlacement()
	
func reloadCurrentLevel():
	$CurrentLevel.get_child(0).reload()
	$Slime.set_sleeping(false)
	
	launchPlaterPlacement()

func launchPlaterPlacement():
	#This method prepares the level for the plater placement phase
	$Slime.set_sleeping(true)
	$Slime.translation = $CurrentLevel.get_child(0).get_node("PlayerStart").translation
	$Slime.set_visible(true)
	
	$GameCamera.centerOn($Slime)
	
	$GUI.loadGui($GUI.platerPlacement)
	
func launchLevel():
	$Slime.set_sleeping(false)
	$GameCamera.setTarget($Slime)
	$GUI.loadGui($GUI.levelGUI)
	
func getLevelAvailablePlaters():
	return $CurrentLevel.get_child(0).getAvailablePlaters()
	
func _process(delta):
	pass