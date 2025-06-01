shader_type canvas_item;

const int _N = 8;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap, repeat_disable;

uniform int _KernelSize: hint_range(2, 20, 1) = 2;

uniform float _Hardness: hint_range(1.0f, 100.0f) = 8.0f;
uniform float _Sharpness: hint_range(1.0f, 18.0f) = 8.0f;
uniform float _ZeroCrossing: hint_range(0.01f, 2.0f) = 0.58f;
uniform float _Zeta: hint_range(0.01f, 3.0f) = 1.0f;

varying vec2 texelSize;


float gaussian(float sigma, float pos) {
	return (1.0f / sqrt(2.0f * PI * sigma * sigma)) * exp(-(pos * pos) / (2.0f * sigma * sigma));
}


void vertex() {
	texelSize = vec2(1.0 / vec2(textureSize(SCREEN_TEXTURE, 0)));
}


void fragment() {
	vec4 m[8];
	vec3 s[8];

	int kernelRadius = _KernelSize / 2;

	//float zeta = 2.0f / (kernelRadius);
	float zeta = _Zeta;

	float zeroCross = _ZeroCrossing;
	float sinZeroCross = sin(zeroCross);
	float eta = (zeta + cos(zeroCross)) / (sinZeroCross * sinZeroCross);

	for (int k = 0; k < _N; ++k) {
		m[k] = vec4(0.0f);
		s[k] = vec3(0.0f);
	}

	for (int y = -kernelRadius; y <= kernelRadius; ++y) {
		for (int x = -kernelRadius; x <= kernelRadius; ++x) {
			vec2 v = vec2(float(x), float(y)) / float(kernelRadius);
			vec3 c = texture(SCREEN_TEXTURE, UV + vec2(float(x), float(y)) * texelSize.xy).rgb;
			c = clamp(c, 0.0f, 1.0f);
			float sum = 0.0f;
			float w[8];
			float z, vxx, vyy;

			/* Calculate Polynomial Weights */
			vxx = zeta - eta * v.x * v.x;
			vyy = zeta - eta * v.y * v.y;
			z = max(0, v.y + vxx);
			w[0] = z * z;
			sum += w[0];
			z = max(0, -v.x + vyy);
			w[2] = z * z;
			sum += w[2];
			z = max(0, -v.y + vxx);
			w[4] = z * z;
			sum += w[4];
			z = max(0, v.x + vyy);
			w[6] = z * z;
			sum += w[6];
			v = sqrt(2.0f) / 2.0f * vec2(v.x - v.y, v.x + v.y);
			vxx = zeta - eta * v.x * v.x;
			vyy = zeta - eta * v.y * v.y;
			z = max(0, v.y + vxx);
			w[1] = z * z;
			sum += w[1];
			z = max(0, -v.x + vyy);
			w[3] = z * z;
			sum += w[3];
			z = max(0, -v.y + vxx);
			w[5] = z * z;
			sum += w[5];
			z = max(0, v.x + vyy);
			w[7] = z * z;
			sum += w[7];

			float g = exp(-3.125f * dot(v,v)) / sum;

			for (int k = 0; k < 8; ++k) {
				float wk = w[k] * g;
				m[k] += vec4(c * wk, wk);
				s[k] += c * c * wk;
			}
		}
	}

	vec4 output = vec4(0.0f);
	for (int k = 0; k < _N; ++k) {
		m[k].rgb /= m[k].w;
		s[k] = abs(s[k] / m[k].w - m[k].rgb * m[k].rgb);

		float sigma2 = s[k].r + s[k].g + s[k].b;
		float w = 1.0f / (1.0f + pow(_Hardness * 1000.0f * sigma2, 0.5f * _Sharpness));

		output += vec4(m[k].rgb * w, w);
	}

	COLOR.rgb = clamp(output / output.w, 0.0f, 1.0f).rgb;
}
