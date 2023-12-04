package utils

import "core:fmt"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

get_textures_from_dir :: proc(dir_path: string) -> (textures: map[string]rl.Texture) {
	dir, err := os.open(dir_path)
	if err != os.ERROR_NONE {
		fmt.printf("Failed to open %s\n", dir_path)
		return
	}
	fi, _ := os.read_dir(dir, 0)
	for file in fi {
		key, _ := strings.remove(file.name, ".png", 1)
		textures[key] = rl.LoadTexture(strings.clone_to_cstring(strings.concatenate({dir_path, file.name})))
	}
	return textures
}
