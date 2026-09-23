class_name CardTablePlacer extends InteractableElements


@export var player_controlled: bool

var placed_cards: Array[CardVisualizer]

@onready var card_spawner_position: Marker3D = $CardSpawnerPosition

var card_spacing: int = 2

func on_click():
	# TODO: change camera position :D
	pass
	

func _init() -> void:
	CardManager.card_placed.connect(_on_card_placed)

func _on_card_placed(card: CardVisualizer, location: CardTablePlacer):
	if location != self:
		return
	
	_place_card(card)

func _place_card(card: CardVisualizer) -> void:
	placed_cards.append(card)
	card.reparent(self)
	
	
	card.transform = card_spawner_position.transform
	rearange_cards()

func rearange_cards() -> void:
	var total_width: float = (placed_cards.size() - 1) * card_spacing
	var start_x: float = -total_width / 2.0
	for i: int in placed_cards.size():
		placed_cards[i].position.x = start_x + i * card_spacing
		
