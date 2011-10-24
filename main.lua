--[[
	Game main.lua
	@author: Minh Nguyen
	9/25/2011
	iPad: 1024x768, 132 ppi
	iPhone/iPod Touch: 320x480px, 163 ppi
	iPhone 4: 960x640, 326 ppi
	Google Nexus One: 480x80px, 254 ppi
	Motorola Droid X: 854x480px, 228 ppi
	HTC Evo: 480x800px, 217ppi
	Resources:
	http://mobile.tutsplus.com/tutorials/corona/corona-sdk_brick-breaker/
]]--


--> Hide status bar
display.setStatusBar(display.HiddenStatusBar)

-->Add physics enginge to use
local physics = require("physics")
physics.start()
--set gravity to act down to bottom of screen
physics.setGravity(0,4.8)
physics.setDrawMode("hybrid")

--> Add background image & initilize other variables
local background = display.newImage("bg.png")
local menuScreen	--> main menu group
local mScreen		--> main menu background image
local startB		--> start button
local aboutB		--> about button
local superB		--> magic button that does things
local gameScreen	--> game ON!!!
local bomb		--> bomb trying to kill base
local man		--> man prtecting base
local friend		--> friend going home

--create a table aka Object and objects can have states and their own operations/
local tweenMS = {}
--[[
--> Add Bombs
local bomb = display.newImage("bomb.png")
bomb.x = display.contentWidth/2
physics.addBody(bomb, { bounce = 0.2})

--> Add Floor
local floor = display.newImage("floor.png")
floor.y =  display.contentHeight - floor.contentHeight/2
physics.addBody(floor, "static", { bounce = 0.2 } );


--> define our touch event listener
function expload(event)
	bomb:applyLinearImpulse(0,-0.2, bomb.x, bomb.y)
end

timer.performWithDelay( 500, spawnBomb, 0)

-->adding the listener the bomb
bomb:addEventListener("touch", expload)
]]--

--Collision detection
local function onLocalCollision(self, event) 
	--print("DEATH!!!!!!")
--[[	
	local myText = display.newText("Fire!!!", 0, 0, native.systemFont, 16)
	myText:setTextColor(255, 255, 255)
 	i = 0;
	i = i + 1
	myText.text = i
	myText.size = 16
]]--	
	if(event.other.name == "fireball") then
		event.other.isVisible = false;	
		event.other:removeSelf()
		self.isVisible = false
		self:removeSelf()
	elseif(event.other.name == "floor") then
		print("NOOOOOOOOOOOOOOOO")
		self.isVisible = false;
		self:removeSelf()
	end
	
end

local function spawnBomb()
 	local bomb = display.newImage("bomb.png")
	bomb.x = math.random(320)
	bomb.y = -100
	bomb.name = "bomb"
	physics.addBody( bomb, {density=2.0, friction=0.5, bounce=0.2} )
	bomb.collision = onLocalCollision
	bomb:addEventListener( "collision", bomb);	
end

local function startGame()
--[[http://developer.anscamobile.com/content/group-display-objects
	Groups objects together, objects can be added and removed to a group
	group objects stay until they are explicityly removed
]]--
	menuScreen = display.newGroup()
	mScreen = display.newImage("menu.png")
	startB = display.newImage("start.png")
	startB.name = 'startB'
	aboutB = display.newImage("about.png")
	aboutB.name = 'aboutB'
	
	menuScreen:insert(mScreen)		
	startB.x = 160
	startB.y = 210
	menuScreen:insert(startB)
	aboutB.x = 160
	aboutB.y = 310
	menuScreen:insert(aboutB)

	-->listeners 
	-- Need to add here afeter we have initilized startB and aboutB
	startB:addEventListener('tap', tweenMS)
	aboutB:addEventListener('tap', tweenMS)
end


--[[
	use to calculate fireball path 
	code taken from: http://developer.anscamobile.com/forum/2010/11/17/math-helper-functions-distancebetween-and-anglebetween
]]--
local function angleBetween ( srcObj, dstObj )
 
        local xDist = dstObj.x-srcObj.x ; local yDist = dstObj.y-srcObj.y
        local angleBetween = math.deg( math.atan( yDist/xDist ) )
        if ( srcObj.x < dstObj.x ) then angleBetween = angleBetween+90 else angleBetween = angleBetween-90 end
        return angleBetween
end

local function fireball(e) 
	print("Fiiiiiiire!!!!\n", e.x)
	local fireball = display.newImage("fireball.png")
	fireball.x = man.x 
	fireball.y = man.y
	fireball.name = "fireball"
	physics.addBody(fireball, {bounce = 0.5})	
	fireball.collision = onLocalCollision
	--fireball:addEventListener( "collision", fireball);	

	local touch = {};
	touch.x = e.x;
	touch.y = e.y;
local angle =	angleBetween(touch, man);

	
	fireball:applyForce( (math.cos(math.rad(angle+90))*20), (math.sin(math.rad(angle+90))*20), fireball.x, fireball.y)		
end

local function addGameScreen() 
	local floor = display.newImage("floor.png");
	floor.y = display.contentHeight - floor.contentHeight/2;
	floor.name = "floor"
	physics.addBody( floor, "static", {friction=0.5, bounce=0.2})
	timer.performWithDelay( 500, spawnBomb, 0)
	
	man = display.newImage("man.png");
	man.y = floor.y - 60;
	man.x = display.contentWidth/2
	physics.addBody(man, "kinematic", {friction=0.5, bounce=0.2})	
	man.isSensor = true
	Runtime:addEventListener("tap", fireball)	
end


local function Main() 
	print("Hello Main function")	
	startGame()
end

--http://www.lua.org/pil/16.html#ObjectSec
function tweenMS:tap(e)
	-->http://developer.anscamobile.com/node/2407 
	if(e.target.name == 'startB' ) then
		--Start the game
		transition.to(menuScreen, {time = 3000, y = -menuScreen.height, transition = easing.outExpo, onComplete = addGameScreen()})
	else
        -- Call AboutScreen
        	aboutScreen = display.newImage('aboutScreen.png')
        	transition.from(aboutScreen, {time = 300, x = menuScreen.contentWidth, transition = easing.outExpo})
        --	aboutScreen:addEventListener('tap', hideAbout)
		startB.isVisible = false;
		aboutB.isVisible = false;
	end
end


--> Calling the function to start the game
Main()








