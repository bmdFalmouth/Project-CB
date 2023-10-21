import 'CoreLibs/object'

class('Scene',{renderQueue={}}).extends()


function Scene:init()
    Scene.super.init(self)
    self.renderQueue = {}
end

function Scene:load()
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