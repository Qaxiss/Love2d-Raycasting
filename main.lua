function love.load()
  require('raycaster')
  width, height = love.window.getMode()
  worldMap  = {
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
    {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1},
    {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
  }
  posX = 22
  posY = 12
  dirX = -1
  dirY = 0
  planeX = 0
  planeY = 0.66
  rotateSpeed = 4
  walkSpeed = 7
  sprintSpeed = walkSpeed * 3
  mapPosition = worldMap[math.floor(posX + dirX * walkSpeed)][math.floor(posY)]
end

function love.draw()
  rayCaster(worldMap, width, height, posX, posY, dirX, dirY, planeX, planeY)
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function love.update(delta)
  
  controls(delta)
  
end

function controls(delta)
  if love.keyboard.isDown('lshift') then
    moveSpeed = sprintSpeed
  else
    moveSpeed = walkSpeed
  end
  
  if love.keyboard.isDown('right') then
    dirX, dirY, planeX, planeY = rotateRight(dirX, dirY, planeX, planeY, (rotateSpeed * delta) % rotateSpeed)
  end
  if love.keyboard.isDown('left') then
    dirX, dirY, planeX, planeY = rotateLeft(dirX, dirY, planeX, planeY, (rotateSpeed * delta) % rotateSpeed)
  end
  
  if love.keyboard.isDown('up') then
    posX, posY = moveForward(worldMap, posX, posY, dirX, dirY, (moveSpeed * delta) % moveSpeed)
  end
  
  if love.keyboard.isDown('down') then
    posX, posY = moveBackward(worldMap, posX, posY, dirX, dirY, (moveSpeed * delta) % moveSpeed)
  end
end


function love.keyreleased(key)
  if key == "escape" then
    love.event.quit()
  end
end
