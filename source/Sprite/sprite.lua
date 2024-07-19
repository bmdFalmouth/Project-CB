import "CoreLibs/object"
import "CoreLibs/graphics"
import 'CoreLibs/easing'
import 'CoreLibs/animator'

local g = playdate.graphics
--Base Sprite for visible things on the screen
class('BaseSprite',{x=0,y=0,width=10,height=10}).extends()

function BaseSprite:init(x,y)
    BaseSprite.super.init(self)
    self.x=x
    self.y=y
end

function BaseSprite:setPosition(x,y)
    self.x=x
    self.y=y
end

function BaseSprite:setSize(width,height)
    self.width=width
    self.height=height
end

function BaseSprite:draw(gfx)
    --print("BaseSprite:draw()")
end

function BaseSprite:update()
    --print("BaseSprite:update()")
end

--Image Sprite for all sprites that use images
class('ImageSprite').extends(BaseSprite)

function ImageSprite:init(x,y,image)
    ImageSprite.super.init(self,x,y)
    self.image=image
end

function ImageSprite:draw(gfx)
    gfx.drawImage(self.image,self.x,self.y)
end

-- Text Sprite for all sprites that use text
class('TextSprite').extends(BaseSprite)

function TextSprite:init(x,y,font,text)
    TextSprite.super.init(self,x,y)
    self.font=font
    self.text=text
end

function TextSprite:setText(text)
    self.text=text
end

function TextSprite:draw(gfx)
    gfx.setFont(self.font)
    gfx.drawText(self.text,self.x,self.y)
end

-- Refactor of this code, credit to Neven Mrgan
-- https://devforum.play.date/t/text-dialog-boxes-animated-text/4009/9
class('TextBoxSprite').extends(TextSprite)

function TextBoxSprite:init(x,y,width,height,font,text)
    TextBoxSprite.super.init(self,x,y,font,text)
    self.width=width
    self.height=height
    self.currentChar = 1 -- we'll use these for the animation
    self.typing = true
    self.currentText = ""
    self.background=g.sprite.new()
    self.background:setSize(playdate.geometry.size.new(width, height))
    self.background:moveTo(x, y)
    self.background:setZIndex(900)
    self.frameRate=10
    self.frameCounter=0
    self.visible = false
    --self.animators={animatorIn=g.animator.new(500,450,y,playdate.easingFunctions.kEaseOut),
    --animatorOut=g.animator.new(500,y,450,playdate.easingFunctions.kEaseIn)}
    self.currentAnimator=g.animator.new(500,450,y,playdate.easingFunctions.kEaseOut)
end

-- https://sdk.play.date/2.5.0/Inside%20Playdate.html#C-graphics.animator
function TextBoxSprite:start()
    print("TextBoxSprite:stat()")
    self.typing = true
    self.visible = true
    --self.currentAnimator=self.animators.animatorIn
    --self.currentAnimator.reset()
end

function TextBoxSprite:stop()
    print("TextBoxSprite:stop()")
    self.typing = false
    self.visible = false
    --self.currentAnimator=self.animators.animatorIn
    --self.currentAnimator.reset()
end

function TextBoxSprite:reset()
    print("TextBoxSprite:reset()")
    self.typing = false
    self.currentChar = 1
    self.currentText = ""
end

--will have to update this based on the time
function TextBoxSprite:update()
    TextBoxSprite.super.update(self)
    --update this every second
    if (self.visible == false) then
        return
    end

    if self.frameCounter%self.frameRate==0 then
        self.currentChar = self.currentChar + 1
    end
	
    self.frameCounter+=1

	if self.currentChar > #self.text then
		self.currentChar = #self.text
	end
	
	if self.typing and self.currentChar <= #self.text then
		self.currentText = string.sub(self.text, 1, self.currentChar)		
		self.background:markDirty() -- this tells the sprite that it needs to redraw
	end
	
	-- end typing
	if self.currentChar == #self.text then
		self.currentChar = 1
		self.typing = false	
	end	
    
end

-- this function defines how this sprite is drawn
function TextBoxSprite:draw(gfx)
    --TextBoxSprite.super.draw(self)
	if (self.visible == false) then
        return
    end
    currentYPosition=self.currentAnimator:currentValue()
	-- pushing context means, limit all the drawing config to JUST this block
	-- that way, the colors we set etc. won't be stuck
	gfx.pushContext(self.background)
        gfx.setFont(self.font)
		-- draw the box				
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(self.x,currentYPosition,self.width,self.height)
		
		-- border
		gfx.setLineWidth(4)
		gfx.setColor(gfx.kColorBlack)
		gfx.drawRect(self.x,currentYPosition,self.width,self.height)

        gfx.setLineWidth(2)
		gfx.setColor(gfx.kColorBlack)
		gfx.drawRect(self.x+4,currentYPosition+4,self.width-8,self.height-8)
		
		-- draw the text!
		gfx.drawTextInRect(self.currentText, self.x+20, currentYPosition+20, self.width-20, self.height-20)
	
	gfx.popContext()
	
end