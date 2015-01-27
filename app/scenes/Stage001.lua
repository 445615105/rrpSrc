--class tree
local Tree = import("..views.Tree")
--class gameobject
local ObjectFactory = import("..views.ObjectFactory")

local Stage001 = class("Stage001", function()
    return display.newScene("Stage001")
end)

function Stage001:ctor()
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
    
    display.newSprite("i_hammer.png")
        :pos(display.cx, display.cy)
        :addTo(self)

    local node = display.newSprite("u_woodbar_3.png")
    local tSize = node:getContentSize()
    --node:setScale(TREE_WITH/tSize.width,TREE_HRIGHT/tSize.height)
    display.newSprite("u_woodbar_3.png")
        --:pos(display.cx, display.cy-1024)
        :pos(display.cx, display.bottom+tSize.height/2)
        :addTo(self)

end

function Stage001:onEnter()
end

function Stage001:onExit()
end

return Stage001