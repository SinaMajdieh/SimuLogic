// Based on: https://www.shadertoy.com/view/WstXR8
shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

const mat4 bayerIndex = mat4(
    vec4(00.0/16.0, 12.0/16.0, 03.0/16.0, 15.0/16.0),
    vec4(08.0/16.0, 04.0/16.0, 11.0/16.0, 07.0/16.0),
    vec4(02.0/16.0, 14.0/16.0, 01.0/16.0, 13.0/16.0),
    vec4(10.0/16.0, 06.0/16.0, 09.0/16.0, 05.0/16.0));

void fragment() {
	 // sample the texture
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy/iResolution.xy;
    vec4 col = texture(SCREEN_TEXTURE,uv);

    // gamma correction
    col = vec4(pow(col.rgb,vec3(2.2)) - 0.004,col.a);

    // find bayer matrix entry based on fragment position
    float bayerValue = bayerIndex[int(FRAGCOORD.x) % 4][int(FRAGCOORD.y) % 4];


        // output
     COLOR = vec4(
            step(bayerValue,col.r),
            step(bayerValue,col.g),
            step(bayerValue,col.b),
            col.a);
}