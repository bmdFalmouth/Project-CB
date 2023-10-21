import "CoreLibs/graphics"
import "CoreLibs/object"

import "Sprite/sprite"
import "Scene/scene"

class('MainMenuScene').extends(Scene)

function MainMenuScene:init()
    MainMenuScene.super.init(self)
    self.name="MainMenuScene"
end

local systemFont=nil

function MainMenuScene:load()
    systemFont = playdate.graphics.font.new('font/Mini Sans 2X') -- DEMO
    mainMenuText=TextSprite(100,120,systemFont,"Press A to start")
    self:addToRenderQueue(mainMenuText)
end

function MainMenuScene:update()
    MainMenuScene.super.update(self)
    if (playdate.buttonJustReleased(playdate.kButtonA)) then
        self:startGame()
    end
end

function MainMenuScene:startGame()
    print("Start Game")
    self.nextScene:load()
    sceneManager:setCurrentScene(self.nextScene)
end