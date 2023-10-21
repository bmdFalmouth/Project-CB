import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "Math/math"


import "Sprite/sprite"
import "Project-CB"

local gfx <const> = playdate.graphics

local gameScene=nil


-- CB Radio frequencies
-- https://www.rightchannelradios.com/blogs/newsletters/cb-radio-frequencies-and-channels#:~:text=The%20CB%20Radio%20spectrum%20is,noted%20in%20the%20table%20below.


--load game
local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	
	gameScene=ProjectCBScene()
	gameScene:load()
end

--update game
local function updateGame()
	gameScene:update()
end

-- draw game
local function drawGame()
	gfx.clear() -- Clears the screen
	
	gfx.setFont(systemFont) -- DEMO
	playdate.drawFPS(0,0) -- FPS widget
	-- debug crank value
	--debugText:draw(gfx)
	--currentChannelText:draw(gfx)
	gameScene:draw(gfx)

end

-- call load game function
loadGame()

-- call back update function, game loop
function playdate.update()
	updateGame()
	drawGame()
end