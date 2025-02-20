extends OutlineInteraction

@onready var phone_light = $"Phone Light"
@onready var caller_id = $CallerID
@onready var incoming_call = $"Incoming Call"

var calls : Array = []
var continue_story : bool = false
var phone_call_end : bool = false
var next_call : int = 0

func _ready():
	super()
	caller_id.visible = false
	incoming_call.visible = false
	calls = [SoundBus.phone_call_1]
	play_ringtone()
	continue_story = true

func _process(_delta):
	_update_outline()

func interact():
	if selected_object == self:
		if interacted and not continue_story:
			SoundBus.busy_signal.play()
			phone_light.light_color = Color(1, 1, 0)

		elif interacted and continue_story:
			caller_id.visible = true
			incoming_call.visible = false
			SoundBus.phone_ring.playing = false
			continue_story = false
			if next_call < calls.size():
				calls[next_call].play()
				await calls[next_call].finished
			hang_up_phone()
			next_call += 1
			
		else:
			for i in calls:
				i.stop()
			SoundBus.busy_signal.stop()
			incoming_call.visible = false
			caller_id.visible = false
			phone_light.light_color = Color(1, 0, 0)

		selected_object = null
		selected = false

func play_ringtone():
	incoming_call.visible = true
	phone_light.light_color = Color(1, 1, 0)
	SoundBus.phone_ring.playing = true
	
func hang_up_phone():
	incoming_call.visible = false
	caller_id.visible = false
	phone_light.light_color = Color(1, 0, 0)
	reset_object()
	
