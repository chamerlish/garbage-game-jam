class_name PlayerCamera extends Camera3D

const CLICK_DISTANCE: int = 1000
@export var deck_hand: DeckHand

var is_inspecting: bool = false
var is_dragging: bool = false
var drag_start_position: Vector2
var dragged_card: CardVisualizer

func check_click(mouse: InputEventMouse, exclude: CollisionObject3D = null) -> Dictionary: # the dictionary holds the result aka what i clicked
	var mouse_position: Vector2 = mouse.position
	var ray_origin: Vector3 = project_ray_origin(mouse_position)
	var ray_end: Vector3 = ray_origin + project_ray_normal(mouse_position) * CLICK_DISTANCE
	
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true
	
	if exclude:
		query.exclude = [exclude.get_rid()]
	
	return get_world_3d().direct_space_state.intersect_ray(query)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		
		if event.is_pressed():
			drag_start_position = event.position
			is_dragging = false
			
			var result: Dictionary = check_click(event)
			
			if result and result["collider"] is CardVisualizer:
				dragged_card = result["collider"]
		else:
			
			if is_inspecting:
				is_inspecting = false
				deck_hand.uninspect_card.call_deferred()
				return
			
			var result: Dictionary = check_click(event, dragged_card) if is_dragging else check_click(event)
			
			if !result:
				is_dragging = false
				CardManager.fail_place_card()
				return
			
			var clicked_object: InteractableElements = result["collider"]
			if !clicked_object:
				return
			
			if is_dragging:
				is_dragging = false
				var is_successful: bool = clicked_object is CardTablePlacer and dragged_card
				if is_successful:
					CardManager.place_card(dragged_card, clicked_object)
					dragged_card.can_drag = false
				else:
					CardManager.fail_place_card()
				return
				
			if clicked_object is CardVisualizer:
				deck_hand.inspect_card.call_deferred(clicked_object)
	
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if event.position.distance_to(drag_start_position) > 5.0:
			is_dragging = true
		
		if is_dragging and dragged_card and dragged_card.can_drag:
			var ray_origin: Vector3 = project_ray_origin(event.position)
			var ray_direction: Vector3 = project_ray_normal(event.position)
			
			var plane: Plane = Plane(dragged_card.global_transform.basis.z, dragged_card.global_position)
			var mouse_position: Vector3 = plane.intersects_ray(ray_origin, ray_direction)
			
			dragged_card.global_position = mouse_position
