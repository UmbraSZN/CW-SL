--MAKE THIS CODE WORK WITH SLASH REQUIRE ETC
function love.load()
    --move to conf??
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(1920, 1080, {fullscreen = false, resizable=true, vsync=false, minwidth=960, minheight=540}) --vsync might cause tearing? add it to settings to enable/disable

    wf = require "libraries/windfield"
    world = wf.newWorld(0, 0, false)
    world:addCollisionClass("Player")
    world:addCollisionClass("Wall")
    world:addCollisionClass("Button")
    world:addCollisionClass("Enemy")
    anim8 = require "libraries/anim8"
    require "src/effects"
    require "src/sprites"
    require "src/player"
    require "src/enemies/enemy"
    camera = require "libraries/camera"
    sti = require "libraries/sti"
    cam = camera(0, 0, 3)
    gameMap = sti("assets/img/maps/Overworld Map.lua")


    --MOVE LATER
    asd = world:newCircleCollider(150, 100, 8)
    asd:setCollisionClass("Enemy")
    asd.x = asd:getX()
    asd.y = asd:getX()
    asd.speed = 80
    asd.health = 100


    walls = {}
    if gameMap.layers["Collisions"] then
        for i, obj in pairs(gameMap.layers["Collisions"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setCollisionClass("Wall")
            wall:setType("static")
            table.insert(walls, wall)
        end
    end
end

function love.update(dt)
    
    --move to update file?
    player:update(dt)
    world:update(dt)
    effects:update(dt)

    player.x = player:getX()
    player.y = player:getY()

    cam:lookAt(player.x, player.y)

    local w  = love.graphics.getWidth() / 3
    local h = love.graphics.getHeight() / 3

    --left
    if cam.x < w/2 then
        cam.x = w/2
    end
    --top
    if cam.y < h/2 then
        cam.y = h/2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    --right
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end
    --bottom
    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2) 
    end
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Ground"])
        gameMap:drawLayer(gameMap.layers["Ground acc"])
        gameMap:drawLayer(gameMap.layers["Walls"])
        gameMap:drawLayer(gameMap.layers["Walls border"])
        gameMap:drawLayer(gameMap.layers["Trees&more"])
        gameMap:drawLayer(gameMap.layers["Houses"])
        gameMap:drawLayer(gameMap.layers["Bridges"])

        player:draw()
    cam:detach()
end


--activate hitboxes for debugging
function love.keypressed(key)

    if key == "p" then --collision toggle
        player.showCollisions = not player.showCollisions
        world:setQueryDebugDrawing(true)

    elseif key == "o" then --TEMPORARY TESTING OF ENEMY SPAWNING
        enemies:spawn(80, 100, "goblin")

    elseif key == "escape" then --settings
        print("settings")

    elseif key == "q" then --dash
        print("dash")
    
    elseif key == "e" then --interact

        local px, py = player.x, player.y
        if player.dir == "right" then
            px = px + 10
        elseif player.dir == "left" then
            px = px - 10
        elseif player.dir == "down" then
            py = py + 10
        elseif player.dir == "up" then
            py = py - 10
        end

        local colliders = world:queryCircleArea(px, py, 12, {"Button"})
        for i, collider in ipairs(colliders) do
            print("interact")
            --add extra
        end

    elseif key == "f" then --blocking
        print("block")

    --add more
    end
end

--THIS IS WHAT I AM ADDING NEXT(ATTACKING)
function love.mousepressed(x, y, button)
    
    if button == 1 then --left click


        if player.state == 1 then --only attack if in normal gameplay
            player:attack()
        end
        


        

    end
end
