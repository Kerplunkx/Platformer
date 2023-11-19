package main

WINDOW_WIDTH :: 1200
WINDOW_HEIGHT := len(map_data) * TILE_SIZE
TILE_SIZE :: 64

map_data := [dynamic]string {
	"                            ",
	"                            ",
	"                            ",
	" XX    XXX            XX    ",
	" XX P X                      ",
	" XXXX         XX         XX ",
	" XXXX       XX              ",
	" XX    X  XXXX    XX  XX    ",
	"       X  XXXX    XX  XXX   ",
	"    XXXX  XXXXXX  XX  XXXX  ",
	"XXXXXXXX  XXXXXX  XX  XXXX  ",
}
