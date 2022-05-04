extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var num1 = 1
var num3 = 10
var win = 0
var lose = 0
var trigger= 0
var rng = RandomNumberGenerator.new()
var myturn = true
var end = false
var t = 10

func new_round():
	$turn_txt.text = "New round"
	$turn_txt.show()
	$score_txt.text="win "+str(win) + "         " +"lose "+str(lose)
	$score_txt.show()
	myturn = false
	for button in $HBoxContainer.get_children():
		if int(button.text)>1 and int(button.text)<10:
			button.disabled = false
		else:
			button.disabled = true
	
	num1 = 1
	num3 = 10
	end = false
	playVoice()
	yield(get_tree().create_timer(3), "timeout")
	trigger = rng.randi_range(2, 9)
	myturn = true
	if rng.randi() % 2 == 0:
		myturn = false 
	
	if myturn == true:
		$turn_txt.text="Your turn"
	else:
		$turn_txt.text="Bot's turn"
		
	$turn_txt.show()	 	
	if myturn == false:
		yield(get_tree().create_timer(2), "timeout")
		pc_turn()
	
			

func pc_turn():
	$turn_txt.text= "Bot's turn"
	number_click(rng.randi_range(num1+1, num3-1), false)
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer.hide()
	$message.hide()
	$start.connect("pressed",self,"start")
	$Timer.connect("timeout",self,"removeMsg")
	$score_txt.hide()
	$turn_txt.hide()
	for button in $HBoxContainer.get_children():
		button.connect("pressed", self, "number_click", [int(button.text), true])

func start():
#	$start_music.play(0)
	$Timer.start(1)
	$title.hide()
	$start.hide()
	$HBoxContainer.show()
	new_round()
	
	
func playVoice():
	var stream1 = load("res://sound/a-"+str(num1)+".mp3")
	var stream2 = load("res://sound/a-2.mp3")
	var stream3 = load("res://sound/a-"+str(num3)+".mp3")
	$number.stream = stream1
	$number.play()
	yield(get_tree().create_timer(0.5), "timeout")
	$number.stream = stream2
	$number.play()
	yield(get_tree().create_timer(0.5), "timeout")
	$number.stream = stream3
	$number.play()
	
	
func removeMsg():
	$message.hide()
	

func play_bang():
	t= 0
	$Sprite.show()
	$bang.play()
	


func _physics_process(delta):
	t += delta * 1
	if t<1:
		$Sprite.position = Vector2(960,0) + (Vector2(960,400)-Vector2(960,0))*t
	else:
		$Sprite.hide()
	
func number_click(num, turn):
	if myturn == turn:
		$button_music.play()
		var stream = load("res://sound/a-"+str(num)+".mp3")
		$number.stream = stream
		$number.play()
		$message.text=str(num)
		$message.show()
		yield(get_tree().create_timer(1.5), "timeout")		
		if num == trigger:
			play_bang()
			$HBoxContainer.get_node(str(num)).disabled= true
			if turn == true:
				$turn_txt.text="You lose"
				lose += 1
			else:
				$turn_txt.text="You win"
				win += 1	
			yield(get_tree().create_timer(3), "timeout")
			return new_round()			
		elif num < trigger:
			for button in $HBoxContainer.get_children():
				if int(button.text)<=num:
					button.disabled = true
			num1 = num
			playVoice()
			
		else:
			for button in $HBoxContainer.get_children():
				if int(button.text)>=num:
					button.disabled = true
			num3 = num
			playVoice()
		if myturn == true:
			myturn = false
			yield(get_tree().create_timer(3), "timeout")
			pc_turn()
		
		if myturn == false:
			yield(get_tree().create_timer(3), "timeout")
			myturn = true
			$turn_txt.text="Your turn"
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
