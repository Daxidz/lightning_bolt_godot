shader_type canvas_item;

float plott(vec2 st, float pct) {
	return smoothstep(pct-0.2, pct, st.y) - smoothstep(pct, pct+0.2, st.y);
}

float rand(vec2 n) {
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5433);
}

float noise(vec2 n) {
	vec2 d = vec2(0.0, 1.0);
	vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand(b), rand(b+d.yx), f.x), mix(rand(b+d.xy), rand(b+d.yy), f.x), f.x);
}

float fbm(vec2 n) {
	
	float total = 0.0, amplitude = 1.0;
	for (int i = 0; i < 7; i++) {
		total += noise(n) * amplitude;
		n += n;
		amplitude *= 0.5;
	}
	return total;
}

void fragment() {
	float pct;
	vec4 color = vec4(0.0);
	vec2 uv = UV;
	
	COLOR = color;
}
