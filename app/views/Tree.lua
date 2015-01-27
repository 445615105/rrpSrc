local TREE_WITH = 100
local TREE_HRIGHT = 100

local frames1 = display.newFrames("s_treeyellow_shake_%d.png", 1, 5)
local frames2 = display.newFrames("s_treegreen_shake_%d.png", 1, 5)

local Tree = class("Tree",function(id,para)
	local kind = para[1] or "yellow"
	--local node = display.newNode()
	--node.boSprite = display.newSprite("#s_treepole.png")
	--node:addChild(node.boSprite)
	--local tSize = node.boSprite:getContentSize()
	
	local node = display.newSprite("#s_treepole.png")
	local tSize = node:getContentSize()

	node.topSprite = display.newSprite("#s_treeyellow_shake_1.png")
	if kind == "yellow" then
		node.topSprite:playAnimationForever(display.newAnimation(frames1, math.random(8, 12)/100))
	elseif kind == "green" then
		node.topSprite:playAnimationForever(display.newAnimation(frames2, math.random(12, 19)/100))
	end
	node:addChild(node.topSprite)
	node.topSprite:setPosition(tSize.width/2,tSize.height/2)
	node.animSprite = display.newSprite()
	node:addChild(node.animSprite)
	node.animSprite:setPosition(tSize.width/2,tSize.height/2)
	--node:setScale(TREE_WITH/tSize.width,TREE_HRIGHT/tSize.height)
	node.id = id
	node.kind = kind
	node.inAction = 0
	return node
end)

function Tree:ctor()
	self:setNodeEventEnabled(true)
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		return self:onTouch(event.name, event.x, event.y)
	end)
end


function Tree:onTouch(event, x, y)
	print(self.id,x,y)
	if self.inAction == 0 then 
		self.inAction = 1
		if self.animSprite then
			self.animSprite:setVisible(true)
			if self.kind == "yellow" then
				frames3 = display.newFrames("e_leafyellow_%d.png", 1, 5)
				animation3 = display.newAnimation(frames3, 0.1)
			elseif self.kind == "green" then
				frames3 = display.newFrames("e_leafgreen_%d.png", 1, 5)
				animation3 = display.newAnimation(frames3, 0.15)
			end

	
			local sequence = cc.Sequence:create(
				self.animSprite:playAnimationOnce(animation3), 
				cc.CallFunc:create(
					function() 
						self.animSprite:setVisible(false) 
						self.inAction = 0
					end)
			)
			self.animSprite:runAction(sequence)
		end
	end

	--filter 测试代码
	local customParams = {
		--frag = "Shaders/outline.fsh",
		--shaderName = "OutlineShader",
		--u_outlineColor = {255/255,255/255,255/255},
		--u_radius = 1,
		--u_threshold = 1.75,
		--frag = "Shaders/example_Blur.fsh",
		--shaderName = "blurShader",
		--resolution = {480,320},
		--blurRadius = 5,
		--sampleNum = 3,
		frag = "Shaders/example_Noisy.fsh",
		shaderName = "noisyShader",
		resolution = {480, 320}
	}
	local par = json.encode(customParams)
	self._filterSprite = display.newFilteredSprite("#s_treeyellow_shake_1.png","CUSTOM",par)
	local tSize = self:getContentSize()
	self:addChild(self._filterSprite)
	self._filterSprite:setPosition(tSize.width/2,tSize.height/2)
	print("!!!")
end

return Tree
