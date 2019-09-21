local Looper = {}
Looper.path = ""
local loop = nil

Looper.setLoop = function(audio)
    if loop then loop:stop() end
    loop = love.audio.newSource(Looper.path..audio, "stream")
    if loop then
        loop:setLooping(true)
        loop:play()
    else
        error("audio file could not load", 2)
    end
end

-- if you want to manipulate it more
Looper.getLoop = function()
    return loop
end


return Looper