player = world:newCircleCollider(100, 100, 8)
player:setCollisionClass("Player")
player.showCollisions = false
player.x = player:getX()
player.y = player:getY()
player.speed = 80
player.dir = down
player.weapon = "baseSword" --change accordingly
player.state = 1 --walking[1], attacking[2], dodging[3], etc  (stunned)
--player.stats = {} move all stats in here???
player.level = 1 --have this in database
player.exp = 0 --have this in database
player.strength = 0 --have this in database
player.vitality = 0 --have this in database
player.agility = 0 --have this in database
player.intelligence = 0 --have this in database
player.sense = 0 --have this in database
player.spriteSheet = sprites.playerSheet
player.grid = anim8.newGrid(32, 32, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

player.animations = {}
player.animations.down = anim8.newAnimation(player.grid("1-4", 1), 0.18)
player.animations.left = anim8.newAnimation(player.grid("1-4", 2), 0.18)
player.animations.up = anim8.newAnimation(player.grid("1-4", 3), 0.18)
player.animations.right = anim8.newAnimation(player.grid("1-4", 4), 0.18)

player.anim = player.animations.down


function player:update(dt)

    if player.state == 1 then --normal
        local isMoving = false
        local vx, vy = 0, 0
        
        if love.keyboard.isDown("a") then
            vx = player.speed * -1
            isMoving = true
            player.anim = player.animations.left
            player.dir = "left"
        end

        if love.keyboard.isDown("d") then
            vx = player.speed
            isMoving = true
            player.anim = player.animations.right
            player.dir = "right"
        end

        if love.keyboard.isDown("s") then
            vy = player.speed
            isMoving = true
            player.anim = player.animations.down
            player.dir = "down"
        end

        if love.keyboard.isDown("w") then
            vy = player.speed * -1
            isMoving = true
            player.anim = player.animations.up
            player.dir = "up"
        end

        if isMoving == false then
            player.anim:gotoFrame(4)
        end

        if vx ~= 0 and vy ~= 0 then
            vx = vx/math.sqrt(2)
            vy = vy/math.sqrt(2)
        end

        player:setLinearVelocity(vx, vy)


        player.anim:update(dt)


    elseif player.state == 2 then --attacking
        --delay

    end
end

function player:draw()
    player.anim:draw(player.spriteSheet, player.x, player.y-6, nil, 1, nil, 16, 16)
    effects:draw()

    if player.showCollisions then
        world:draw()
        world:setQueryDebugDrawing(true)
    else
        world:setQueryDebugDrawing(false)
    end
end



function player:attack() --maybe take weapon in params?

    --check where and what youre clicking
    --add hold m1 down to spam attack later???

    --if mouse not on hud then attack
    --otherwise open appropriate hud

    --calculate angle to mx, my
    --create hitbox(query) in that direction 
    --do damage if mob enters it
    --dont do damage to self
    --do knockback?
    --add cooldown on attacking

    --player.state = 2 --attacking 
    local mx, my = cam:mousePosition()
    local angle = math.atan2(player.x - mx, player.y - my)
    local hx = player.x + math.sin(angle) * -20
    local hy = player.y + math.cos(angle) * -20
    effects:new("slice", player.x, player.y, angle) --change colour (and size?) of slice depending on weapon

    local enemies = world:queryCircleArea(hx, hy, 25, {"Enemy"})
    for _, enemy in ipairs(enemies) do
        
        enemy.health = enemy.health - 10   --player.weapon --change dmg based on weapon
        if enemy.health <= 0  then 
            enemy:destroy()
        else
            enemy:applyLinearImpulse(math.sin(angle) * -10, math.cos(angle) * -10) --knocks back at the angle player attacked
        end
        
    end


end