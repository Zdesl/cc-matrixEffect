monitors = { peripheral.find("monitor") }

if not monitors or #monitors < 1 then
    print("Connect a monitor for a better effect!")
    sleep(3)
    monitor = term.current()
else
    monitor = monitors[1] --only use one monitor
end

monitor.clear()
width,height = monitor.getSize()
monitor.setPaletteColour(colors.green, 0x008001)
monitor.setPaletteColour(colors.lime, 0x00C200)
monitor.setPaletteColour(colors.gray, 0x008f11)
monitor.setPaletteColour(colors.lightGray, 0x00ff41)
monitor.setPaletteColour(colors.white, 0xDCF9C6)

grid = {}
snakePosY = {}
gridSnakeLength = {}

--settings
MAX_SNAKE_LENGTH = math.floor(height/3)
MIN_SNAKE_LENGTH = 5 -- > 4 is is the minimum required length
SPEED = 0.10 --less is faster (sleep between updates)


function generateMatrix()
    if MAX_SNAKE_LENGTH < MIN_SNAKE_LENGTH then MAX_SNAKE_LENGTH = MIN_SNAKE_LENGTH end
    for x = 1, width do
        grid[x] = {}
        snakePosY[x] = math.random(1,42) --starting position of snake... what's the meaning of life?
        gridSnakeLength[x] = math.random(MIN_SNAKE_LENGTH,MAX_SNAKE_LENGTH)
        for j = 1, height do
            grid[x][j] = string.char(math.random(21,55))
        end
    end
end


generateMatrix()
cursorPosY = 1
while true do
    for x = 1, width do
        monitor.setCursorPos(x,1)
        cursorPosY = 1
        for y = 1, height do
            --color the snakes
            if snakePosY[x] + gridSnakeLength[x] - y > 0 and snakePosY[x] - gridSnakeLength[x] - y < 0 then --tail of snake
                monitor.setTextColor(colors.green)
                monitor.write(grid[x][y])
            elseif y - gridSnakeLength[x] == 0 + snakePosY[x] then
                monitor.setTextColor(colors.lime)
                monitor.write(grid[x][y])
            elseif y - gridSnakeLength[x] == 1 + snakePosY[x] then
                monitor.setTextColor(colors.gray)
                monitor.write(grid[x][y])
            elseif y - gridSnakeLength[x] == 2 + snakePosY[x] then
                monitor.setTextColor(colors.lightGray)
                monitor.write(grid[x][y])
            elseif y - gridSnakeLength[x] == 3 + snakePosY[x] then
                monitor.setTextColor(colors.white)
                monitor.write(string.char(math.random(21,55))) --1random head of snake
            else  
                --for debug purposes
                --monitor.setTextColor(colors.red)
                --monitor.write(y - gridSnakeLength[x])
            end

            cursorPosY = cursorPosY + 1
            monitor.setCursorPos(x,cursorPosY)
        end

        if snakePosY[x] - gridSnakeLength[x] > gridSnakeLength[x] + height then 
            --reset the snake
            snakePosY[x] = 0 - gridSnakeLength[x]
        else
            if math.random(0,9) == 1 then --advance some snakes twice randomly
                snakePosY[x] = snakePosY[x] + 2
            else
                snakePosY[x] = snakePosY[x] + 1
            end
        end
    end
    sleep(SPEED)
    monitor.clear()
end
