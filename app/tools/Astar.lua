--local map = {
		--{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        --{ 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1},
        --{ 1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1},
        --{ 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1},
        --{ 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1},
        --{ 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
        --{ 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1},
        --{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
--}

local Point = {}
Point.creatPoint = function(x,y)
	local p = {}
	p.x = x
	p.y = y
	p.G = 0
	p.H = 0
	p.F = 0
	p.parent = nil
	p.CF = function(p)
		p.F = p.G + p.H
		return p.F
	end
	return p
end

local ListHelper = {}
ListHelper.ExistsPoint = function(ps,p)
	for i = 1,#ps do
		if type(ps[i]) == "table" and ps[i].x == p.x and ps[i].y == p.y then
			return true
		end
	end
	return false
end

ListHelper.ExistsXY = function(ps,x,y)
	for i = 1,#ps do
		if type(ps[i]) == "table" and ps[i].x == x and ps[i].y == y then
			return true
		end
	end
	return false
end

ListHelper.MinFPoint = function(ps)--找到表里的最小F
	local p = nil
	for i = 1,#ps do
		if type(ps[i]) == "table" then
			p = ps[i]
			break
		end
	end
	if p then
		for i = 2,#ps do
			local lt = ps[i]
			if type(ps[i]) == "table" and ps[i].F < p.F then
				p = ps[i]
			end
		end
	end
	return p
end

ListHelper.Add = function(ps,xx,yy)
	for i = 1,#ps do
		if ps[i] == 0 then
			ps[i] = Point.creatPoint(xx,yy)
			return
		end
	end
	ps[#ps + 1] = Point.creatPoint(xx,yy)
end

ListHelper.AddPoint = function(ps,p)
	for i = 1,#ps do
		if ps[i] == 0 then
			ps[i] = p
			return
		end
	end
	ps[#ps + 1] = p
end

ListHelper.Get = function(ps,p)
	for i = 1,#ps do
		if type(ps[i]) == "table" and ps[i].x == p.x and ps[i].y == p.y then
			return ps[i]
		end
	end
	return nil
end

ListHelper.Remove = function(ps,x,y)
	for i = 1,#ps do
		if type(ps[i]) == "table" and ps[i].x == x and ps[i].y == y then
			ps[i] = 0
		end
	end
end

ListHelper.CountTable = function(ps)
	local v = 0
	for i = 1,#ps do
		if type(ps[i]) == "table" then
			v = v + 1
		end
	end
	return v
end

local Maze = {}
Maze.OBLIQUE = 14
Maze.STEP = 10
Maze.OpenList = {}
Maze.CloseList = {}
Maze.MazeArray = {}

Maze.CalcG = function(sp,p)
	local G = 0
	if math.abs(sp.x - p.x) + math.abs(sp.y - p.y) == 1 then
		G = Maze.STEP
	else
		G = Maze.OBLIQUE
	end
	local pG = 0
	if p.parent then
		pG = p.parent.G
	end
	
	return (G + pG)
end

Maze.CalcH = function(ep,p)
	local step = math.abs(ep.x - p.x) + math.abs(ep.y - p.y)
	return(step * Maze.STEP)
end

Maze.FoundPoint = function(tp,p)
	local G = Maze.CalcG(tp,p)
	if G < p.G then
		p.parent = tp
		p.G = G
		p:CF()
	end
end

Maze.NotFoundPoint = function(tp,ep,p)
	p.parent = tp
	p.G = Maze.CalcG(tp,p)
	p.H = Maze.CalcH(ep,p)
	p:CF()
	ListHelper.AddPoint(Maze.OpenList,p)
end

Maze.CanReachXY = function(x,y)
	if Maze.MazeArray[y][x] == 0 then
		return true
	else
		return false
	end
end

Maze.CanReach = function(sp,x,y,canpass)
	if Maze.CanReachXY(x,y) == false or ListHelper.ExistsXY(Maze.CloseList,x,y) == true then
		return false
	else
		if math.abs(sp.x - x) + math.abs(sp.y - y) == 1 then
			return true
		elseif math.abs(sp.x - x) == 1 and math.abs(sp.y - y) == 1 then--斜方向移动 看canpass决定允不允许
			return canpass
		else
			return false
		end
	end
end

Maze.SurrroundPoints = function(p,canpass)
	local sps = {}
	local sy = math.max(p.y - 1,1)
	local ey = math.min(p.y + 1,#Maze.MazeArray)
	for i = sy,ey do
		local sx = math.max(p.x - 1,1)
		local ex = math.min(p.x + 1,#Maze.MazeArray[i])
		for j = sx,ex do
			if Maze.CanReach(p,j,i,canpass) == true then
				ListHelper.Add(sps,j,i)
			end
		end
	end
	return sps
end

Maze.FindPath = function(sp,ep,canpass)
	ListHelper.AddPoint(Maze.OpenList,sp)
	while(ListHelper.CountTable(Maze.OpenList) ~= 0) do
		local tempSp = ListHelper.MinFPoint(Maze.OpenList)
		ListHelper.Remove(Maze.OpenList,tempSp.x,tempSp.y)
		ListHelper.AddPoint(Maze.CloseList,tempSp)
		
		local surroundPoints = Maze.SurrroundPoints(tempSp,canpass)
		for i = 1,#surroundPoints do
			if ListHelper.ExistsPoint(Maze.OpenList,surroundPoints[i]) then
				Maze.FoundPoint(tempSp,surroundPoints[i])
			else
				Maze.NotFoundPoint(tempSp,ep,surroundPoints[i])
			end
		end
		local epp = ListHelper.Get(Maze.OpenList,ep)
		if epp ~= nil then
			return epp
		end
	end
	return ListHelper.Get(Maze.OpenList,ep)
end

--Maze.MazeArray = map
--local p = Maze.FindPath(sp,ep,true)

Astar = function(map,sx,sy,ex,ey,canpass)
	Maze.MazeArray = map
	local sp = Point.creatPoint(sx,sy)
	local ep = Point.creatPoint(ex,ey)
	local p = Maze.FindPath(sp,ep,canpass)
	local path = {}
	if p then
		path[#path + 1] = {x = p.x,y = p.y}
		local pp = p.parent
		while (pp) do
			path[#path + 1] = {x = pp.x,y = pp.y}
			pp = pp.parent
		end
	end
	local rpath = {}
	if #path > 0 then
		for i = #path,1,-1 do
			rpath[#rpath + 1] = path[i]
		end
	end
	for i = 1,#Maze.OpenList do
		Maze.OpenList[i] = 0
	end
	for i = 1,#Maze.CloseList do
		Maze.CloseList[i] = 0
	end
	return rpath
end

--local a = Astar(map,2,7,6,2,true)
--for i = 1,#a do
	--print(a[i].x,a[i].y,i)
--end
