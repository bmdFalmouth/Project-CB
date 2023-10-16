import "CoreLibs/object"
import "CoreLibs/graphics"

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