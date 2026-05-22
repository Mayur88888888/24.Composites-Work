shader_type canvas_item;

uniform float speed = 0.5;
uniform vec4 glow_color : source_color = vec4(0.2, 0.7, 1.0, 0.18);

void fragment()
{
	vec2 uv = UV;

	float wave =
		sin((uv.x + TIME * speed) * 8.0) * 0.4;

	float sweep =
		smoothstep(
			0.8 + wave,
			0.4 + wave,
			uv.y
		);

	vec4 base = vec4(0.0);

	base += glow_color * sweep;

	float scan =
		sin((uv.y + TIME * 0.5) * 120.0) * 0.1;

	base.rgb += scan;

	COLOR = base;
}