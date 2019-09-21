function love.load()
    startGame()
    font = love.graphics.newFont(20)
    bgText = love.graphics.newText(font, "game by dmoa [stan.xyz]. \n wasd to move, space to switch shop. \n THE KARENS ARE IN TOWN")
    scoreText = love.graphics.newText(font, "score"..tostring(score))
    looper = require("Looper")
    looper.setLoop("loop.wav")
end

function love.draw()
    love.graphics.setColor(153 / 255, 165 / 255, 178 / 255)
    love.graphics.rectangle("fill", 0, 0, WW, WH)
    love.graphics.setColor(1, 1, 1)


    for k, v in ipairs(shops) do
        v.draw(dt)
    end

    for k, v in ipairs(karens) do
        love.graphics.draw(karenImg, v.x, v.y)
    end

   love.graphics.draw(bgText, 5, 5)
   love.graphics.draw(scoreText, 300, 100)
end

function love.update(dt)
    shops[currentShop].update(dt)


    for k, v in ipairs(karens) do
        v.x = v.x - 400 * dt
        if v.x < -100 then
            v.x = love.math.random(400) + WW
            v.y = love.math.random(800) 
        end
        for shopsIndex, shops in ipairs(shops) do
            if AABB(shops.getObj(), {leftX = v.x, rightX = v.x + karenImg:getWidth(), topY = v.y, bottomY = v.y + karenImg:getHeight()}) then
                startGame()
            end
        end
    end

    karenTimer = karenTimer - dt
    if karenTimer < 0 then
        karenF = karenF - 0.5
        karenTimer = karenF
        table.insert(karens, {x = love.math.random(400) + WW, y = love.math.random(800)})
    end

    score = (score + dt)
    scoreText = love.graphics.newText(font, "score: "..tostring(math.floor(score) * 5))
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "space" then
        currentShop = (currentShop) % 3 + 1
    end
end

function AABB(obj1, obj2)
    return obj1.rightX > obj2.leftX and obj1.leftX < obj2.rightX
            and obj1.bottomY > obj2.topY and obj1.topY < obj2.bottomY
end

function startGame()

    score = 0

    WW, WH = love.graphics.getDimensions()

    karenImg = love.graphics.newImage("karen.png")
    karens = {}
    table.insert(karens, {x = love.math.random(400) + WW, y = love.math.random(800)})
    
    karenF = 10
    karenTimer = karenF

    shops = {}

    currentShop = 1
    
    for i = 1, 3 do

        local shop = {
            x = 100,
            y = 100,
            xv = 400,
            yv = 400
        }
        
        shop.draw = function()
            love.graphics.draw(shop.image, shop.x, shop.y)
        end
        
        shop.update = function(dt)
            if love.keyboard.isDown("d") then 
                shop.x = shop.x + shop.xv * dt
            end
            if love.keyboard.isDown("a") then 
                shop.x = shop.x - shop.xv * dt
            end
            if love.keyboard.isDown("s") then 
                shop.y = shop.y + shop.yv * dt
            end
            if love.keyboard.isDown("w") then 
                shop.y = shop.y - shop.yv * dt
            end
            if shop.x < 0 then
                shop.x = 0
            end
            if shop.x + shop.image:getWidth() > WW then
                shop.x = WW - shop.image:getWidth()
            end
            if shop.y < 0 then
                shop.y = 0
            end
            if shop.y + shop.image:getHeight() > WH then
                shop.y = WH - shop.image:getHeight()
            end
        end
        
        shop.image = love.graphics.newImage("shop"..i..".png")
        shop.x = i * 50

        shop.getObj = function()
            return {leftX = shop.x, rightX = shop.x + shop.image:getWidth(),
                    topY = shop.y, bottomY = shop.y + shop.image:getHeight()}
        end

        table.insert(shops, shop)
    end
end