# GdUnit generated TestSuite
class_name EnemyManagerTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
# TestSuite generated from
const __source = "res://scripts/enemy_manager.gd"


func test_enemy_prob_comp() -> void:
	var enemy_manager = auto_free(load(__source).new())
	var enemy_scene := mock(PackedScene)
	var enemy = auto_free(enemy_manager.EnemyType.new(enemy_scene, 1))
	assert_bool(enemy_manager.enemy_prob_comp(enemy, 2.0)).is_true()
	assert_bool(enemy_manager.enemy_prob_comp(enemy, 0.5)).is_false()


func test_pick_enemy() -> void:
	var enemy_manager = auto_free(load(__source).new())
	assert_object(enemy_manager.pick_enemy()).is_not_null().is_instanceof(enemy_manager.EnemyType)


func test_spawn_enemies(
	count: int, test_parameters := [[1], [2], [10], [20], [100], [1000]]
) -> void:
	var enemy_manager = auto_free(load(__source).new())
	var player := mock(Player) as Player
	enemy_manager.player = player
	enemy_manager.spawn_enemies(count)
	assert_int(enemy_manager.get_child_count()).is_equal(count)
	for enemy in enemy_manager.get_children():
		assert_object(enemy).is_instanceof(Node)
		assert_vector2(enemy.position).is_not_equal(Vector2(0, 0))
		assert_bool(enemy.is_in_group("enemy")).is_true()
