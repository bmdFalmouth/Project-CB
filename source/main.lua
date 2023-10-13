import "CoreLibs/graphics"
import "CoreLibs/object"

local gfx <const> = playdate.graphics



local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	local font = gfx.font.new('font/Mini Sans 2X') -- DEMO
	gfx.setFont(font) -- DEMO
	local background_sound=playdate.sound.sampleplayer.new('sound/Static-Looping')
	if background_sound == nil then
		print("Sound not loaded")
	end
	background_sound:play(0)
end

local function updateGame()
end

local function drawGame()
	gfx.clear() -- Clears the screen
end

loadGame()

function playdate.update()
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
end