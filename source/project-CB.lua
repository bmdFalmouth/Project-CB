
-- CB Radio frequencies
-- https://www.rightchannelradios.com/blogs/newsletters/cb-radio-frequencies-and-channels#:~:text=The%20CB%20Radio%20spectrum%20is,noted%20in%20the%20table%20below.

import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/timer"
import "Math/math"


import "Sprite/sprite"
import "Scene/scene"
import "project-CB/storyPoint"

class('ProjectCBScene').extends(Scene)

local currentChannel=0
local testSoundChannel <const> = 2

local background_sound=nil
local conversation_sound=nil

local systemFont=nil

local channelFont=nil

local currentChannelText=nil
local debugText=nil

--every 5 minutes is 1 game hour
local gameTime=0

local currentStoryPoint=nil

local storyPointManager=nil

function ProjectCBScene:init()
    ProjectCBScene.super.init(self)
	self.name="GameScene"
end

function ProjectCBScene:load()
    systemFont = playdate.graphics.font.new('font/Mini Sans 2X') -- DEMO
	channelFont = playdate.graphics.font.new('font/CursedTimerUlil-Aznm-20')
	
	background_sound=playdate.sound.sampleplayer.new('sound/Static-Looping')
	if background_sound == nil then
		print("Sound not loaded")
	end
	background_sound:play(0)

	currentChannelText=TextSprite(180,110,channelFont,0)
	debugText=TextSprite(300,0,systemFont,"debug")

    self:addToRenderQueue(currentChannelText)
	self:addToRenderQueue(debugText)

	--load story point
	currentStoryPoint=StoryPoint(1,testSoundChannel,"This is a test story point","sound/conversation")
	currentStoryPoint:loadSound()

	storyPointManager=StoryPointManager()
	storyPointManager:addStoryPoint(currentStoryPoint)

	playdate.resetElapsedTime()
	playdate.timer.keyRepeatTimerWithDelay(1000,1000,ProjectCBScene.gameTimerUpdate)

end

function ProjectCBScene:gameTimerUpdate()
	print("Game Timer Update")
	gameTime+=1
	
	local seconds=gameTime%60
	local minutes=math.floor(gameTime/60)
	local hours=math.floor(minutes/60)

	seconds=string.format("%02d",seconds)
	minutes=string.format("%02d",minutes)
	hours=string.format("%02d",hours)
	time=hours..":"..minutes..":"..seconds
	debugText:setText(time)
end

function ProjectCBScene:update()
    ProjectCBScene.super.update(self)

    --get crank ticks, this will update every 180 degrees( 360 / 2 )
	crankValueDelta=playdate.getCrankTicks(2)
	currentChannel+=crankValueDelta
	currentChannel=math.clamp(currentChannel,0,40)
	currentChannelText:setText(currentChannel)

	-- test stuff to work on interrupting background sound with conversation sound  (will be reworked)
	if (currentChannel==currentStoryPoint:getChannel()) then
		if (background_sound:isPlaying()) then
			background_sound:stop()
		end
		if (currentStoryPoint:isSoundPlaying()==false) then
			currentStoryPoint:playSound()
		end
	else
		if (currentStoryPoint:isSoundPlaying()) then
			currentStoryPoint:stopSound()
		end
		if (background_sound:isPlaying()==false) then
			background_sound:play(0)
		end
	end
end



