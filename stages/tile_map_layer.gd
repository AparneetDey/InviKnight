extends TileMapLayer

const radius := 3

func _ready() -> void:
	SignalManager.hitBreakbleWall.connect(onBreakWall.bind())

func onBreakWall(wallPosition: Vector2) -> void:
	var tilePos := local_to_map(to_local(wallPosition))
	
	for i in range(-radius, radius):
		for j in range(-radius, radius):
			var target := tilePos + Vector2i(i, j)
			var data := get_cell_tile_data(target)
			if(data and data.get_custom_data("breakable")):
				set_cell(target, -1)
				SignalManager.spawnEffect.emit(to_global(map_to_local(target)))
