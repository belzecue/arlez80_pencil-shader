/*
	鉛筆画風シェーダー by あるる（きのもと 結衣）
	Pencil Art-esque Shader by @arlez80

	MIT License
*/

shader_type canvas_item;
render_mode unshaded;

const vec3 MONOCHROME_SCALE = vec3( 0.298912, 0.586611, 0.114478 );

uniform vec4 background_color : hint_color = vec4( 1.0, 1.0, 1.0, 1.0 );
uniform sampler2D hatching_tex : hint_albedo;
uniform sampler2D dark_hatching_tex : hint_albedo;
uniform float hatching_scale = 21.5;

float random( vec2 pos )
{ 
	return fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment( )
{
	vec3 color = texture( SCREEN_TEXTURE, SCREEN_UV ).rgb;
	float luma = dot( MONOCHROME_SCALE, color );

	float skip_timer = floor( TIME * 12.0 ) / 12.0;

	float hatch_level = clamp( 1.0 - luma, 0.0, 1.0 );
	vec2 hatch_uv = ( UV * hatching_scale * ( floor( hatch_level * 10.0 ) / 10.0 + 0.1 ) + vec2( random( vec2( skip_timer, skip_timer ) ), random( vec2( skip_timer * 2.0, skip_timer * 2.0 ) ) ) );
	vec4 hatch = mix(
		texture(
			dark_hatching_tex,
			hatch_uv
		)
	,	texture(
			hatching_tex,
			hatch_uv
		)
	,	floor( luma * 3.0 ) / 3.0
	);

	COLOR = mix( background_color, vec4( color, 1.0 ), floor( hatch.a * 32.0 ) / 32.0 );
	// vec4( mix( color, hatch.rgb, floor( hatch_level * hatch.a * 32.0 ) / 32.0 ), 1.0 );
}
