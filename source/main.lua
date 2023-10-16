import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "Sprite/sprite"

local gfx <const> = playdate.graphics
local crankValueDelta=0

local currentChannel=0
local testSoundChannel <const> = 2

local background_sound=nil
local conversation_sound=nil

local systemFont=nil

local channelFont=nil

local currentChannelText=nil
local debugText=nil


-- CB Radio frequencies
-- https://www.rightchannelradios.com/blogs/newsletters/cb-radio-frequencies-and-channels#:~:text=The%20CB%20Radio%20spectrum%20is,noted%20in%20the%20table%20below.

--from https://devforum.play.date/t/a-list-of-helpful-libraries-and-code/221/18
function math.clamp(a, min, max)
    if min > max then
        min, max = max, min
    end
    return math.max(min, math.min(max, a))
end

--load game
local function loadGame()
	playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps
	math.randomseed(playdate.getSecondsSinceEpoch()) -- seed for math.random
	systemFont = gfx.font.new('font/Mini Sans 2X') -- DEMO
	channelFont = gfx.font.new('font/CursedTimerUlil-Aznm-20') 
	
	background_sound=playdate.sound.sampleplayer.new('sound/Static-Looping')
	if background_sound == nil then
		print("Sound not loaded")
	end
	background_sound:play(0)

	conversation_sound=playdate.sound.sampleplayer.new('sound/conversation')
	if conversation_sound == nil then
		print("Sound not loaded")
	end

	currentChannelText=TextSprite(180,110,channelFont,0)
	debugText=TextSprite(300,0,systemFont,"debug")
end

--update game
local function updateGame()
	--get crank ticks, this will update every 180 degrees( 360 / 2 )
	crankValueDelta=playdate.getCrankTicks(2)
	currentChannel+=crankValueDelta
	currentChannel=math.clamp(currentChannel,0,40)
	currentChannelText:setText(currentChannel)

	debugText:setText(crankValueDelta)

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
	
	gfx.setFont(systemFont) -- DEMO
	playdate.drawFPS(0,0) -- FPS widget
	-- debug crank value
	debugText:draw(gfx)
	currentChannelText:draw(gfx)

end

-- call load game function
loadGame()

-- call back update function, game loop
function playdate.update()
	updateGame()
	drawGame()
end