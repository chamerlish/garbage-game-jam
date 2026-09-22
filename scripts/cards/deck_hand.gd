extends Node3D

var held_cards: Array[CardVisualizer]

var card_spacing: int = 1

func _init() -> void:
	CardManager.card_picked.connect(pick_card)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		CardManager.pick_card(Card.new())

func pick_card(card: Card):
	var card_vis = CardVisualizer.new(card)
	
	add_child(card_vis)
	held_cards.append(card_vis)
	
	reorder_list()


func reorder_list():
	var total_width := (held_cards.size() - 1) * card_spacing
	var start_x := -total_width / 2.0

	for i in held_cards.size():
		held_cards[i].position.x = start_x + i * card_spacing
