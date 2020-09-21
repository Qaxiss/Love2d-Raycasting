local Color = require('ColorLibrary')

function rayCaster(worldMap, width, height, posX, posY, dirX, dirY, planeX, planeY)
    for x = 1, width do
      --Calculate ray position and direction
      local cameraX = 2 * x / width - 1 -- X - coordinate in camera space
      local rayDirX = dirX + planeX * cameraX
      local rayDirY = dirY + planeY * cameraX
      
      -- Which box of the map we're in 
      local mapX = math.floor(posX)
      local mapY = math.floor(posY)
      
      --Length of ray from current position to next x or y side
      local sideDistX
      local sideDistY
      
      --Length of ray from one x or y side to next x or y side
      local deltaDistX = math.abs(1 / rayDirX)
      local deltaDistY = math.abs(1 / rayDirY)
      local perpWallDist
      
      --What direction to step in x or y directin (either +1 or -1)
      local stepX
      local stepY
      
      local hit = 0
      local side
      
      --Calculate step and initial sideDist
      if rayDirX < 0 then
        stepX = -1
        sideDistX = (posX - mapX) * deltaDistX
      else
        stepX = 1
        sideDistX = (mapX + 1 - posX) * deltaDistX
      end
      
      if rayDirY < 0 then
        stepY = -1
        sideDistY = (posY - mapY) * deltaDistY
      else
        stepY = 1
        sideDistY = (mapY + 1 - posY) * deltaDistY
      end
      
      --perform DDA
      while (hit == 0) do
        --Jump to the next map square, or in x direction or in y directin
        if sideDistX < sideDistY then
          sideDistX = sideDistX + deltaDistX
          mapX = mapX + stepX
          side = 0
        else
          sideDistY = sideDistY + deltaDistY
          mapY = mapY + stepY
          side = 1
        end
        --Check if ray has hit a wall
        if worldMap[mapX][mapY] > 0 then
          hit = 1
        end
      end
      
      --Calculate distance project on camera direction (Euclidean distance will give fisheye effect!)
      if side == 0 then
        perpWallDist = (mapX - posX + (1 - stepX) / 2) / rayDirX
      else
        perpWallDist = (mapY - posY + (1 - stepY) / 2) / rayDirY
      end
      
      --Calculate height of line to draw on screen
      local lineHeight = height / perpWallDist
      
      --Calculate lowest and highest pixel to fill in current stripe
      local drawStart = - lineHeight / 2 + height / 2
      if drawStart < 0 then drawStart = 0 end
      local drawEnd = lineHeight / 2 + height / 2
      if drawEnd >= height then drawEnd = height - 1 end

      --Choose wall color
      local colors = {
          Color('red'),
          Color('green'),
          Color('blue'),
          Color('white'),
          Color('yellow'),
          Color('darkred'),
          Color('darkgreen'),
          Color('navyblue'),
          Color('grey'),
          Color('apricot')
      }
      
      local color = colors[worldMap[mapX][mapY]]
      
      --give X and Y sides different colors
      if side == 1 then 
        color = colors[worldMap[mapX][mapY] + 5] 
      end
      
      --draw the pixels of the stripe as a vertical line

      love.graphics.setColor(color[1] / 255,color[2] / 255,color[3] / 255)
      love.graphics.line(x, drawStart, x, drawEnd)
      love.graphics.setColor(255,255,255)
      
    end
    
end

function rotateRight(dirX, dirY, planeX, planeY, rotateSpeed)
  --Handles roatation to the right in they raycasting map
  local oldDirX = dirX
  dirX = dirX * math.cos(-rotateSpeed) - dirY * math.sin(-rotateSpeed)
  dirY = oldDirX * math.sin(-rotateSpeed) + dirY * math.cos(-rotateSpeed)
  local oldPlaneX = planeX
  planeX = planeX * math.cos(-rotateSpeed) - planeY * math.sin(-rotateSpeed)
  planeY = oldPlaneX * math.sin(-rotateSpeed) + planeY * math.cos(-rotateSpeed)
  
  return dirX, dirY, planeX, planeY
end

function rotateLeft(dirX, dirY, planeX, planeY, rotateSpeed)
  --Handles roatation to the left in they raycasting map
  local oldDirX = dirX
  dirX = dirX * math.cos(rotateSpeed) - dirY * math.sin(rotateSpeed)
  dirY = oldDirX * math.sin(rotateSpeed) + dirY * math.cos(rotateSpeed)
  local oldPlaneX = planeX
  planeX = planeX * math.cos(rotateSpeed) - planeY * math.sin(rotateSpeed)
  planeY = oldPlaneX * math.sin(rotateSpeed) + planeY * math.cos(rotateSpeed)
  
  return dirX, dirY, planeX, planeY
end

function moveForward(worldMap, posX, posY, dirX, dirY, moveSpeed)
  -- moves the player forward in the map, stops at edge of map
  if worldMap[math.floor(posX + dirX * moveSpeed)][math.floor(posY)] == 0 then 
    posX = posX + dirX * moveSpeed
  end
  if worldMap[math.floor(posX)][math.floor(posY + dirY * moveSpeed)] == 0 then
    posY = posY + dirY * moveSpeed
  end
  return posX, posY
end

function moveBackward(worldMap, posX, posY, dirX, dirY, moveSpeed)
  -- moves the player backward in the map, stops at edge of map
  if worldMap[math.floor(posX - dirX * moveSpeed)][math.floor(posY)] == 0 then 
    posX = posX - dirX * moveSpeed
  end
  if worldMap[math.floor(posX)][math.floor(posY - dirY * moveSpeed)] == 0 then
    posY = posY - dirY * moveSpeed
  end
  return posX, posY
end