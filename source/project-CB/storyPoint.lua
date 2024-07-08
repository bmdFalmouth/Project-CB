import "CoreLibs/object"

--Table to store the story point data
StoryPointData={
    gameTime=0.0,
    assignedChannel=0,
    text="",
    soundFileName=""
}

class('StoryPoint',{gameTime=0.0,assignedChannel=0,text="",soundFileName=""}).extends()


function StoryPoint:init()
    StoryPoint.super.init(self)
    self.storyPointData={}
end

function StoryPoint:init(gameTime,assignedChannel,text,soundFileName)
    StoryPoint.super.init(self)
    self.storyPointData={}
    self.storyPointData.gameTime=gameTime
    self.storyPointData.assignedChannel=assignedChannel
    self.storyPointData.text=text
    self.storyPointData.soundFileName=soundFileName
end

function StoryPoint:loadFromFile(fileName)
    --open a file
    self.storyPointData=playdate.datastore.read(fileName)
    if self.storyPointData == nil then
        print("File not found")
        return
    end
end

function StoryPoint:loadSound()
    -- we should load the sound from a sound manager, instead of loading it here
    self.sound=playdate.sound.sampleplayer.new(self.storyPointData.soundFileName)
    if self.sound == nil then
        print("Sound not loaded")
    end
end

function StoryPoint:isSoundPlaying()
    return self.sound:isPlaying()
end

function StoryPoint:playSound()
    self.sound:play(0)
end

function StoryPoint:stopSound()
    self.sound:stop()
end

function StoryPoint:getText()
    return self.storyPointData.text
end

function StoryPoint:getChannel()
    return self.storyPointData.assignedChannel
end

function StoryPoint:getGameTime()
    return self.storyPointData.gameTime
end

class ('StoryPointManager').extends()

function StoryPointManager:init()
    StoryPointManager.super.init(self)
    self.storyPoints={{}}
end

function StoryPointManager:addStoryPoint(storyPoint)
    print("Story Point "..storyPoint:getChannel().." added")
    self.storyPoints[storyPoint:getGameTime()][storyPoint:getChannel()]=storyPoint
end

function StoryPointManager:getStoryPoint(gameTime,channel)
    return self.storyPoints[gameTime][channel]
end

function StoryPointManager:getStoryPointAtTime(gameTime)
    return self.storyPoints[gameTime]
end