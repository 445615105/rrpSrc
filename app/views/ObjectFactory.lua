ObjectFactory = {}--��Ϸ�������������
local idindex = 0

ObjectFactory.creat = function(kind,para,father,x,y)--���� �����б� x y
	idindex = idindex + 1
	local temp = kind.new(idindex,para)
	father.Objs[#father.Objs + 1] = temp
	temp:setPosition(x,y)
	--if father.batch then
		--father.batch:addChild(temp,display.height - y)
	--else
		father:addChild(temp,display.height - y)
	--end
end

return ObjectFactory