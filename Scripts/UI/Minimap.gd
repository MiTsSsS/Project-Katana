extends MarginContainer
class_name Minimap

@export var player:Player
@export var zoom = 1.5

@onready var grid = $MarginContainer/Grid
@onready var playerMarker = $MarginContainer/Grid/PlayerMarker
@onready var enemyMarker = $MarginContainer/Grid/EnemyMarker
@onready var healthMarker = $MarginContainer/Grid/HealthMarker

@onready var icons = {
	"enemy": enemyMarker,
	"heal": healthMarker,
	"player": playerMarker
}

var gridScale
var markers = {}

func _ready():
	await get_tree().process_frame
	playerMarker.position = grid.size / 2
	gridScale = grid.size / (get_viewport_rect().size * zoom)
	updateMinimapMarkers()

func updateMinimapMarkers():
	var map_objects = get_tree().get_nodes_in_group("minimap_icon")
	for item in map_objects:
		if markers.has(item):
			continue
		var new_marker = icons[item.minimapIcon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker

func _process(delta):
	if not player:
		return

	for item in markers:
		var obj_pos = (item.position - player.position) * gridScale + grid.size / 2
		obj_pos = obj_pos.clamp(Vector2.ZERO, grid.size)
		markers[item].position = obj_pos

func onObjectRemoved(object):
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)
