extends Node

signal card_picked(card: Card)

var cards_in_hand: Array[Card]


func pick_card(card_to_pick: Card):
	cards_in_hand.append(card_to_pick)
	card_picked.emit(card_to_pick)

func place_card(card_to_place: Card):
	pass
