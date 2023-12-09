shader_type canvas_item;
uniform sampler2D mask;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(TEXTURE,UV);
	vec2 muv = UV;
	//muv.y = 1.0 - muv.y;
	COLOR.a = texture(mask, muv).r;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
