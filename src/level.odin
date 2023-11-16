package main

import rl "vendor:raylib"

Level :: struct {
	tiles: [dynamic]rl.Rectangle,
}

setup_level :: proc(level_data: [dynamic]string) -> Level {
	tiles: [dynamic]rl.Rectangle
	for j in 0 ..< len(level_data) {
		for value, i in level_data[j] {
			if value == 'X' {
				append(
					&tiles,
					rl.Rectangle{f32(i) * TILE_SIZE, f32(j) * TILE_SIZE, TILE_SIZE, TILE_SIZE},
				)
			}
		}
	}

	return {tiles}
}

draw_map :: proc(tiles: [dynamic]rl.Rectangle) {
	for tile in tiles {
		rl.DrawRectangleRec(tile, rl.GRAY)
	}
}

run_level :: proc(level: Level) {
	draw_map(level.tiles)
}
