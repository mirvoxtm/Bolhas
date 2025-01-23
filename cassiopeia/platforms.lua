local function setupPlatforms(world)
    local platform = world:newRectangleCollider(0, 500, 3000, 1200, {collision_class = 'Platform'})
    platform:setType('static')

    local danger = world:newRectangleCollider(500, 500, 100, 30, {collision_class = 'Danger'})
    danger:setType('dynamic')
end

return setupPlatforms