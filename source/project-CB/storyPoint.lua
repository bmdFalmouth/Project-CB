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

function StoryPoint:loadfile(fileName)
    --open a file
    local storyPointData=playdate.datastore.read(fileName)
    if storyPointData == nil then
        print("File not found")
        return
    end
    --read the file
    self.gameTime=storyPointData.gameTime
    self.assignedChannel=storyPointData.assignedChannel
    self.text=storyPointData.text
    self.soundFileName=storyPointData.soundFileName
end

function StoryPoint:loadSound()
    -- we should load the sound from a sound manager, instead of loading it here
    self.sound=playdate.sound.sampleplayer.new(self.soundFileName)
    if self.sound == nil then
        print("Sound not loaded")
    end
end

function StoryPoint:playSound()
    self.sound:play(0)
end

function StoryPoint:stopSound()
    self.sound:stop()
end

function StoryPoint:getText()
    return self.text
end

function StoryPoint:getChannel()
    return self.assignedChannel
end