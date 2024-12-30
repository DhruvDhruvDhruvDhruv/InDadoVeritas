class_name DiceRoll
extends Button

# Set up Variables
@onready var button: Button = $"."
@onready var roll_timer: Timer = $roll_timer
@onready var rule_label: Label = %"Rule Label"
@onready var rule_name: Label = %"Rule Name"


var doubles_rules := ["If anyone drinks, so do you! Pick a first mate to support your cause",
					"Remove an item of clothing.",
					"Everyone pours 1 finger into a cup, roller drinks.",
					"Roll 4 dice. Drink that total number of sips.",
					"Make up a rule. Low key one that lasts the rest of the game.",
					"Roller chooses someone to remove an item of clothing."]

var regular_rules := ["Whisper a question to the next person, most likely to style (can be multiple people answer). They point. \n\nAccused: drink 2 sips, roll dice and repeat til even. Once even, pointer reveal question",
					"Go around and everyone asks roller a Q. Answer or drink 2. If all Qs answered - everyone drinks 4.",
					"Roller close eyes. People either side, pick a person each (can be themselves or roller). Roller then says what A + B must do. If either refuse, both down drink.",
					"Make an assumption about someone in this room, must be specific and can't be known already. If right, they drink 2; if wrong, roller drinks 4",
					"Last to stand drinks 3.",
					"Roller asks everyone a Q. Drink to forfeit. If everyone answers, roller drinks 4.",
					"Roller asks Q. 3,2,1 - everyone point at someone. Most pointed at drinks 2.",
					"3 fingers up. Go around and do NHIE. If you have, clap and finger down. first to drop all 3, drink 3. \n \n Bonus: If someone shames another for their NHIE, they drink 2",
					"Make a rule. Roll 3 dice for how many turns it lasts."]

var regular_rule_names := ["Paranoia",
							"Hotseat",
							"A plus B",
							"Assumption",
							"Heaven",
							"Reverse Hotseat",
							"Most likely to",
							"Never have I ever",
							"Rule Wizard"]

var doubles_rule_names := ["Captain Rule",
							"Strip (self)",
							"Death Cup",
							"Lucky Sips",
							"Perm rule",
							"Strip (other)"]

var dice_array_block : Array = []
var dice_rolling : bool = false
var double_dice : bool = false
var cur_rule : String = "RULE."
var cur_rule_name : String = "RULE."
var prev_dice : String = "1 2"


# Functions
func roll_dice() -> Array:
	dice_rolling = true
	roll_timer.start()
	while dice_rolling:
		dice_array_block = rand_dice(2)
		button.text = dice_array_block[1]
		await get_tree().create_timer(roll_timer.wait_time / 15.0).timeout
	while prev_dice == button.text:
		dice_array_block = rand_dice(2)
		button.text = dice_array_block[1]
	prev_dice = button.text
	print_debug(prev_dice)
	return dice_array_block[0]

func update_main_labels(dice_array : Array) -> void:
	if dice_array.size() == 2:
		var dice_1 : int = dice_array[0]
		var dice_2 : int = dice_array[1]
		double_dice = check_doubles(dice_1, dice_2)
		if double_dice:
			cur_rule = doubles_rules[dice_1-1]
			cur_rule_name = doubles_rule_names[dice_1-1]
		else:
			cur_rule = regular_rules[dice_1+dice_2-3]
			cur_rule_name = regular_rule_names[dice_1+dice_2-3]
		rule_label.text = cur_rule
		rule_name.text = cur_rule_name
	else:
		print("Main Labels can't be updated if dice array isnt size 2")

static func rand_dice(num_dice : int) -> Array:
	var dice_array : Array = []
	for i in num_dice:
		dice_array.append(randi_range(1,6))
	var text_equiv = " ".join(PackedStringArray(dice_array.map(func(x): return str(x))))
	return [dice_array, text_equiv]

func check_doubles(dice_1 : int, dice_2 : int) -> bool:
	if dice_1 == dice_2:
		print("Doubles!")
		return true
	else:
		return false

func _on_pressed() -> void:
	var dice_array : Array = await roll_dice()
	update_main_labels(dice_array)


func _on_roll_timer_timeout() -> void:
	dice_rolling = false

### GARBAGE DUMP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
