function love.load()
    grid_size = 100
    board = {
        {"", "", ""},
        {"", "", ""},
        {"", "", ""}
    }
    current_player = "X"
    winner = nil

    -- Animação: cor vibrante que vai mudando
    animation = {
        time = 0,
        speed = 2 -- velocidade da animação
    }
end

function love.update(dt)
    animation.time = animation.time + dt * animation.speed
end

function love.draw()
    -- Cores vibrantes para o tabuleiro
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    love.graphics.setColor(0.2 + math.abs(math.sin(animation.time)) * 0.8, 0.6, 1)
    for i = 1, 2 do
        love.graphics.setLineWidth(5)
        love.graphics.line(i * grid_size, 0, i * grid_size, 3 * grid_size)
        love.graphics.line(0, i * grid_size, 3 * grid_size, i * grid_size)
    end

    -- Desenhar X e O animados
    for row = 1, 3 do
        for col = 1, 3 do
            local symbol = board[row][col]
            if symbol ~= "" then
                local x = (col - 1) * grid_size + grid_size/2
                local y = (row - 1) * grid_size + grid_size/2

                if symbol == "X" then
                    -- X com cor vibrante animada
                    love.graphics.setColor(1, math.abs(math.sin(animation.time)), 0.2)
                    love.graphics.setLineWidth(8)
                    love.graphics.line(x - 30, y - 30, x + 30, y + 30)
                    love.graphics.line(x + 30, y - 30, x - 30, y + 30)
                else
                    -- O com cor vibrante diferente
                    love.graphics.setColor(0.2, 1, math.abs(math.sin(animation.time)))
                    love.graphics.setLineWidth(8)
                    love.graphics.circle("line", x, y, 30)
                end
            end
        end
    end

    -- Mostrar vencedor
    if winner then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Vencedor: " .. winner, 10, 3 * grid_size + 10, 0, 2, 2)
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and not winner then
        local col = math.floor(x / grid_size) + 1
        local row = math.floor(y / grid_size) + 1

        if row >=1 and row <=3 and col >=1 and col <=3 then
            if board[row][col] == "" then
                board[row][col] = current_player
                checkWinner()
                if not winner then
                    if current_player == "X" then
                        current_player = "O"
                    else
                        current_player = "X"
                    end
                end
            end
        end
    end
end

function checkWinner()
    -- Checar linhas e colunas
    for i = 1, 3 do
        if board[i][1] ~= "" and board[i][1] == board[i][2] and board[i][2] == board[i][3] then
            winner = board[i][1]
            return
        end
        if board[1][i] ~= "" and board[1][i] == board[2][i] and board[2][i] == board[3][i] then
            winner = board[1][i]
            return
        end
    end

    -- Checar diagonais
    if board[1][1] ~= "" and board[1][1] == board[2][2] and board[2][2] == board[3][3] then
        winner = board[1][1]
        return
    end
    if board[1][3] ~= "" and board[1][3] == board[2][2] and board[2][2] == board[3][1] then
        winner = board[1][3]
        return
    end

    -- Checar empate
    local filled = true
    for row = 1, 3 do
        for col = 1, 3 do
            if board[row][col] == "" then
                filled = false
            end
        end
    end
    if filled then
        winner = "Empate"
    end
end
