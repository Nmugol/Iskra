shader_type canvas_item;

// Uniformy do konfiguracji efektu
uniform float distortion_intensity : hint_range(0, 0.1) = 0.02;
uniform float wave_speed : hint_range(0, 5) = 1.0;
uniform float wave_frequency : hint_range(0, 20) = 5.0;
uniform vec2 light_center = vec2(0.5, 0.5);
uniform vec4 light_color : source_color = vec4(1.0, 0.9, 0.7, 1.0);
uniform float light_size : hint_range(0.1, 2.0) = 0.5;
uniform sampler2D noise_texture;

// Funkcja szumu do generowania organicznych zniekształceń
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Bazowy kolor tekstury
    vec4 base_color = texture(TEXTURE, UV);
    
    // Oblicz dystans od centrum światła
    float dist = distance(UV, light_center);
    
    // Tworzenie falistych zniekształceń
    float wave = sin(UV.x * wave_frequency + TIME * wave_speed) * 
                 cos(UV.y * wave_frequency + TIME * wave_speed * 0.7) * 
                 distortion_intensity;
    
    // Generowanie szumu dla organicznego wyglądu
    vec2 noise_uv = UV * 5.0 + vec2(TIME * 0.2);
    float noise_value = texture(noise_texture, noise_uv).r;
    
    // Łączenie zniekształceń
    vec2 distorted_uv = UV + vec2(wave, wave * 0.5) + (noise_value - 0.5) * distortion_intensity;
    
    // Pobranie koloru ze zniekształconych współrzędnych
    vec4 distorted_color = texture(TEXTURE, distorted_uv);
    
    // Tworzenie efektu świetlnego (im bliżej centrum, tym jaśniej)
    float light_factor = 1.0 - smoothstep(0.0, light_size, dist);
    vec4 light_effect = light_color * light_factor;
    
    // Mieszanie kolorów - światło przepuszczane przez kryształ
    COLOR = mix(base_color, distorted_color + light_effect, 0.3 * light_factor);
    COLOR.a = base_color.a; // Zachowaj oryginalną przezroczystość
}
