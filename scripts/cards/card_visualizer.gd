class_name CardVisualizer extends InteractableElements

@export var max_tilt: float = 15.0
@export var tilt_speed: float = 10.0

var target_rotation: Vector3 = Vector3.ZERO


var is_inspecting: bool # as in its selected specifically to inspect

@export var card_instance: Card

@onready var sprite_node: Sprite3D = $Sprite3D

#func _init(card_ins: Card) -> void:
#	card_instance = card_ins

func _process(delta: float) -> void:
	look_at_mouse(delta)


func look_at_mouse(delta: float):
	if not is_inspecting:
		return
	var camera: Camera3D = get_viewport().get_camera_3d()
	var mouse_position: Vector2 = get_viewport().get_mouse_position()

	var ray_origin: Vector3 = camera.project_ray_origin(mouse_position)
	var ray_direction: Vector3 = camera.project_ray_normal(mouse_position)

	var plane: Plane = Plane(global_transform.basis.z, global_position)
	var hit_position: Variant = plane.intersects_ray(ray_origin, ray_direction)

	if hit_position != null:
		var local_position: Vector3 = to_local(hit_position)

		var half_width: float = sprite_node.texture.get_width() * sprite_node.pixel_size * 0.5
		var half_height: float = sprite_node.texture.get_height() * sprite_node.pixel_size * 0.5

		var normalized_x: float = clamp(local_position.x / half_width, -1.0, 1.0)
		var normalized_y: float = clamp(local_position.y / half_height, -1.0, 1.0)

		target_rotation.x = deg_to_rad(-normalized_y * max_tilt)
		target_rotation.y = deg_to_rad(normalized_x * max_tilt)

	rotation.x = lerp_angle(rotation.x, target_rotation.x, tilt_speed * delta)
	rotation.y = lerp_angle(rotation.y, target_rotation.y, tilt_speed * delta)

var inspinspection_transform: Transform3D = Transform3D(
	Basis.from_euler(Vector3(deg_to_rad(-18.0), 0, 0)),
	Vector3(0.0, 1.41, 2.335)
)

func on_click():
	set_global_transform(inspinspection_transform)
	is_inspecting = true

func deselect(normal_card_position: Transform3D):
	set_global_transform(normal_card_position)
	is_inspecting = false
