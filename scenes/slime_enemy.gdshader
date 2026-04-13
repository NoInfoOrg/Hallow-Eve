shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform float glow_intensity : hint_range(0.0, 5.0) = 1.0;
uniform float glow_radius : hint_range(0.0, 20.0) = 10.0;

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	float alpha = col.a;
	
	// Sampling multiple points to create a "Blur"
	float blur = 0.0;
	float samples = 16.0; // Higher = smoother, but heavier on GPU
	
	for(float i = 0.0; i < samples; i++) {
		float angle = i * (6.28318 / samples);
		vec2 offset = vec2(cos(angle), sin(angle)) * TEXTURE_PIXEL_SIZE * glow_radius;
		blur += texture(TEXTURE, UV + offset).a;
	}
	
	blur /= samples;
	
	// This math makes the glow fall off smoothly
	vec3 final_glow = glow_color.rgb * blur * glow_intensity;
	float glow_alpha = blur * glow_color.a;
	
	// Draw the slime on top, and the blurred "glow" behind it
	vec4 final_color = mix(vec4(final_glow, glow_alpha), col, alpha);
	COLOR = final_color;
}