@abstract class_name Minigame extends Node2D

# must set internal parameters based on difficulty
@abstract func load(difficulty: int)

# minigame should emit this signal on end condition
# if minigame is lost is_success should be false
# if minigame is won is_success should be true
# bonus_time_gained should be the reward for the completed challenge
# bonus_time_gained should be higher for "perfect" or faster completions
signal on_minigame_end(is_success: bool, bonus_time_gained: int)
