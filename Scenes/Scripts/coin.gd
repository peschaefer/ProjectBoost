extends Area3D

signal collected(coin_id: int)
@export var disabled: bool = false

# Called when the player enters the coin's area
func _on_Coin_body_entered(body):
	if disabled:
		return
	if body.is_in_group("Player"):  # Ensure it's the player that collects the coin
		collected.emit(self.get_instance_id())  # Emit a collected signal to notify the game
