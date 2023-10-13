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

local function updateGame()
	angleChange=playdate.getCrankTicks(4)
	crankValueDelta=angleChange
	currentChannel+=crankValueDelta
	frequency+=crankValueDelta*0.01
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

local function drawGame()
	gfx.clear() -- Clears the screen
end

loadGame()

function playdate.update()
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
	gfx.drawText(string.format("%.3f", frequency),180,110)
	gfx.drawText(crankValueDelta,300,0)
end