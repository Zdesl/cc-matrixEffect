--only use one monitor
monitor = peripheral.find("monitor")
if not monitor then
    monitor = term.current()
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
MAX_SNAKE_LENGTH = height/3
MIN_SNAKE_LENGTH = 5
SPEED = 0.10 --less is faster (sleep between updates)


function generateMatrix()
    for x = 1, width do
        grid[x] = {}
        snakePosY[x] = math.random(1,42) --what's the meaning of life?
        gridSnakeLength[x] = math.random(MIN_SNAKE_LENGTH,MAX_SNAKE_LENGTH)
        print("Lenght:",gridSnakeLength[x])
        for j = 1, height do
            grid[x][j] = string.char(math.random(21,55))
        end
    end
end


generateMatrix()
while true do
    local cursorPosY = 1
    for rainLoop = 1, 50 do
        cursorPosY = 1
        for x = 1, width do
            for y = 1, height do
                --color the snakes
                if snakePosY[x] + gridSnakeLength[x] - y > 0 and snakePosY[x] - gridSnakeLength[x] - y < 0 then
                    --if math.random(0,1) == 0 then
                    monitor.setTextColor(colors.green)
                    --else
                    --    monitor.setTextColor(colors.lime)
                    --end
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
                    monitor.write(string.char(math.random(21,55))) --random head of snake
                else  
                    --for debug purposes
                    --monitor.setTextColor(colors.red)
                    --monitor.write(y - gridSnakeLength[x])
                end

                cursorPosY = cursorPosY + 1
                monitor.setCursorPos(x,cursorPosY)
            end

            cursorPosY = 1
            monitor.setCursorPos(x,1)
            monitor.setTextColor(colors.green)

            if snakePosY[x] - gridSnakeLength[x] > gridSnakeLength[x] + height then 
                snakePosY[x] = 0 - gridSnakeLength[x]
            else
                print(snakePosY[x]+gridSnakeLength[x])
                snakePosY[x] = snakePosY[x] + 1
                if math.random(0,5) == 1 then
                    snakePosY[x] = snakePosY[x] + 1
                end
            end
        end

        sleep(SPEED)
        monitor.clear()
    end
end
