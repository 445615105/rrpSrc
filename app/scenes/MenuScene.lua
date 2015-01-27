local BubbleButton = import("..views.BubbleButton")

local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

function MenuScene:ctor()
    --����
    self.bg = display.newSprite("#s_map.png", display.cx, display.cy)
    local tSize = self.bg:getContentSize()
    self.bg:setScale(display.width/tSize.width,display.height/tSize.height)
    self:addChild(self.bg)
    --��ť
    self.startButton = BubbleButton.new({
            image = "#i_wstart.png",
            --sound = nil,
            prepare = function()
                --audio.playSound(GAME_SFX.tapButton)
                --self.startButton:setButtonEnabled(false)
            end,
            listener = function()
		self.startButton:setButtonEnabled(false)
            app:enterScene("Stage001",nil,"fade",1.1)
            end,
        })
        :pos(display.cx,display.cy)
        :addTo(self)

	--audio.playSound(GAME_SFX.bg_menu)
end
--������
function MenuScene:onEnter()
	print("menu in")
	--audio.resumeMusic()
	self.startButton:setButtonEnabled(true)
end
--������
function MenuScene:onExit()
	print("menu out")
	--audio.pauseMusic()
	self.startButton:setButtonEnabled(true)
end

return MenuScene
