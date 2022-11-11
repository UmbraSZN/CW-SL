local function spawn(x, y, type)

    local enemy = world:newCircleCollider(x, y, 8) --change size of collider? (to fit goblin sprite when made)
    enemy:setCollisionClass("Enemy")
    enemy.type = type
    enemy.x = player:getX()
    enemy.y = player:getY()
    enemy.speed = 80
    

    return enemy
end

return spawn