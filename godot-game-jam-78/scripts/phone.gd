extends OutlineInteraction

@onready var phone_light = $"Phone Light"

func _ready():
	super()

func _process(_delta):
	_update_outline()

func interact():
	if selected_object == self:
		print("Phone Selected")
		if interacted:
			SoundBus.busy_signal.play()
			phone_light.light_color = Color(1, 1, 0)
			#phone_light.light_energy = 0.1
		else:
			SoundBus.busy_signal.stop()
			phone_light.light_color = Color(1, 0, 0)
			#phone_light.light_energy = 0.1
		selected_object = null
		selected = false
