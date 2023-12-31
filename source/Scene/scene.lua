import 'CoreLibs/object'

class('Scene',{renderQueue={},nextScene=nil,name=""}).extends()


function Scene:init()
    Scene.super.init(self)
    self.renderQueue = {}
    self.nextScene = nil
    self.name=""
end

function Scene:getName()
    return self.name
end

function Scene:setName(name)
    self.name=name
end

--need to look at coroutines for this
function Scene:load()
end

function Scene:unload()
end

function Scene:addToRenderQueue(sprite)
    table.insert(self.renderQueue,sprite)
    print(#self.renderQueue)
end

function Scene:draw(gfx)
    for i=1,#self.renderQueue do
        self.renderQueue[i]:draw(gfx)
    end
end

function Scene:update()
    for i=1,#self.renderQueue do
        self.renderQueue[i]:update()
    end
end

function Scene:setNextScene(scene)
    self.nextScene=scene
end

class('SceneManager',{sceneList={},currentScene=nil}).extends()

function SceneManager:init()
    SceneManager.super.init(self)
    self.sceneList={}
    self.currentScene=nil
end

function SceneManager:addScene(scene)
    --check if a scene with the same name already exists in the scenelist table
    if (self.sceneList[scene:getName()]~=nil) then
        print("Scene with name "..scene:getName().." already exists")
        return
    else
        self.sceneList[scene:getName()]=scene
        currentScene=scene
    end
end

function SceneManager:setCurrentScene(scene)
    self.currentScene=scene
end

function SceneManager:getCurrentScene()
    return self.currentScene
end

function SceneManager:update()
    if self.currentScene~=nil then
        self.currentScene:update()
    end
end

function SceneManager:draw(gfx)
    if self.currentScene~=nil then
        self.currentScene:draw(gfx)
    end
end

sceneManager=SceneManager()