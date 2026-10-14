shader_type canvas_item;

uniform vec4 cor_linha : source_color = vec4(0.372549, 0.266667, 0.419608, 1.0); // #5f446b
uniform float linhas = 8.0;       // quantas faixas na tela
uniform float velocidade = 1.2;
uniform float espessura = 2000.0;    // 0 a 1, grossura de cada linha dentro da faixa
uniform float densidade = 0.6;    // 0 a 1, quantas faixas têm linha
uniform bool vertical = false;     // true = linhas verticais

float hash(float n) {
	return fract(sin(n * 127.1) * 43758.5453);
}

void fragment() {
	vec2 uv = vertical ? UV.yx : UV.xy;
	float faixa = floor(uv.y * linhas);
	float dentro = fract(uv.y * linhas);
	float h = hash(faixa);
	float dir = hash(faixa + 7.0) > 0.5 ? 1.0 : -1.0;
	float vel = velocidade * (0.8 + h);

	float existe = step(1.0 - densidade, hash(faixa + 3.0));
	float grossura = step(abs(dentro - 0.5), espessura * 0.05);
	float seg = fract(uv.x * (1.5 + h * 2.0) + TIME * vel * dir + h * 10.0);
	float traco = step(seg, 0.25 + 0.35 * h);

	COLOR = vec4(cor_linha.rgb, cor_linha.a * existe * grossura * traco);
}