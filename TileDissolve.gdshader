shader_type canvas_item;


uniform float sensitivity : hint_range(0.0, 1.0) = .5;
uniform float factor : hint_range(0.0, 32.0) = 1.0;
uniform float seed_x = 1.0;
uniform float seed_y = 1.0;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(seed_x, seed_y))) * 438.5453);
}

void fragment() {
	// Get size of texture in pixels
	float size_x = float(textureSize(TEXTURE, 0).x) / factor;
	float size_y = float(textureSize(TEXTURE, 0).y) / factor;
	//
	vec4 pixelColor = texture(TEXTURE, UV);
	// Create a new "UV" which remaps every UV value to a snapped pixel value
	vec2 UVr = vec2(floor(UV.x*size_x)/size_x, floor(UV.y*size_y)/size_y);
	// Determine whether pixel should be visible or not
	float visible = step(sensitivity, random(UVr));
	// Draw the pixel, or not depending on if it is visible or not
	COLOR = vec4(pixelColor.r, pixelColor.g, pixelColor.b, min(visible, pixelColor.a));
}