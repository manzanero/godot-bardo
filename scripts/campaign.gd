class_name Campaign extends Spatial

var file = preload("res://scripts/utils/file.gd").new()


func load_campaign():
	var text = file.read_json("res://resources/maps/donjon_small.json")
#	var text = read_json("res://resources/maps/donjon_large.json")
	$MapGenerator.create_scene_from_donjon(text)
#	$MapGenerator.create_tilemap_from_donjon(text)

