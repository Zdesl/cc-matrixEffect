-- require("benchmark")
monitors = { peripheral.find("monitor") }

if not monitors or #monitors < 1 then
    print("Connect a monitor for a better effect!")
    sleep(3)
    monitor = term.current() -- only use the computer screen
else
    monitor = monitors[1]    -- only use one monitor
end

monitor.clear()
width,height = monitor.getSize()

-- allColors = {colors.white,colors.orange,colors.magenta,colors.lightBlue,colors.yellow,colors.lime,colors.pink,colors.gray,colors.lightGray,colors.cyan,colors.purple,colors.blue,colors.brown,colors.green,colors.red,colors.black}
snakeHeadColors = {colors.yellow,colors.red,colors.gray,colors.brown,colors.blue}
snakeTailColors = {colors.white,colors.orange,colors.magenta,colors.lightBlue}
charGrid = {}
snakePosY = {}
snakeLength = {}
cursorPosY = 1
validChars = {5,14,19,20,21,28,29,37,39,42,43,44,45,46,59,62,94,96,126,129,134,162,164,165,167,168,169,171,172,177,178,179,180,181,182,183,184,186,187,188,189,191,194,195,198,199,202,204,206,209,212,215,217,221,222,230,234,236,237,238,241,248,249,250,253,254}

-- settings
GLITCH_CHANCE = 15                                  -- lower value = higher chance for a char to glitch randomly, 0 is always
SPEED = 0.10                                        -- less is faster (sleep between updates)
maxSnakeLength = math.floor(height/1.5)               -- the maximum snake length, limited by the output monitor size
minSnakeLength = #snakeHeadColors+#snakeTailColors  -- 9 is is the minimum required length


function setSnakeColorScheme(n)
    if n == 0 then --original
        --snake tail colors
        monitor.setPaletteColour(colors.white, 0x002400) -- end of tail
        monitor.setPaletteColour(colors.orange, 0x003800)
        monitor.setPaletteColour(colors.magenta, 0x004A00)
        monitor.setPaletteColour(colors.lightBlue, 0x005700) -- start of tail

        monitor.setPaletteColour(colors.green, 0x007A0E) -- body of snake

        --snake head colors
        monitor.setPaletteColour(colors.blue, 0x008001)
        monitor.setPaletteColour(colors.brown, 0x008f11)
        monitor.setPaletteColour(colors.gray, 0x00C200)
        monitor.setPaletteColour(colors.red, 0x00ff41)
        monitor.setPaletteColour(colors.yellow, 0xBBFFA8) -- head of snake

    elseif n == 1 then --trans
        maxSnakeLength = 10
        minSnakeLength = 10

        --snake tail colors
        monitor.setPaletteColour(colors.white, 0x55CDFC) -- end of tail
        monitor.setPaletteColour(colors.orange, 0x55CDFC)
        monitor.setPaletteColour(colors.magenta, 0xF7A8B8)
        monitor.setPaletteColour(colors.lightBlue, 0xF7A8B8) -- start of tail

        monitor.setPaletteColour(colors.green, 0xFFFFFF) -- body of snake

        --snake head colors
        monitor.setPaletteColour(colors.blue, 0xFFFFFF)
        monitor.setPaletteColour(colors.brown, 0xF7A8B8)
        monitor.setPaletteColour(colors.gray, 0xF7A8B8)
        monitor.setPaletteColour(colors.red, 0x55CDFC)
        monitor.setPaletteColour(colors.yellow, 0x55CDFC) -- head of snake
    end
end


function generateMatrix()
    if maxSnakeLength < minSnakeLength then maxSnakeLength = minSnakeLength end
    for x = 1, width do
        charGrid[x] = {}
        snakeLength[x] = math.random(minSnakeLength,maxSnakeLength)
        snakePosY[x] = math.random(-42,42) --starting position of snake
        for j = 1, height do
            charGrid[x][j] = string.char(validChars[math.random(1,#validChars)])
        end
    end
end


setSnakeColorScheme(0)
generateMatrix()
-- for i = 1, #snakePosY do
--     snakePosY[i] = 1
-- end

-- startBenchmark()
while true do

    for x = 1, width do

        monitor.setCursorPos(x,1)
        cursorPosY = snakePosY[x]

        for y = snakePosY[x], (snakePosY[x] + snakeLength[x]) - 1 do

            -- if within screen space
            if cursorPosY > 0 and cursorPosY <= height then
                monitor.setCursorPos(x,y)

                -- tail of snake
                if y+1-snakePosY[x] < #snakeTailColors then
                    monitor.setTextColor(snakeTailColors[y+1-snakePosY[x]])
                    monitor.write(charGrid[x][y])

                -- body of snake
                elseif y - snakePosY[x] + 1 < snakeLength[x] - #snakeHeadColors then
                    monitor.setTextColor(colors.green)
                    if math.random(0,GLITCH_CHANCE) == 0 then --change some chars randomly for the "glitch" effecteffect
                        -- monitor.write(string.char(validChars[math.random(1,#validChars)]))
                        charGrid[x][y] = string.char(validChars[math.random(1,#validChars)]) --make the glitched chars persist
                        monitor.write(charGrid[x][y])
                    else
                        monitor.write(charGrid[x][y])
                    end

                -- head of snake
                else
                    if ((snakePosY[x] + snakeLength[x]) - 1) - cursorPosY + 1 < #snakeHeadColors then
                        monitor.setTextColor(snakeHeadColors[((snakePosY[x] + snakeLength[x]) - 1) - cursorPosY + 1])
                    end
                    monitor.write(charGrid[x][y])
                end
            end

            cursorPosY = y + 1

        end

        --reset the snake
        if snakePosY[x] > height + 1 + snakeLength[x] then
            if math.random(0,4) == 0 then
                snakePosY[x] = 0 - snakeLength[x]
            end
        end

        --advance the snake
        if math.random(0,9) == 1 then --advance some snakes twice randomly
            snakePosY[x] = snakePosY[x] + 2
        else
            snakePosY[x] = snakePosY[x] + 1
        end
    end
    sleep(SPEED)
    monitor.clear()
    -- if hasBenchmarkFinished() then break end
end
