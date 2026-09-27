extends Node

@onready var wood_cut: AudioStreamPlayer2D = $WoodCut
@onready var place_repair_building: AudioStreamPlayer2D = $PlaceRepairBuilding

func play_wood_cut_sound():
	wood_cut.play()

func place_repair_building_sound():
	place_repair_building.play()
