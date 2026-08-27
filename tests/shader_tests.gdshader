shader_type canvas_item;

void fragment() {
	// Called for every pixel the material is visible on.
	if(COLOR.b <= 0.5)
	{
		COLOR.r = 1.0;
	}
}