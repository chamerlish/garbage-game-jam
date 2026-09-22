class_name PlayerCamera extends Camera3D

const CLICK_DISTANCE: int = 1000

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.is_pressed():
			return
		
		if not event.button_index == MOUSE_BUTTON_LEFT:
			return
		
		var mouse_postion: Vector2 = event.position
		var ray_origin: Vector3 = project_ray_origin(mouse_postion)
		var ray_end: Vector3 = ray_origin + project_ray_normal(mouse_postion) * CLICK_DISTANCE
		var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		query.collide_with_areas = true
		var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
		
		if result:
			var clicked_object: Node3D = result["collider"]
			if clicked_object is InteractableElements:
				clicked_object.on_click.call_deferred()
