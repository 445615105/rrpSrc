--class tree
local Tree = import("..views.Tree")
--class gameobject
local ObjectFactory = import("..views.ObjectFactory")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    --green background
    self.bg = display.newSprite("#s_map.png", display.cx, display.cy)
    local tSize = self.bg:getContentSize()
    self.bg:setScale(display.width/tSize.width,display.height/tSize.height)
    self:addChild(self.bg)
    self.Objs = {}

    self.batch = display.newBatchNode(GAME_TEXTURE_IMAGE_FILENAME)
    self.batch:setPosition(0, 0)
    self:addChild(self.batch)

    math.randomseed(os.time())
    for i = 1,15 do
	local c = math.random(1, 2)
	   if c == 1 then
	       ObjectFactory.creat(Tree,{"yellow"},
	                           self,
	                           math.random(0+100, display.width-100), 
	                           math.random(0+100, display.height-100))
	   elseif c == 2 then
		   ObjectFactory.creat(Tree,{"green"},
		                      self,
		                      math.random(0+100, display.width-100), 
		                      math.random(0+100, display.height-100))
	   end
    end
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
