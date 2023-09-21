shader_type canvas_item;

uniform bool linear_interp = false;
uniform ivec2 interp_sharpness = ivec2(1);

void fragment() {
	if (linear_interp) {
		vec2 tex_size = vec2(textureSize(TEXTURE,0)) * vec2(interp_sharpness);
		vec2 px_size = TEXTURE_PIXEL_SIZE / vec2(interp_sharpness);
		
		vec2 a_uv = UV - px_size;
		
		if (interp_sharpness.x < 1) {
			tex_size.x = vec2(textureSize(TEXTURE,0)).x * 1.0;
			px_size.x = TEXTURE_PIXEL_SIZE.x * 1.0;
			a_uv.x = UV.x;
		}
		if (interp_sharpness.y < 1) {
			tex_size.y = vec2(textureSize(TEXTURE,0)).y * 1.0;
			px_size.y = TEXTURE_PIXEL_SIZE.y * 1.0;
			a_uv.y = UV.y;
		}

		vec2 uv1 = a_uv + vec2(0.0, px_size.y);
		vec2 uv2 = a_uv + vec2(px_size.x, 0.0 );
		vec2 uv3 = a_uv + vec2(px_size.x, px_size.y);
		vec2 uv4 = a_uv;

		vec4 s1 = vec4(texture(TEXTURE, uv1));
		vec4 s2 = vec4(texture(TEXTURE, uv2));
		vec4 s3 = vec4(texture(TEXTURE, uv3));
		vec4 s4 = vec4(texture(TEXTURE, uv4));

		vec2 dimensions = vec2(UV) * tex_size;

		float fu = fract(dimensions.x);
		float fv = fract(dimensions.y);

		vec4 tmp1 = mix(s4, s2, fu);
		vec4 tmp2 = mix(s1, s3, fu);

		vec4 t0 = mix(tmp1, tmp2, fv);
		COLOR = t0;
	}
}
