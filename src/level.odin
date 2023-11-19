package main

import rl "vendor:raylib"

player: Player

Level :: struct {
	tiles:  [dynamic]rl.Rectangle,
	player: Player,
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
			if value == 'P' {
				player = setup_player({f32(i) * TILE_SIZE, f32(j) * TILE_SIZE})
			}
		}
	}

	return {tiles, player}
}

draw_map :: proc(tiles: [dynamic]rl.Rectangle) {
	for tile in tiles {
		rl.DrawRectangleRec(tile, rl.GRAY)
	}
}

run_level :: proc(level: ^Level, camera: ^rl.Camera2D) {
	draw_map(level.tiles)
	update_player(&level.player)
	update_camera(level.player, camera)
	check_vertical_collision(level)
	// check_horizontal_collision(level)
}

update_camera :: proc(player: Player, camera: ^rl.Camera2D) {
	camera.offset = {WINDOW_WIDTH / 2, f32(WINDOW_HEIGHT) / 4}
	camera.target = player.pos
}

check_vertical_collision :: proc(using level: ^Level) {
	apply_gravity(&level.player)
	for tile in tiles {
		if rl.CheckCollisionRecs(tile, player.rect) {
			if player.vel.y > 0 {
				place_player(&player, {player.pos.x, tile.y}, .BOTTOM)
				player.vel.y = 0
			}
			if player.vel.y < 0 {
				place_player(&player, {player.pos.x, tile.y + tile.width}, .TOP)
				player.vel.y = 0
			}
		}
	}
}

check_horizontal_collision :: proc(using level: ^Level) {
	for tile in tiles {
		if rl.CheckCollisionRecs(tile, player.rect) {
			if player.vel.x > 0 {
				place_player(&player, {tile.x - player.pos.x, player.pos.y}, .TOP)
				player.vel.x = 0
			} else if player.vel.x < 0 {
				place_player(&player, {tile.x + tile.width, player.pos.y}, .TOP)
				player.vel.x = 0
			}
		}
	}
}
