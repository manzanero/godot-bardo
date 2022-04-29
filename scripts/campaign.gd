extends Spatial

var map_scene = preload("res://scenes/map.tscn")
var file = preload("res://scripts/utils/file.gd")


func load_campaign():
	var text = file.read_json("res://resources/maps/donjon_small.json")
#	var text = read_json("res://resources/maps/donjon_large.json")
	var map = map_scene.instance().load_from_donjon(text)
	$Maps.add_child(map)
