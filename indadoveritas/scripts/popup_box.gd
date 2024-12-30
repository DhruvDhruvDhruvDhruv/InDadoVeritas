extends Control

@onready var num_dice: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NumDice
var number_of_dice : int = 1
var dice_array : Array = [1]
@onready var any_dice_roll: Button = $PanelContainer/MarginContainer/VBoxContainer/AnyDiceRoll
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const Dice = preload("res://scripts/dice.gd")
var dice_rolling : bool = false
@onready var any_roll_timer: Timer = $PanelContainer/MarginContainer/VBoxContainer/AnyDiceRoll/any_roll_timer

func roll_any_dice() -> void:
	dice_rolling = true
	any_roll_timer.start()
	var dice_array_block : Array
	while dice_rolling:
		dice_array_block = Dice.rand_dice(number_of_dice)
		any_dice_roll.text = dice_array_block[1]
		await get_tree().create_timer(any_roll_timer.wait_time / 15.0).timeout
	dice_array = dice_array_block[0]

# Make this Static when needed
func set_num_dice_label() -> void:
	num_dice.text = " " + str(number_of_dice) + " "
	#dice_array = [for i in range(number_of_dice): randint()]
	var output_dice = Dice.rand_dice(number_of_dice)
	dice_array = output_dice[0]
	any_dice_roll.text = output_dice[1]

func resume():
	animation_player.play_backwards("blur")
	visible = false

func pause():
	visible = true
	animation_player.play("blur")

func _on_any_roll_timer_timeout() -> void:
	dice_rolling = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	animation_player.play("RESET")
	set_num_dice_label()
	

###############################
###         BUTTONS 	   ####
###############################

func _on_minus_dice_pressed() -> void:
	if number_of_dice > 1:
		number_of_dice -= 1
		set_num_dice_label()


func _on_plus_dice_pressed() -> void:
	if number_of_dice < 4:
		number_of_dice += 1
		set_num_dice_label()


func _on_any_dice_roll_pressed() -> void:
	roll_any_dice()



func _on_multi_dice_button_pressed() -> void:
	pause()

func _on_exit_pressed() -> void:
	resume()

##########################################################

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
