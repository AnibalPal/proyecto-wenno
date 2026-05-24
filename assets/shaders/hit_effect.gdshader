shader_type canvas_item;

uniform bool counter_state = false;
uniform bool hit_effect = false;

uniform float offset : hint_range(-1.0, 1.0, 0.001) = 0;
uniform vec4 aura_color : source_color;

void fragment() {
	
	if(counter_state) {
		vec4 original_texture = texture(TEXTURE, UV);
		vec4 offset_text = texture(TEXTURE, vec2(UV.x + offset , UV.y));
		offset_text.rgb = aura_color.rgb;
		if(original_texture.a != 0.0){
			COLOR = original_texture;
		} else {
			COLOR = offset_text;
		}
	}
	
	if(hit_effect) {
		COLOR.rgb = vec3(1.0f);
	}
}
