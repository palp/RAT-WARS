shader_type canvas_item;
uniform float hurt_flash = 0;

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR.rgb = texture(TEXTURE, UV).rgb * (1.0 - hurt_flash) + vec3(1,0.1,0.1) * hurt_flash;
	COLOR.a = texture(TEXTURE,UV).a;
}