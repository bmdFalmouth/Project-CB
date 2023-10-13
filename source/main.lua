import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"

local gfx <const> = playdate.graphics
local frequency=26.965
local crankValueDelta=0

local currentChannel=0
local testSoundChannel <const> = 2

local background_sound=nil
local conversation_sound=nil


-- CB Radio frequencies
-- https://www.rightchannelradios.com/blogs/newsletters/cb-radio-frequencies-and-channels#:~:text=The%20CB%20Radio%20spectrum%20is,noted%20in%20the%20table%20below.


--load game
local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	local font = gfx.font.new('font/Mini Sans 2X') -- DEMO
	gfx.setFont(font) -- DEMO
	background_sound=playdate.sound.sampleplayer.new('sound/Static-Looping')
	if background_sound == nil then
		print("Sound not loaded")
	end
	background_sound:play(0)

	conversation_sound=playdate.sound.sampleplayer.new('sound/conversation')
	if conversation_sound == nil then
		print("Sound not loaded")
	end
end

--update game
local function updateGame()
	--get crank ticks, this will update every 90 degrees( 360 / 4 )
	angleChange=playdate.getCrankTicks(4)
	-- change the logical channel and frequency based on the crank ticks
	crankValueDelta=angleChange
	currentChannel+=crankValueDelta
	-- frequency is 26.965 to 27.405 and will go up in 10khz increments
	frequency+=crankValueDelta*0.01
	-- test stuff to work on interrupting background sound with conversation sound  (will be reworked)
	if (currentChannel==testSoundChannel) then
		
		if (background_sound:isPlaying()) then
			background_sound:stop()
		end
		if (conversation_sound:isPlaying()==false) then
			conversation_sound:play(0)
		end
	else
		if (conversation_sound:isPlaying()) then
			conversation_sound:stop()
		end
		if (background_sound:isPlaying()==false) then
			background_sound:play(0)
		end
	end

end

-- draw game
local function drawGame()
	gfx.clear() -- Clears the screen
	playdate.drawFPS(0,0) -- FPS widget
	-- draw the frequency capped at 3 decimal places
	gfx.drawText(string.format("%.3f", frequency),180,110)
	-- debug crank value
	gfx.drawText(crankValueDelta,300,0)
end

-- call load game function
loadGame()

-- call back update function, game loop
function playdate.update()
	updateGame()
	drawGame()
end