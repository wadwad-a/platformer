extends Node2D

@onready var player1 = $player1
@onready var player2 = $player2
@onready var label = $TurnLabel
@onready var crown = $Crown
@onready var restart_button = $RestartButton


var player1_start_pos: Vector2
var player2_start_pos: Vector2

var player1_is_tagged = true

var player1_score = 0
var player2_score = 0
var score_timer = 0.0

var play := true
var transDone := false


func _ready():
	player1_start_pos = player1.position
	player2_start_pos = player2.position
	
	crown.visible = false
	crown.position = Vector2(576, -100)
	
	restart_button.visible = false
	restart_button.position = Vector2(446, 400)

	update_tag_text()


func _process(delta):
	if player1.position.distance_to(player2.position) < 30:
		tag_player()
	
	if not play and not transDone:
		crown.visible = true
		transDone = true
			
		var target_position = crown.position
		target_position.y = 300
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(crown, "position", target_position, 1.5)
		tween.tween_callback(show_restart_button)
		
	score_timer += delta
	
	if score_timer >= 1.0:
		score_timer -= 1.0
		
		if player1_is_tagged and play:
			player2_score += 1
			$p2Score.text = str(player2_score)
		
		elif not player1_is_tagged and play:
			player1_score += 1
			$p1Score.text = str(player1_score)
		
		else:
			if player1_score == 100:
				label.text = "Player 1 wins!"
				label.modulate = Color(0.9, 0, 0)
			else:
				label.text = "Player 2 wins!"
				label.modulate = Color(0, 0, 0.9)
				
		if player1_score == 100 or player2_score == 100:
			play = false


func tag_player():
	# Reset players to their original positions
	player1.position = player1_start_pos
	player2.position = player2_start_pos

	# Switch who is "it"
	player1_is_tagged = !player1_is_tagged

	update_tag_text()


func update_tag_text():
	if player1_is_tagged and play:
		label.text = "Player 1... TAG!"
		label.modulate = Color(0.9, 0, 0)
	elif not player1_is_tagged and play:
		label.text = "Player 2... TAG!"
		label.modulate = Color(0, 0.2, 0.9)

func show_restart_button():
	restart_button.visible = true
	restart_button.modulate = Color(1, 1, 1, 0)
	
	var fade = create_tween()
	fade.tween_property(restart_button, "modulate:a", 1.0, 0.75)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
