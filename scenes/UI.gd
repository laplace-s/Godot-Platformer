extends CanvasLayer

@onready var notification_tile = $NotificationTile
@onready var label = $NotificationTile/Text
@onready var notif_timer = $notifTimer

var showing = false
var pause = false
var gameover = false
const IN_POS = Vector2(-500, 100)
const OUT_POS = Vector2(-20, 100)
@onready var pauseUI = $pause
@onready var text = $pause/container/Text

func _physics_process(delta):
	if showing :
		notification_tile.position.x = lerp(notification_tile.position.x, OUT_POS.x, 0.1)
	else : 
		notification_tile.position.x = lerp(notification_tile.position.x, IN_POS.x, 0.1)

func _input(event):
	if event.is_action_pressed("pause"):
		togglePause(false)

func notify(text:String, time :float = 5):
	notif_timer.wait_time = time
	notification_tile.position = IN_POS
	label.text = text
	notification_tile.visible = true
	notif_timer.start()
	showing = true
	
func togglePause(gameovert:bool):
	if gameover:
		return
	pause = not pause
	pauseUI.visible = pause
	if not pause:
		Engine.time_scale = 1
		return
	Engine.time_scale = 0
	if gameovert :
		gameover = true
		text.text = "Game Over\n Yes that's all the game is about."
	else :
		text.text = "Paused."

func _on_notif_timer_timeout():
	showing = false
