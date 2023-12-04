package main

import rl "vendor:raylib"

player: Player

Level :: struct {
	tiles:  [dynamic]rl.Rectangle,
	player: Player,
}

level_setup :: proc(level_data: [dynamic]string) -> Level {
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

level_draw_map :: proc(tiles: [dynamic]rl.Rectangle) {
	for tile in tiles {
		rl.DrawRectangleRec(tile, rl.GRAY)
	}
}

level_run :: proc(level: ^Level, camera: ^rl.Camera2D) {
	level_draw_map(level.tiles)
	player_update(&level.player)
	level_update_camera(level.player, camera)
	level_check_vertical_collision(level)
	level_check_horizontal_collision(level)
}

level_update_camera :: proc(player: Player, camera: ^rl.Camera2D) {
	camera.offset = {WINDOW_WIDTH / 2, f32(WINDOW_HEIGHT) / 4}
	camera.target = {player.rect.x, player.rect.y}
}

level_check_vertical_collision :: proc(using level: ^Level) {
	apply_gravity(&level.player)
	for tile in tiles {
		if rl.CheckCollisionRecs(tile, player.rect) {
			if player.vel.y > 0 {
				player_place(&player, {player.rect.x, tile.y}, .BOTTOM)
				player.vel.y = 0
			} else if player.vel.y < 0 {
				player_place(&player, {player.rect.x, tile.y + tile.height}, .TOP)
				player.vel.y = 0
			}
		}
	}
}

level_check_horizontal_collision :: proc(using level: ^Level) {
	player.rect.x += player.vel.x * rl.GetFrameTime()
	for tile in tiles {
		if rl.CheckCollisionRecs(tile, player.rect) {
			if player.vel.x > 0 {
				player_place(&player, {tile.x, player.rect.y}, .RIGHT)
			} else if player.vel.x < 0 {
				player_place(&player, {tile.x + tile.width, player.rect.y}, .LEFT)
			}
		}
	}
}

level_deinit :: proc(using level: Level) {
	player_deinit(player)
}
