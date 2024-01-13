extends Node


var playerHP = 3
var money = 0
var lives = 5
var level = 1
var state = 'alive'
var cameraLimit = Vector2(0, 0)

var powerSwitch = true

var playerNodeCurrentPath = "../../Player/Player"

# Game data
## Collected diamonds, (secret), level1, 2, 3..., only 4 levels.
var diamonds = [false, false, false, false, false]
