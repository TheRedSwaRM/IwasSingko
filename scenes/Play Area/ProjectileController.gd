extends RigidBody2D

@onready var coll = $CollisionPolygon2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	coll.call_deferred("set","disabled",false)
	hide()
	queue_free()
