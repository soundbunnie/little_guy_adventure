extends PanelContainer

@onready var property_container = %VBoxContainer
var properties : Array
var frames_per_second : String

func _ready():
	Global.debug = self
	visible = false
	add_debug_property("FPS",frames_per_second)

func _process(delta):
	if visible:
		frames_per_second = "%.2f" % (1.0/delta)
		add_debug_property("FPS: ", frames_per_second)
	
func _input(event):
	# Toggle debug panel
	if event.is_action_pressed("debug"):
		visible = !visible # Switch visibility to the opposite of what it is
	
func add_debug_property(title : StringName, value) -> void:
	if properties.has(title):
		var target = property_container.find_child(title, true, false) as Label
		target.text = title + ": " + str(value)
	else:
		var property = Label.new()
		property_container.add_child(property)
		property.name = title
		property.text = title + ": " + str(value)
		properties.append(title)
