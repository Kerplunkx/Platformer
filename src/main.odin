package main

import "core:fmt"
import "utils"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, i32(WINDOW_HEIGHT), "DEMO")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	level := level_setup(map_data)
	defer level_deinit(level)
	camera := rl.Camera2D {
		target = {level.player.rect.x, level.player.rect.y},
		offset = {WINDOW_WIDTH / 2, f32(WINDOW_HEIGHT) / 4},
		rotation = 0,
		zoom = 1,
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.BeginMode2D(camera)
		level_run(&level, &camera)
		rl.EndMode2D()
		debug(level.player.vel, {level.player.rect.x, level.player.rect.y})
	}
}

debug :: proc(components: ..rl.Vector2) {
	rl.DrawRectangleRec({0, 0, 200, 100}, rl.Fade(rl.SKYBLUE, 0.5))
	rl.DrawRectangleLines(0, 0, 200, 100, rl.BLUE)
	for i in 0 ..< len(components) {
		rl.DrawText(rl.TextFormat("%v", components[i]), 5, i32((i * 20) + 5), 18, rl.WHITE)
	}
}
