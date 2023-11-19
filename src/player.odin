package main

import rl "vendor:raylib"

@(private = "file")
VELOCITY :: 250
@(private = "file")
GRAVITY :: 10
@(private = "file")
JUMP_SPEED :: -200

Player :: struct {
	pos:  rl.Vector2,
	vel:  rl.Vector2,
	rect: rl.Rectangle, // used for collision detection
}

Placement :: enum {
	TOP,
	MIDDLE,
	BOTTOM,
}

setup_player :: proc(pos: rl.Vector2) -> Player {
	return {pos, {0, 0}, {pos.x, pos.y, 40, TILE_SIZE}}
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
	rect.x = pos.x
	rect.y = pos.y
	draw_player(player^)
	get_input(player)
	player.pos += player.vel * {rl.GetFrameTime(), rl.GetFrameTime()}
}

apply_gravity :: proc(using player: ^Player) {
	vel.y += GRAVITY
}

jump :: proc(using player: ^Player) {
	vel.y = JUMP_SPEED
}

place_player :: proc(using player: ^Player, new_pos: rl.Vector2, placement: Placement) {
	switch placement {
	case .TOP:
		pos = new_pos
	case .MIDDLE:
		pos = {new_pos.x, new_pos.y - player.rect.y / 2}
	case .BOTTOM:
		pos = {new_pos.x, new_pos.y - player.rect.height}
	}
}
