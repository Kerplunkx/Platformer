package main

import "core:fmt"
import "core:os"
import "core:strings"
import "utils"
import rl "vendor:raylib"

@(private = "file")
VELOCITY :: 250
@(private = "file")
GRAVITY :: 30
@(private = "file")
JUMP_SPEED :: -800

// Graphics
@(private = "file")
IMG_FOLDER :: "assets/graphics/player/"
@(private = "file")
SPRITE_WIDTH :: 32
@(private = "file")
SPRITE_HEIGHT :: 32

Animation :: struct {
	sprite:        rl.Texture,
	frames:        i32,
	current_frame: i32,
}

Status :: enum {
	FALLING,
	WALK_RIGHT,
	WALK_LEFT,
	JUMP,
	IDLE,
}

Player :: struct {
	vel:       rl.Vector2,
	rect:      rl.Rectangle,
	textures:  map[string]rl.Texture,
	animation: Animation,
	status:    Status,
}

Placement :: enum {
	RIGHT,
	LEFT,
	TOP,
	BOTTOM,
}

setup_player :: proc(pos: rl.Vector2) -> Player {
	textures := utils.get_textures_from_dir(IMG_FOLDER)
	return {{0, 0}, {pos.x, pos.y, SPRITE_WIDTH * SCALING, SPRITE_HEIGHT * SCALING}, textures, {}, .WALK_RIGHT}
}

player_deinit :: proc(using player: Player) {
	for _, texture in textures {
		rl.UnloadTexture(texture)
	}
}

player_draw :: proc(using player: Player) {
	rl.DrawTexturePro(
		animation.sprite,
		{f32(animation.current_frame) * SPRITE_WIDTH, 0, SPRITE_WIDTH, SPRITE_HEIGHT},
		{rect.x, rect.y, rect.width, rect.height},
		{0, 0},
		0,
		rl.WHITE,
	)
	rl.DrawRectangleLines(i32(rect.x), i32(rect.y), i32(rect.width), i32(rect.height), rl.RED)
}

get_input :: proc(using player: ^Player) {
	if rl.IsKeyDown(.RIGHT) {
		vel.x = VELOCITY
		status = .WALK_RIGHT
	} else if rl.IsKeyDown(.LEFT) {
		vel.x = -VELOCITY
	} else {
		vel.x = 0
		status = .IDLE
	}
	if rl.IsKeyPressed(.UP) {
		jump(player)
		status = .JUMP
	}
}

player_update :: proc(using player: ^Player) {
	player_draw(player^)
	get_input(player)
	fmt.println(player.animation.current_frame)
	player_set_animation(player)
	player_animate(player)
}

apply_gravity :: proc(using player: ^Player) {
	vel.y += GRAVITY
	rect.y += vel.y * rl.GetFrameTime()
}

jump :: proc(using player: ^Player) {
	vel.y = JUMP_SPEED
}

player_place :: proc(using player: ^Player, new_pos: rl.Vector2, placement: Placement) {
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

player_set_animation :: proc(using player: ^Player) {
	sprite := textures["idle"]
	#partial switch status {
		case .JUMP:
			sprite = textures["jump"]
		case .WALK_RIGHT:
			sprite = textures["run"]
			
	}
	frames := sprite.width / SPRITE_WIDTH
	animation = {sprite, frames, 0}
}


frames_counter := 0
player_animate :: proc(using player: ^Player) {
	frames_counter += 1
	if frames_counter >= 60 / 30 {
		frames_counter = 0
		animation.current_frame += 1
		if animation.current_frame > animation.frames {
			animation.current_frame = 0
		}
	}
}
