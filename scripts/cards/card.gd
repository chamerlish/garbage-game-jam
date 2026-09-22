class_name Card extends Node


@export var card_name: StringName
@export var texture: Texture
@export var description: String
@export var effects: Effect

func place_cards() -> void:
	CardManager.add_card(self)
