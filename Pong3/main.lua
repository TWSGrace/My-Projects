WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

    sounds = {
        ['paddlehit'] = love.audio.newSource('paddlehit.wav', 'static'),
        ['pointscored'] = love.audio.newSource('pointscored.wav', 'static'),
        ['wallhit'] = love.audio.newSource('wallhit.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizeable = true
    })

    -- get fonts from file
    smallFont = love.graphics.newFont('FONT.ttf', 8)
    scoreFont = love.graphics.newFont('FONT.ttf', 32)
    victoryFont = love.graphics.newFont('Font.ttf', 24)

    -- set player scores
    player1score = 0
    player2score = 0

    servingPlayer = math.random(2) == 1 and 1 or 2
    winningPlayer = 0

    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    gameState = 'start'
    aiState = '2 players'

    PADDLE_SPEED = 200
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)

    if ball:collides(paddle1) then
        -- deflect ball to the right
        ball.dx = -ball.dx * 1.03

        -- randomise balls vertical speed
        if ball.dy < 0 then
            ball.dy = -math.random(10,150)
        else
            ball.dy = math.random(10,150)
        end

        sounds['paddlehit']:play()
    end

    if ball:collides(paddle2) then
        -- deflect ball to the left
        ball.dx = -ball.dx * 1.03

        -- randomise balls vertical speed
        if ball.dy < 0 then
            ball.dy = -math.random(10,150)
        else
            ball.dy = math.random(10,150)
        end

        sounds['paddlehit']:play()
    end

    if ball.y <= 0 then
        -- deflect ball down
        ball.dy = -ball.dy
        ball.y = 0

        sounds['wallhit']:play()
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
        -- deflect ball up
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4

        sounds['wallhit']:play()
    end

    if gameState == 'play' then
        if ball.x >= VIRTUAL_WIDTH - 4 then
            sounds['pointscored']:play()
            player1score = player1score + 1
            servingPlayer = 2
            ball:reset()
            ball.dx = -100
            if player1score >= 10 then
                gameState = 'victory'
                winningPlayer = 1
            else
                gameState = 'serve'
            end
            if aiState == 'AI' then
                gameState = 'play'
            end
        end

        if ball.x <= 0 then
            sounds['pointscored']:play()
            player2score = player2score + 1
            servingPlayer = 1
            ball:reset()
            ball.dx = 100
            if player2score >= 10 then
                gameState = 'victory'
                winningPlayer = 2
            else
                gameState = 'serve'
            end
        end
    end
    
    paddle1:update(dt)
    paddle2:update(dt)

    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if aiState == '2 players' then
        if love.keyboard.isDown('up') then
            paddle2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            paddle2.dy = PADDLE_SPEED
        else
            paddle2.dy = 0
        end
    elseif aiState == 'AI' then
        if paddle2.y < ball.y then
            paddle2.y = paddle2.y + 100 * dt
        elseif paddle2.y > ball.y then
            paddle2.y = paddle2.y - 100 * dt
        end
    end

    if gameState == 'play' then
        ball:update(dt)
    end
    
end

function love.keypressed(key)

    -- key accessed by string name
    if key == 'escape' then

        -- function to quit program
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'victory' then
            player1score = 0
            player2score = 0
            gameState = 'start'
        end

    elseif key == 'space' then
        if gameState == 'start' then
            gameState = 'play'
            aiState = 'AI'
        end
    end
end

function love.draw()

    -- begin rendering at virtual resolution
    push:apply('start')

    -- set background colour
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- draw different things based on state of game
    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf("Welcome to Pong", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Play!", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s turn", 0, 20
        , VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Serve!", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        -- Victory
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins", 0, 10
        , VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to serve', 0, 42, VIRTUAL_WIDTH, 'center')
    end

    -- render left paddle
    paddle1:render()
    paddle2:render()
    ball:render()

    -- set font to score size and print scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- display fps
    displayFPS()

    -- end rendering at virtual resolution
    push:apply('end')

end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end