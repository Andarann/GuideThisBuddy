tool
extends "res://nodes/GUI/SpatialStalker.gd"

var center : Vector2

var showingAnimDuration : float = 0.1
var hidingAnimDuration : float = 0.1
var visiblePlatersNumber : int

export (float) var radius = 50.0
export (float) var minAngle = 0.0
export (float) var maxAngle = 2 * PI
export (bool) var showTranslation setget translationVisibility
export (bool) var showRotation setget rotationVisibility

func _ready():
	set_process(get_tree().get_edited_scene_root() == null)
	center = self.get_size() * 0.5
	$hidingTimer.set_wait_time(hidingAnimDuration)
	
	visiblePlatersNumber = 0
	
	for popupChild in self.get_children():
		if popupChild.is_class("Control"):
			if popupChild.is_visible():
				var newTween : Tween = Tween.new()
				$Tweens.add_child(newTween)
				visiblePlatersNumber += 1
			
	if self.is_visible():
		self.show()

func _process(delta):
	self.set_scale(Vector2(1,1)*8.0/get_viewport().get_camera().get_size())

func show():
	self.set_visible(true)
	
	var childNumber : int = 0
	for popupChild in self.get_children():
		if popupChild.is_class("Control"):
			if popupChild.is_visible():
				var circlePos : float = (maxAngle - minAngle) * childNumber / (visiblePlatersNumber-1)
				print(Vector2(cos(circlePos),sin(circlePos)))
				$Tweens.get_child(childNumber).interpolate_property(popupChild, "rect_position", center, center + radius * Vector2(cos(circlePos),-sin(circlePos)), showingAnimDuration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				childNumber += 1
	
	for i in $Tweens.get_children():
		i.start()

func hide():
	var childNumber : int = 0
	for popupChild in self.get_children():
		if popupChild.is_class("Control"):
			if popupChild.is_visible():
				var circlePos : float = (maxAngle - minAngle) * childNumber / (visiblePlatersNumber-1)
				$Tweens.get_child(childNumber).interpolate_property(popupChild, "rect_position", center + radius * Vector2(cos(circlePos),-sin(circlePos)), center, hidingAnimDuration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				childNumber += 1
			
	for i in $Tweens.get_children():
		i.start()

	$hidingTimer.start()

func closingAnimDone():
	self.set_visible(false)

func translationVisibility(newVisibility : bool):
	showTranslation = newVisibility
	$Translation.set_visible(newVisibility)
	
func rotationVisibility(newVisibility : bool):
	showRotation = newVisibility
	$Rotation.set_visible(newVisibility)