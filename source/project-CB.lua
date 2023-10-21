import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "Math/math"


import "Sprite/sprite"
import "Scene/scene"

class('ProjectCBScene').extends(Scene)

local currentChannel=0
local testSoundChannel <const> = 2

local background_sound=nil
local conversation_sound=nil

local systemFont=nil

local channelFont=nil

local currentChannelText=nil
local debugText=nil

function ProjectCBScene:init()
    ProjectCBScene.super.init(self)
end

function ProjectCBScene:load()
    systemFont = playdate.graphics.font.new('font/Mini Sans 2X') -- DEMO
	channelFont = playdate.graphics.font.new('font/CursedTimerUlil-Aznm-20') 
	
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

    self:addToRenderQueue(currentChannelText)
	self:addToRenderQueue(debugText)
end

function ProjectCBScene:update()
    ProjectCBScene.super.update(self)
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



