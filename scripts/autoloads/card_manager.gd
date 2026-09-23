extends Node

signal card_picked(card: Card)
signal card_placed(card_vis: CardVisualizer, location: CardTablePlacer)
signal fail_card_placed

var player_placed_cards: Array[Card]
var enemy_placed_cards: Array[Card]

var cards_in_hand: Array[Card]

const MAX_PLACABLE_CARD: int = 4

func pick_card(card_to_pick: Card):
	cards_in_hand.append(card_to_pick)
	card_picked.emit(card_to_pick)

func place_card(card_vis: CardVisualizer, location: CardTablePlacer):
	if location.player_controlled:
		if player_placed_cards.size() >= MAX_PLACABLE_CARD:
			fail_place_card()
			return
		player_placed_cards.append(card_vis.card_instance)
		
	else:
		if enemy_placed_cards.size() >= MAX_PLACABLE_CARD:
			fail_place_card()
			return
		enemy_placed_cards.append(card_vis.card_instance)
	card_placed.emit(card_vis, location)
	
func fail_place_card():
	fail_card_placed.emit()
