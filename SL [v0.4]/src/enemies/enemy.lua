enemies = {}

function enemies:spawn(x, y, type)

    --spawn type of enemy specified
    --set its stats based on yours

    local enemy

    if type == "goblin" then
        local goblin = require "src/enemies/goblin"
        enemy = goblin(x, y, type)

        



    elseif type == "orc" then --finish code for orc
        local orc = require "src/enemies/orc"
        enemy = orc(x, y, type)

    end

    table.insert(enemies, enemy)
end