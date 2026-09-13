class_name DayNightCycle
extends DirectionalLight3D

@export var day_duration_seconds: float = 300.0
@export var sun_color_day: Color = Color(1.0, 0.95, 0.8)
@export var sun_color_sunset: Color = Color(0.95, 0.5, 0.2)
@export var sun_color_night: Color = Color(0.15, 0.2, 0.35)

var time_of_day: float = 0.25 # Starts in morning (0.0 to 1.0)

func _process(delta: float):
	time_of_day += delta / day_duration_seconds
	if time_of_day >= 1.0:
		time_of_day -= 1.0

	var angle = time_of_day * TAU - (PI / 2.0)
	rotation.x = angle
	rotation.y = deg_to_rad(30.0)

	# Calculate sun intensity & color based on height
	var sun_height = sin(angle)
	if sun_height > 0.1:
		light_color = sun_color_day
		light_energy = lerp(0.5, 1.2, sun_height)
	elif sun_height > -0.1:
		light_color = sun_color_sunset
		light_energy = 0.4
	else:
		light_color = sun_color_night
		light_energy = 0.1
