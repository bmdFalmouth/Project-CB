import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/timer"
import "Math/math"

import "Sprite/sprite"
import "Project-CB"
import "mainMenu"

local gfx <const> = playdate.graphics


--load game
local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random

	--init scenes
	local mainMenuScene=MainMenuScene()
	mainMenuScene:load()


	local gameScene=ProjectCBScene()
	mainMenuScene:setNextScene(gameScene)

	sceneManager:addScene(gameScene)
	sceneManager:addScene(mainMenuScene)
	sceneManager:setCurrentScene(mainMenuScene)
end

--update game
local function updateGame()
	sceneManager:update()
end

-- draw game
local function drawGame()
	gfx.clear() -- Clears the screen
	
	gfx.setFont(systemFont) -- DEMO
	playdate.drawFPS(0,0) -- FPS widget

	sceneManager:draw(gfx)

end

-- call load game function
loadGame()

-- call back update function, game loop
function playdate.update()
	playdate.timer.updateTimers()
	updateGame()
	drawGame()
end
