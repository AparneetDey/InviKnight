extends TileMapLayer

func _ready() -> void:
	SignalManager.hitBreakbleWall.connect(onBreakWall.bind())

func onBreakWall(wallPosition: Vector2) -> void:
	var tilePos := local_to_map(to_local(wallPosition))
	
	var data := get_cell_tile_data(tilePos)
	if(data and data.get_custom_data("breakable")):
		set_cell(tilePos, -1)
