
Skip to content

    Buy us a coffee
    Log in
    Create account

Godot Shaders Logo

    Home
    Shaders
    Snippets
    Upload shader

+228	
Stylized grass with wind and deformation
gdquest	
February 11, 2021

A wide field extends to the horizon. The lime grass strands dance under the morning sun.

 

This shader gives you the starting point to create lovely animated stylized grass as seen in games like Zelda: Breath of the Wild.

 

It features:

 

1. Noise-based wind animation, giving the wind effect a lot of variety.

2. Deformation of the grass when a character passes through it.

 

In the GDQuest Godot shaders repository on top of the shader, you will find a demo where we use GDScript code to generate the grass strands. We use a multi-mesh instance to ensure the performance is good.

 

See the demo scene WindGrassDemo.tscn in the GDQuest Godot shaders repository.

 

The shader currently does not handle shadows. We kept it without shading to maximize performance.

 

With the current shader, only one object can affect and bend the grass. To allow multiple to do so, you have two add more variables to store character positions and update the shader accordingly.

 

There is a limitation of Godot 3.2’s shader language. You can’t export an array of varying sizes to pass multiple positions. So we only define one position to avoid bloating the shader example.

 

An alternative would be to encode multiple positions in a small texture and decode them in the shader, leading to less readable code.

 

If you like our work, be sure to follow us on Twitter. There, we share more free and open-source Godot resources and gamedev insights.
Get demo project
Shader code

shader_type spatial;
render_mode cull_disabled, unshaded;

uniform float wind_speed = 0.2;
uniform float wind_strength = 2.0;
// How big, in world space, is the noise texture
// wind will tile every wind_texture_tile_size
uniform float wind_texture_tile_size = 20.0;
uniform float wind_vertical_strength = 0.3;
uniform vec2 wind_horizontal_direction = vec2(1.0,0.5);

uniform sampler2D color_ramp : hint_black_albedo;
// we need a tiling noise here!
uniform sampler2D wind_noise : hint_black;

uniform vec3 character_position;
uniform float character_radius = 3.0;
uniform sampler2D character_distance_falloff_curve : hint_black_albedo;
uniform float character_push_strength = 1.0;

varying float debug_wind;

void vertex() {
	
	vec3 world_vert = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;

	vec2 normalized_wind_direction = normalize(wind_horizontal_direction);
	vec2 world_uv = world_vert.xz / wind_texture_tile_size + normalized_wind_direction * TIME * wind_speed;
	// we displace only the top part of the mesh
	// note that this means that the mesh needs to have UV in a way that the bottom of UV space
	// is at the top of the mesh
	float displacement_affect = (1.0 - UV.y);
	float wind_noise_intensity = (textureLod(wind_noise, world_uv , 0.0).r - 0.5);

	// We convert the direction of the wind into vertex space from world space
	// if we used it directly in vertex space, rotated blades of grass wouldn't behave properly
	vec2 vert_space_horizontal_dir = (inverse(WORLD_MATRIX) * vec4(wind_horizontal_direction, 0.0,0.0)).xy;
	vert_space_horizontal_dir = normalize(vert_space_horizontal_dir);
	
	vec3 bump_wind = vec3(
		wind_noise_intensity * vert_space_horizontal_dir.x,
		1.0 - wind_noise_intensity,
		wind_noise_intensity * vert_space_horizontal_dir.y 
	);
	normalize(bump_wind);
	bump_wind *= vec3(
		wind_strength,
		wind_vertical_strength,
		wind_strength
	);
	VERTEX += bump_wind * displacement_affect;
	
	// At the moment the blades are pushed away in a perfectly circular manner.
	// We could distort the distance to the character based on a noise, to break a bit the
	// circular shape. We could distort the falloff by sampling in a noise based on the xz coordinates.
	// The task is left to the reader
	
	vec3 dir_to_character = character_position - WORLD_MATRIX[3].xyz;
	// uncomment the following line to have a horizontal only character push
//	dir_to_character.y = 0.0;
	float distance_to_character = length(dir_to_character);
	float falloff = 1.0 - smoothstep(0.0, 1.0, distance_to_character/character_radius);
	// Because we operate in vertex space, we need to convert the direction to the character
	// in vertex space. Otherwise, it wouldn't work for rotated blades of grass.
	// comment the next line to observe how the blades are not all facing away from the character.
	dir_to_character = (inverse(WORLD_MATRIX) * vec4(dir_to_character, 0.0)).xyz;
	dir_to_character = normalize(dir_to_character);

	// sample the curve based on how far we are from the character, in normalized coordinates
	float falloff_curve = texture(character_distance_falloff_curve, vec2(falloff)).x;
	// direction to character is inverted because we want to point away from it
	VERTEX += normalize(-dir_to_character) * falloff_curve * character_push_strength * displacement_affect;
	
}

void fragment() {
	ALBEDO = texture(color_ramp, vec2(1.0 - UV.y, 0)).rgb ;
}

Tags
3d, deformation, grass, wind
The shader code and all code snippets in this post are under MIT license and can be used freely. Images and videos, and assets depicted in those, do not fall under this license. For more info, see our License terms.
More from gdquest
Spatial3146
Stylized fire (3D)
Related shaders
Canvas item121
Frosty Rotative Deformation
Spatial5
3D wind sway shader with wind mask texture controll
Spatial597
Stylized Cartoon Grass
Subscribe
Login
guest


7 Comments
Oldest
ShikamaruBH
ShikamaruBH
3 years ago

How can I use it in a terrain ?
0
Reply
Alejandro
Alejandro
2 years ago

Any ways of make it work in Gles2?
have problems with textureLod and textrue
0
Reply
trackback
How to render millions of blades of grass efficiently in godot! – Leon Stansfield
1 year ago

[…] grass models in scatter are very nice. With some nice wavy movements. I am using this grass shader this grass shader. To add some player interaction and deformation, make your grass blade a child of a spatial node […]
-1
Reply
trackback
Sélection de 12 Shaders 3D Gratuits Pour Godot - Blog Tuto.com
1 year ago

[…] shader d’herbe stylisée, taillé pour Godot, vous invite à créer des scènes d’herbe […]
-2
Reply
Benight
Benight
1 year ago

I spent hours trying to figure out why the grass was acting reacting to the player even when well outside radius in Godot 4.1.3.
It turns out that in Godot 4 curve textures are set to repeat by default.

Add “repeat_disable” as a hint to the curve texture and it should then work fine!
10
Reply
Max
Max
11 months ago

Not working for 4.2
Error
uniform sampler2D color_ramp : hint_black_albedo;
6
Reply
saad
saad
8 months ago
Reply to  Max

change following line from uniform sampler2D color_ramp : hint_black_albedo;

to

uniform sampler2D color_uniform sampler2D color_ramp : hint_default_white ;
5
Reply

© 2025 Godot Shaders

Beautiful illustrations from Icon 8.
Contact
info@godotshaders.com
Give us feedback!

    About
    FAQ
    License

