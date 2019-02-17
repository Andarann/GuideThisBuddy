extends "res://nodes/Platers/PlaterBase/PlaterBase.gd"

export (float) var extensionSpeed = 100.0 #Time it takes the bumper to fully extend
export (float) var extendedStateDuration  = 0.5 #Time the bumper spends extended
export (float) var pushForce = 20.0

const ROTATION_INCREMENTS : float = 90.0 * (PI/180)

enum ROTATION {
	LEFT,
	CENTER,
	RIGHT
}

var rotationTransform : Transform = Transform.IDENTITY
var addedTranslation : Vector3 = Vector3(0,0,0)
var changingOrientation : bool = false
var rotationState : int = ROTATION.CENTER

func _ready():
	changingOrientation = false
	$ExtendedTimer.wait_time = extendedStateDuration

func clone():
	var copy = self.duplicate()
	return copy

func _on_ExtendedTimer_timeout():
	$RotatedPart/Model/AnimationPlayer.play_backwards("default")

func _on_BodyDetector_body_entered(body):
	if body is RigidBody and !disabled:
		body.set_linear_velocity(pushForce*(($RotatedPart/Position3D.get_global_transform().origin - self.get_global_transform().origin).normalized()))
		$RotatedPart/Model/AnimationPlayer.play("default", -1, extensionSpeed)
		$ExtendedTimer.start()

func _on_Collisions_input_event(camera, event, click_position, click_normal, shape_idx):
	._on_PlaterPlacementDetection_input_event(camera, event, click_position, click_normal, shape_idx)

func _input(event):
	if changingOrientation:
		if event is InputEventMouseMotion:
			var originOnScreen : Vector2 = get_viewport().get_camera().unproject_position(self.to_global(Vector3(0,0,0)))
			var upOnScreen : Vector2 = get_viewport().get_camera().unproject_position(self.to_global(Vector3(0,1,0)))
			var mousePos : Vector2 = get_viewport().get_mouse_position()
			var mouseAngle : float = (mousePos - originOnScreen).angle_to(upOnScreen - originOnScreen)
			mouseAngle *= 2.0
			
			mouseAngle = ROTATION_INCREMENTS*int(mouseAngle/ROTATION_INCREMENTS)
			mouseAngle = max(-PI/2,min(PI/2,mouseAngle))
			
			rotationTransform = Transform.IDENTITY
			rotationTransform = rotationTransform.rotated(Vector3(0,0,1), mouseAngle)
			$RotatedPart.set_transform(rotationTransform)
			
		elif event.is_action_pressed("leftClick"):
			changingOrientation = false

func on_rotationRequested():
	changingOrientation = true
