extends Control

const colors = ["sky", "border", "water_top", "water_bottom", "sd_water_top", "sd_water_bottom", "sd_tint"]

func _ready():
	get_parent().name = tr("Colors")
	HWTheme.connect("theme_loaded", self, "on_theme_loaded")
	
	$UpperWater/ColorContainer/Color.connect("color_changed", self, "synchronize_water_alpha", [$LowerWater/ColorContainer/Color])
	$LowerWater/ColorContainer/Color.connect("color_changed", self, "synchronize_water_alpha", [$UpperWater/ColorContainer/Color])
	$SDUpperWater/ColorContainer/Color.connect("color_changed", self, "synchronize_water_alpha", [$SDLowerWater/ColorContainer/Color])
	$SDLowerWater/ColorContainer/Color.connect("color_changed", self, "synchronize_water_alpha", [$SDUpperWater/ColorContainer/Color])
	
	for i in get_child_count():
		var picker = get_child(i)
		picker.get_node("Header/OnOff").connect("toggled", HWTheme, "change_property", [str(colors[i], "_defined")])
		picker.get_node("ColorContainer/Color").connect("color_changed", HWTheme, "change_property", [colors[i]])

func synchronize_water_alpha(new_color, twin):
	twin.color.a = new_color.a

func on_theme_loaded():
	for i in get_child_count():
		var picker = get_child(i)
		
		picker.get_node("Header/OnOff").pressed = HWTheme.get(str(colors[i], "_defined"))
		picker.get_node("ColorContainer/Color").color = HWTheme.get(colors[i])
