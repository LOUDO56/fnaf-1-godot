shader_type canvas_item;

/**
 * In relative units now (0-1)
 */
uniform float zoom = 1.0;

/**
 * Higher values = less distortion in the center
 */
uniform float sharpness = 2.0;

/**
 * (1, 0) for horizontal only, (0, 1) for vertical only
 */
uniform vec2 direction = vec2(1.0, 0.0);

/**
 * 0: Repeats
 * 1: Clamps
 * 2: Clips
 */
uniform int wrapping_mode = 0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    float fB;
    float fC;

    vec2 posTex;
    vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
    vec2 uv = SCREEN_UV;
    vec2 ndir = normalize(direction);
    float fac1 = abs(dot(uv - 0.5, normalize(ndir.yx))) * 2.0;
    float fac2 = -dot(uv - 0.5, normalize(ndir)) * 2.0;
    vec2 new_uv = uv + pow(fac1, sharpness) * fac2 * zoom * ndir;
    switch (wrapping_mode)
    {
        case 2:
            if (0.0 > new_uv.x || new_uv.x > 1.0 || 0.0 > new_uv.y || new_uv.y > 1.0)
            {
                COLOR = vec4(0);
                break;
            }
        case 0:
            new_uv = fract(new_uv);
            // fall-through
        case 1:
            new_uv = clamp(new_uv, vec2(0), vec2(1));
            COLOR = textureLod(SCREEN_TEXTURE, new_uv, 0.0);
            break;
    }
}