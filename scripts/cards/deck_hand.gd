class_name DeckHand extends Node3D

var held_cards: Array[CardVisualizer]

var card_spacing: int = 1

const CARD_VIS_PACKED: PackedScene = preload("res://screnes/cards/card_visualizer.tscn")

func _init() -> void:
	CardManager.card_picked.connect(pick_card)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		CardManager.pick_card(Card.new())

func pick_card(card: Card):
	#var card_vis = CardVisualizer.new(card)
	
	var card_vis: CardVisualizer = CARD_VIS_PACKED.instantiate()
	
	add_child(card_vis)
	held_cards.append(card_vis)
	
	reorder_list()


var last_inspected_transform: Transform3D
var last_inspected_card: CardVisualizer

func inspect_card(card_vis: CardVisualizer):
	last_inspected_transform = card_vis.get_global_transform()
	last_inspected_card = card_vis
	card_vis.on_click.call_deferred()

func uninspect_card():
	last_inspected_card.deselect.call_deferred(last_inspected_transform)

func reorder_list():
	var total_width := (held_cards.size() - 1) * card_spacing
	var start_x := -total_width / 2.0

	for i in held_cards.size():
		held_cards[i].position.x = start_x + i * card_spacing
