package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(800, 600, "DEMO")
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.ClearBackground(rl.BLACK)
	}
}
