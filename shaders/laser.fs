#version 330
#extension GL_ARB_separate_shader_objects : enable

#ifdef GL_ES
precision mediump float;
#endif

layout(location=1) in vec2 fsTex;
layout(location=0) out vec4 target;

uniform sampler2D mainTex;
uniform vec4 color;
uniform float objectGlow;

// 20Hz flickering. 0 = Miss, 1 = Inactive, 2 & 3 = Active alternating.
uniform int hitState;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

void main()
{
    float x = fsTex.x;
    // float laserSize = 1.0; //0.0 to 1.0
    // x -= 0.5;
    // x /= laserSize;
    // x += 0.5;

    float s = float(hitState);
	vec4 mainColor = texture(mainTex, vec2(x, s / 4 + fsTex.y / 4));

    //target = mainColor * color;
    vec3 mainHsv = rgb2hsv(mainColor.xyz);
    vec3 colorHsv = rgb2hsv(color.xyz);

    vec4 final;
    final.xyz =  hsv2rgb(vec3(mainHsv.x + colorHsv.x, mainHsv.y + colorHsv.y, mainHsv.z));
    final.a = mainColor.a * color.a;

    target = final;

    //float brightness = (target.x + target.y + target.z) / 3;
	//target.xyz = target.xyz * (0.5 + objectGlow);
}