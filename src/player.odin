package main

import rl "vendor:raylib"

@(private = "file")
VELOCITY :: 250
@(private = "file")
GRAVITY :: 10
@(private = "file")
JUMP_SPEED :: -200

Player :: struct {
	vel:  rl.Vector2,
	rect: rl.Rectangle,
}

Placement :: enum {
	RIGHT,
	LEFT,
	TOP,
	BOTTOM,
}

setup_player :: proc(pos: rl.Vector2) -> Player {
	return {{0, 0}, {pos.x, pos.y, 40, TILE_SIZE}}
}

draw_player :: proc(using player: Player) {
	rl.DrawRectangleRec(rect, rl.BLUE)
}

get_input :: proc(using player: ^Player) {
	if rl.IsKeyDown(.RIGHT) {
		vel.x = VELOCITY
	} else if rl.IsKeyDown(.LEFT) {
		vel.x = -VELOCITY
	} else {
		vel.x = 0
	}
	if rl.IsKeyPressed(.UP) {
		jump(player)
	}
}

update_player :: proc(using player: ^Player) {
	draw_player(player^)
	get_input(player)
}

apply_gravity :: proc(using player: ^Player) {
	vel.y += GRAVITY
	rect.y += vel.y * rl.GetFrameTime()
}

jump :: proc(using player: ^Player) {
	vel.y = JUMP_SPEED
}

place_player :: proc(using player: ^Player, new_pos: rl.Vector2, placement: Placement) {
	switch placement {
	case .LEFT:
		rect.y = new_pos.y
		rect.x = new_pos.x
	case .RIGHT:
		rect.y = new_pos.y
		rect.x = new_pos.x - rect.width
	case .TOP:
		rect.x = new_pos.x
		rect.y = new_pos.y
	case .BOTTOM:
		rect.x = new_pos.x
		rect.y = new_pos.y - player.rect.height
	}
}
