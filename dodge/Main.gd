extends Node

export (PackedScene) var mob_scene
var score

func _ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("GET READY")
	get_tree().call_group("mobs", "queue_free")


func _on_MobTimer_timeout():
	#create a new instance of the mob scene
	var mob = mob_scene.instance() 
	
	#choose a random location on Path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	var direction = mob_spawn_location.rotation + PI / 2
	#set mob's position to random location
	mob.position = mob_spawn_location.position 
	
	#add randomness to direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#choose velocity for the mob
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#spawn mob 
	add_child(mob)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
