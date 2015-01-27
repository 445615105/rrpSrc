
require("config")
require("cocos.init")
require("framework.init")

local MY_YELLOW = cc.c3b(247,238,214)

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)--��������ͼƬ

    for k, v in pairs(GAME_SFX) do--������������
        audio.preloadSound(v)
    end

    self:enterMenuScene()--����˵�����
end

function MyApp:enterMenuScene()
    self:enterScene("MenuScene", nil, "fade", 0.6,MY_YELLOW)
end

function MyApp:enterMainScene()
    self:enterScene("MainScene", nil, "fade", 0.6,MY_YELLOW)
end

appInstance = MyApp
return MyApp
