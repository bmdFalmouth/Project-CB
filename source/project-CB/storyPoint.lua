import "CoreLibs/object"

--Table to store the story point data
StoryPointData={
    gameTime="00:00:00",
    assignedChannel=0,
    --this will most likely have to be a table of strings, after initial testing
    text="",
    soundFileName=""
}

class('StoryPoint',{gameTime="00:00:00",assignedChannel=0,text="",soundFileName=""}).extends()


function StoryPoint:init()
    StoryPoint.super.init(self)
    self.storyPointData={}
end

function StoryPoint:init(storyPointsData)
    StoryPoint.super.init(self)
    self.storyPointData=storyPointsData
end

function StoryPoint:init(gameTime,assignedChannel,text,soundFileName)
    StoryPoint.super.init(self)
    self.storyPointData={}
    self.storyPointData.gameTime=gameTime
    self.storyPointData.assignedChannel=assignedChannel
    self.storyPointData.text=text
    self.storyPointData.soundFileName="sound/"..soundFileName
    self.sound=nil
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
    print("Loading sound "..self.storyPointData.soundFileName)
    self.sound=playdate.sound.sampleplayer.new(self.storyPointData.soundFileName)
    if self.sound == nil then
        print("Sound not loaded")
    end
end

function StoryPoint:isSoundPlaying()
    return self.sound:isPlaying()
end

function StoryPoint:playSound()
    if(self.sound~=nil) then
        self.sound:play(1)
    end
end

function StoryPoint:stopSound()
    if(self.sound~=nil) then
        self.sound:stop()
    end
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

function StoryPointManager:init(num_channels)
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
        for j=0,num_channels do
            self.storyPoints[time][j]=nil
            print("Nil Story Point "..time.." "..j.." added")
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

function StoryPointManager:loadStoryPointsFromFile(fileName)
    --open a file
    local storyPointsData=json.decodeFile(fileName)
    printTable(storyPointsData.storypoints)
    if storyPointsData == nil then
        print("File not found")
        return
    end
    --loop through the story points and add them to the table
    for k,v in pairs(storyPointsData.storypoints) do
        print("Adding Story Point from json")
        --printTable(v["assignedChannel"].." "..v["gameTime"].." "..v["text"].." "..v["soundFileName"])
        local currentStoryPoint=StoryPoint(v["gameTime"],v["assignedChannel"],v["text"],v["soundFileName"])
        print(currentStoryPoint)
        self:addStoryPoint(currentStoryPoint)
    end
end

function StoryPointManager:addStoryPoint(storyPoint)
    print("Story Point "..storyPoint:getChannel().." added")
    --remove this at some point
    storyPoint:loadSound()
    self.storyPoints[storyPoint:getGameTime()][storyPoint:getChannel()]=storyPoint
end

function StoryPointManager:getStoryPoint(gameTime,channel)
    return self.storyPoints[gameTime][channel]
end

function StoryPointManager:getStoryPointsAtTime(gameTime)
    print("Getting a list of story points at time "..gameTime)
    return self.storyPoints[gameTime]
end