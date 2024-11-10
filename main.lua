player = {
    x = 100,
    y = 200,
    speed = 300,
    r = 0.8,
    g = 0.1,
    b = 1,
    alpha = 1,
    rUp = false,
    gUp = false
}

roomColor = {
    r = 1,
    g = 0.5,
    b = 0.3,
    alpha = 0.5
}

currentTimeline = 12

screenWidth = nil
screenHeight = nil

teleportSound = love.audio.newSource("assets/teleport.mp3", "static")
bumpSound = love.audio.newSource("assets/bump.wav", "static")

ambienceMusic = love.audio.newSource("assets/ambience.mp3", "stream")

win1Music = love.audio.newSource("assets/win1.mp3", "stream")
win2Music = love.audio.newSource("assets/win2.mp3", "stream")
win3Music = love.audio.newSource("assets/win3.wav", "stream")
win4Music = love.audio.newSource("assets/win4.flac", "stream")

playerControl = true

win = 0

function love.load()
    love.graphics.setBackgroundColor(roomColor.r, roomColor.g, roomColor.b, roomColor.alpha)

    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    ambienceMusic:setLooping(true)
    ambienceMusic:play()

    win1Music:setLooping(true)
    win2Music:setLooping(true)
    win3Music:setLooping(true)
    win4Music:setLooping(true)
end

function love.update(dt)
    -- check if in winning room
    if roomColor.g > 0.99 and currentTimeline == 24 then
        win = 1
        ambienceMusic:stop()

        if not win1Music:isPlaying() then
            win1Music:play()
            playerControl = false
        end
    end
    if roomColor.g > 0.99 and currentTimeline == 0 then
        win = 2
        ambienceMusic:stop()

        if not win2Music:isPlaying() then
            win2Music:play()
            playerControl = false
        end
    end
    if roomColor.g < 0.05 and currentTimeline == 0 then
        win = 3
        ambienceMusic:stop()

        if not win3Music:isPlaying() then
            win3Music:play()
            playerControl = false
        end
    end
    if roomColor.g < 0.05 and currentTimeline == 24 then
        win = 4
        ambienceMusic:stop()

        if not win4Music:isPlaying() then
            win4Music:play()
            playerControl = false
        end
    end

    -- player movement
    if playerControl then
        if love.keyboard.isDown("right") then
            player["x"] = player["x"] + player.speed * dt
        end
        if love.keyboard.isDown("left") then
            player["x"] = player["x"] - player.speed * dt
        end
        if love.keyboard.isDown("up") then
            player.y = player.y - player.speed * dt
        end
        if love.keyboard.isDown("down") then
            player.y = player.y + player.speed * dt
        end
    end

    -- player changing color
    if player.rUp then
        player.r = player.r - 0.01
    else
        player.r = player.r + 0.01
    end

    if player.gUp then
        player.g = player.g - 0.001
    else
        player.g = player.g + 0.001
    end

    if player.r < 0.1 or player.r > 0.9 then
        player.rUp = not player.rUp
    end
    if player.g < 0.1 or player.g > 0.9 then
        player.gUp = not player.gUp
    end

    -- player teleport to another room
    if player.y < -50 then
        if currentTimeline < 24 then
            player.y = screenHeight - 50
            currentTimeline = currentTimeline + 1
            teleportSound:play()
        else
            player.y = 0
            bumpSound:play()
        end
    end
    if player.y > screenHeight then
        if currentTimeline > 0 then
            player.y = 0
            currentTimeline = currentTimeline - 1
            teleportSound:play()
        else
            player.y = screenHeight - 50
            bumpSound:play()
        end
    end

    if player.x < -50 then
        if roomColor.g > 0 then
            player.x = screenWidth
            roomColor.g = roomColor.g - 0.05
            teleportSound:play()
            if roomColor.g < 0.05 then
                roomColor.g = 0
            end
        else
            player.x = 0
            bumpSound:play()
        end
    end
    if player.x > screenWidth then
        if roomColor.g < 1 then
            player.x = 0
            roomColor.g = roomColor.g + 0.05
            teleportSound:play()
            if roomColor.g > 0.95 then
                roomColor.g = 1
            end
        else
            player.x = screenWidth - 50
            bumpSound:play()
        end
    end

    -- change room color
    love.graphics.setBackgroundColor(roomColor.r, roomColor.g, roomColor.b, roomColor.alpha)
end

function love.draw()
    -- draw player
    love.graphics.setColor(player.r, player.g, player.b, player.alpha)
    love.graphics.rectangle("fill", player["x"], player.y, 50, 50)

    -- draw HUD
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(roomColor.g, 50, 25)
    love.graphics.print(currentTimeline .. ":00", screenWidth - 75, 25)

    -- draw win text
    if win == 1 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(
            "Microtransações tomaram conta dos jogos, agora as maiores corporações controlam o mercado",
            100,
            200
        )
    end
    if win == 2 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print("Muitas fitas foram enterradas e a indústria de jogos entrou em colapso.", 150, 300)
    end
    if win == 3 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print("O lançamento do jogo  E.T. foi adiado para o natal do ano seguinte,", 200, 200)
        love.graphics.print("o tornando o jogo de maior sucesso de todos os tempos dos games.", 200, 240)
    end
    if win == 4 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print("Jogos indies dominaram e o mercado AAA entrou em colapso.", 50, 200)
        love.graphics.print(
            "Agora os jogadores têm acesso à muitos jogos inovadores, completos e por um preço justo.",
            50,
            240
        )
    end
end
