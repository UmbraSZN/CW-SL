effects = {}
--add layers for effects?? (drawing order)

function effects:new(type, x, y, args) --Spawns a new effect sprite depending on 'type'

    local effect = {}
    effect.x = x
    effect.y = y
    effect.rot = 0
    effect.kill = false
    effect.scaleX = 1
    effect.scaleY = 1
    effect.width = 23
    effect.height = 39

    if type == "slice" then --must pass with args
        --sword attack
        --add appropriate colour depending on weapon
        effect.spriteSheet = sprites.effects.sliceAnim
        effect.grid = anim8.newGrid(23, 39, effect.spriteSheet:getWidth(), effect.spriteSheet:getHeight())
        effect.anim = anim8.newAnimation(effect.grid('1-2', 1), 0.08)
        effect.scaleX = 1.5
        effect.scaleY = 1.5
        effect.timer = 0.16
        

        --calcuate the rotation of the slice
        if args < 0 then
            effect.rot =  math.abs(args) + 3/2*math.pi
        else
            effect.rot = (args + math.pi/2) * -1
        end

        effect.x = effect.x + math.cos(effect.rot) * 26
        effect.y = effect.y + math.sin(effect.rot) * 26

    elseif type == "" then --add
        --etc

    end

    table.insert(effects, effect)
end


function effects:update(dt)

    for _, e in ipairs(effects) do
        if e.anim then
            e.anim:update(dt)
        end

        if e.timer then
            e.timer = e.timer - dt
            if e.timer < 0 then
                e.kill = true
                --spawn stuff depding on anim type played?
            end
        end
    end

    
    local i = #effects
    while i > 0 do
        if effects[i].kill then
            table.remove(effects, i)
        end
        i = i - 1
    end
    
end

function effects:draw() --add layers for effects?? (drawing order)

    for _, e in ipairs(effects) do
        if e.anim then
            --have colours in sprite sheet, and choose which ones to play based on colour
            --move colour somewhere else?, or get from the table - add colour appropriate to table
            --love.graphics.setColor(0, 1, 2) --cyan
            e.anim:draw(e.spriteSheet, e.x, e.y, e.rot, e.scaleX, e.scaleY, e.width/2, e.height/2)
            --love.graphics.setColor(1,1,1)
        end
        
    end
end