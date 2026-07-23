shader_type canvas_item;

// This creates a slider in the Inspector so the AnimationPlayer can access it
uniform float circle_radius : hint_range(0.0, 1.5) = 0.5;

// The center of the screen (0.5 is exactly the middle)
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
	// 1. Calculate aspect ratio so the circle doesn't squish into an oval on widescreen
	float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	
	vec2 scaled_uv = UV;
	scaled_uv.x *= aspect_ratio;
	
	vec2 scaled_center = center;
	scaled_center.x *= aspect_ratio;
	
	// 2. Measure the distance from the current pixel to the center point
	float dist = distance(scaled_uv, scaled_center);
	
	// 3. Set the transparency based on the distance. 
	// 'smoothstep' makes the edge of the circle smooth instead of jagged.
	COLOR.a = smoothstep(circle_radius - 0.0001, circle_radius, dist);
}