import "CoreLibs/object"

--Table to store the story point data
StoryPointData={
    gameTime="00:00:00",
    assignedChannel=0,
    text="",
    soundFileName=""
}

class('StoryPoint',{gameTime="00:00:00",assignedChannel=0,text="",soundFileName=""}).extends()


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
    hours=0
    minutes=0
    seconds=0
    --loop through the story points and add nil values to the table
    for i=0,60 do
        --the index should be a time code in hours, minutes and seconds
        seconds=string.format("%02d",seconds)
        minutes=string.format("%02d",minutes)
        hours=string.format("%02d",hours)
    
        time=hours..":"..minutes..":"..seconds
        self.storyPoints[time]={}
        for j=0,40 do
            self.storyPoints[time][j]=nil
        end
        seconds+=30
        if seconds>=60 then
            seconds=0
            minutes+=1
            if minutes>=60 then
                minutes=0
                hours+=1
            end
        end
    end
end

function StoryPointManager:addStoryPoint(storyPoint)
    print("Story Point "..storyPoint:getChannel().." added")
    self.storyPoints[storyPoint:getGameTime()][storyPoint:getChannel()]=storyPoint
end

function StoryPointManager:getStoryPoint(gameTime,channel)
    return self.storyPoints[gameTime][channel]
end

function StoryPointManager:getStoryPointsAtTime(gameTime)
    return self.storyPoints[gameTime]
end