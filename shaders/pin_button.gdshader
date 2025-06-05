shader_type canvas_item;

uniform vec4 custom_color : source_color;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	if (tex_color.g == 1.0){
		COLOR = custom_color;
	}else{
		COLOR = tex_color;
	}
}

