function checkSetas()
  return love.keyboard.isDown("right") or love.keyboard.isDown("left") or love.keyboard.isDown("down") or love.keyboard.isDown("up")
end

function changeFrame(dir)
  if player.frame_timer > global.frame_timer then
    player.frame = player.frame + 1
    player.frame_timer = 0
  end
  if player.frame > dir*3+3 or player.frame < dir*3+1 then
    player.frame = dir*3+1
  end
end

function moveBox(dt)
  if (player.targetx == 1 and player.sqmx == 2) or (player.targetx == world.sizex and player.sqmx == world.sizex-1) then
    player.targetx = player.sqmx
    player.moving = false
  elseif (player.targety == 1 and player.sqmy == 2) or (player.targety == world.sizey and player.sqmy == world.sizey-1) then
    player.targety = player.sqmy
    player.moving = false
  elseif player.targetx ~= player.sqmx then
    if world.map[player.targetx+((player.targetx - player.sqmx)/(math.abs(player.targetx - player.sqmx)))][player.targety].box%3 == 0 then
      world.map[player.targetx][player.targety].offsetx = world.map[player.targetx][player.targety].offsetx + (((player.targetx - player.sqmx)/(math.abs(player.targetx - player.sqmx))) * 100 * dt)
    else
      player.targetx = player.sqmx
      player.moving = false
    end
  elseif player.targety ~= player.sqmy then
    if world.map[player.targetx][player.targety+((player.targety - player.sqmy)/(math.abs(player.targety - player.sqmy)))].box%3 == 0 then
      world.map[player.targetx][player.targety].offsety = world.map[player.targetx][player.targety].offsety + (((player.targety - player.sqmy)/(math.abs(player.targety - player.sqmy))) * 100 * dt)
    else
      player.targety = player.sqmy
      player.moving = false
    end
  end
  if world.map[player.targetx][player.targety].offsetx >= 32 then
    world.map[player.targetx+1][player.targety].box = -1
    world.map[player.targetx][player.targety].box = 0
    world.map[player.targetx][player.targety].offsetx = 0
    player.targetx = player.sqmx
    player.moving = false
  elseif world.map[player.targetx][player.targety].offsetx <= -32 then
    world.map[player.targetx-1][player.targety].box = -1
    world.map[player.targetx][player.targety].box = 0
    world.map[player.targetx][player.targety].offsetx = 0
    player.targetx = player.sqmx
    player.moving = false
  end
  if world.map[player.targetx][player.targety].offsety >= 32 then
    world.map[player.targetx][player.targety+1].box = -1
    world.map[player.targetx][player.targety].box = 0
    world.map[player.targetx][player.targety].offsety = 0
    player.targety = player.sqmy
    player.moving = false
  elseif world.map[player.targetx][player.targety].offsety <= -32 then
    world.map[player.targetx][player.targety-1].box = -1
    world.map[player.targetx][player.targety].box = 0
    world.map[player.targetx][player.targety].offsety = 0
    player.targety = player.sqmy
    player.moving = false
  end
end

function movePlayer(dt)
  if player.targetx < 1 then
    player.targetx = 1
  elseif player.targety < 1 then
    player.targety = 1
  elseif player.targetx > world.sizex then
    player.targetx = world.sizex
  elseif player.targety > world.sizey then
    player.targety = world.sizey
  elseif (world.map[player.targetx][player.targety].box%3) ~= 0 and world.map[player.targetx][player.targety].box >= 0 then
    player.targetx = player.sqmx
    player.targety = player.sqmy
  elseif world.map[player.targetx][player.targety].box == -1 then
    player.moving = true
    moveBox(dt)
  elseif player.targetx ~= player.sqmx then
    player.moving = true
    player.offsetx = player.offsetx + (((player.targetx - player.sqmx)/(math.abs(player.targetx - player.sqmx))) * 100 * dt)
    if not checkSetas() then
      if player.targetx - player.sqmx > 0 then
        player.dir = 2
      else
        player.dir = 1
      end
    end
    player.frame_timer = player.frame_timer + dt
    changeFrame(player.dir)
  elseif player.targety ~= player.sqmy then
    player.moving = true
    player.offsety = player.offsety + (((player.targety - player.sqmy)/(math.abs(player.targety - player.sqmy))) * 100 * dt)
    if not checkSetas() then
      if player.targety - player.sqmy > 0 then
        player.dir = 0
      else player.dir = 3
      end
    end
    player.frame_timer = player.frame_timer + dt
    changeFrame(player.dir)
  end
  if player.offsetx >= 32 then
    player.sqmx = player.sqmx + math.floor(player.offsetx/32)
    player.offsetx = 0
    player.moving = false
  elseif player.offsetx <= -32 then
    player.sqmx = player.sqmx + math.ceil(player.offsetx/32)
    player.offsetx = 0
    player.moving = false
  end
  if player.offsety >= 32 then
    player.sqmy = player.sqmy + math.floor(player.offsety/32)
    player.offsety = 0
    player.moving = false
  elseif player.offsety <= -32 then
    player.sqmy = player.sqmy + math.ceil(player.offsety/32)
    player.offsety = 0
    player.moving = false
  end
end

function LoadCharacter()
  local count = 1  
  for j = 0, 3, 1 do
    for i = 0, 2, 1 do
      player.charQuads[count]=love.graphics.newQuad(i * 32, j * 32, 32, 32, player.charImage:getWidth(),player.charImage:getHeight())
      count = count + 1
    end
  end
end

function LoadMap()
  local count = 1
  for j = 0, 2, 1 do
    for i = 0, 2, 1 do
      map.Quads[count]=love.graphics.newQuad(i * 32, j * 32, 32, 32, map.image:getWidth(),map.image:getHeight())
      count = count + 1
    end
  end
end

function createWorld()
  world.map = {}
  for i=1, world.sizex, 1 do
    world.map[i] = {}
    for j=1, world.sizey, 1 do
      world.map[i][j] = {box = love.math.random(-1,1+world.diff), x=i, y=j, offsetx=0, offsety=0}
    end
  end
  world.map[1][1].box = 0
  world.map[1][2].box = 0
  world.map[2][1].box = 0
  world.map[2][2].box = 0
end

function shiftWorld()
  local shiftsb = player.shifts
  if player.shifts > 0 then
    for i=1, world.sizex, 1 do
      for j=1, world.sizey, 1 do
        if world.map[i][j].box ~= -1 then
          world.map[i][j].box = world.map[i][j].box+1
        end
        if world.map[i][j].box > 1+world.diff then
          world.map[i][j].box = 0
        end
      end
    end
    world.map[player.sqmx][player.sqmy].box=0
    player.shifts = player.shifts - 1
  end
  return player.shifts ~= shiftsb
end

function shootBullet(dir, dt)
  if player.fire_timer > global.fire_timer and player.ammo > 0 then
    player.ammo = player.ammo - 1
    player.fire_timer = 0
    if dir == "up" then
      table.insert(bullets.info, {px=(player.sqmx-1)*32+player.offsetx+16, py=(player.sqmy-1)*32+player.offsety, xvel=0, yvel=-1})
    elseif dir == "down" then
      table.insert(bullets.info, {px=(player.sqmx-1)*32+player.offsetx+16, py=(player.sqmy-1)*32+player.offsety+32, xvel=0, yvel=1})
    elseif dir == "left" then
      table.insert(bullets.info, {px=(player.sqmx-1)*32+player.offsetx, py=(player.sqmy-1)*32+player.offsety+16, xvel=-1, yvel=0})
    elseif dir == "right" then
      table.insert(bullets.info, {px=(player.sqmx-1)*32+player.offsetx+32, py=(player.sqmy-1)*32+player.offsety+16, xvel=1, yvel=0})
    end
  end
end

function updateBullets(dt)
  for i=#bullets.info,1,-1 do
    if bullets.info[i].px > global.sizex or bullets.info[i].py > global.sizey or bullets.info[i].px < 0 or bullets.info[i].py < 0 then
      table.remove(bullets.info, i)
    end
  end
  for i=#bullets.info,1,-1 do
    bullets.info[i].px = bullets.info[i].px + bullets.info[i].xvel*200*dt
    bullets.info[i].py = bullets.info[i].py + bullets.info[i].yvel*200*dt
  end
end

function remakeWorld()
  for i=1, world.sizex, 1 do
    for j=1, world.sizey, 1 do
      if world.diff > 2 then
        world.map[i][j].box = love.math.random(-1,1+world.diff)
      else world.map[i][j].box = love.math.random(0,1+world.diff)
      end
    end
  end
  world.map[1][1].box = 0
  world.map[1][2].box = 0
  world.map[2][1].box = 0
  world.map[2][2].box = 0
end

function checkWin()
  if player.sqmx == world.sizex and player.sqmy == world.sizey then
    world.diff = world.diff+1
    player.sqmx=1
    player.sqmy=1
    player.targetx=1
    player.targety=1
    player.shifts=700+world.diff*7
    player.ammo=1000*world.diff
    remakeWorld()
  end
end

function checkBulletCollision()
  for i=1,world.sizex,1 do
    for j=1,world.sizey,1 do
      for k=#bullets.info,1,-1 do
        if bullets.info[k].px >= (i-1)*32 and bullets.info[k].px <= i*32 and bullets.info[k].py >= (j-1)*32 and bullets.info[k].py <= j*32 and world.map[i][j].box ~= -1 and (world.map[i][j].box%3) == 2 then
          table.remove(bullets.info, k)
          world.map[i][j].box = 0
        end
      end
    end
  end
end

function love.load()
  love.window.setTitle("World Shifter")
  map = {
    image = love.graphics.newImage("tileset2.png"),
    Quads = {},
    }
  world = {
    sizex = math.ceil(love.window.getWidth()/32),
    sizey = math.ceil(love.window.getHeight()/32),
    diff = 5,
    }
  player = {
    charQuads = {},
    charImage = love.graphics.newImage("char2.png"),
    sqmx = 1,
    sqmy = 1,
    targetx = 1,
    targety = 1,
    offsetx = 0,
    offsety = 0,
    dir = 0,
    frame = 2,
    frame_timer = 0,
    walk_delay = 0,
    moving = false,
    shifts = 7+world.diff*7,
    fire_timer = 0,
    ammo = 10*world.diff,
  }
  createWorld()
  global = {
    sizex = love.window.getWidth(),
    sizey = love.window.getHeight(),
    frame_timer = 0.1,
    walk_delay = 0.1,
    fire_timer = 0.3,
  }
  bullets = {
    info = {},
  }
  LoadCharacter()
  LoadMap()
end

function love.update(dt)
  movePlayer(dt)
  updateBullets(dt)
  checkBulletCollision()
  player.walk_delay = player.walk_delay + dt
  player.fire_timer = player.fire_timer + dt
  checkWin()
  
  if love.keyboard.isDown("up") then
    shootBullet("up", dt)
    if player.dir ~= 3 then
      player.dir = 3
      changeFrame(player.dir)
    end
  elseif love.keyboard.isDown("down") then
    shootBullet("down", dt)
    if player.dir ~= 0 then
      player.dir = 0
      changeFrame(player.dir)
    end
  elseif love.keyboard.isDown("left") then
    shootBullet("left", dt)
    if player.dir ~= 1 then
      player.dir = 1
      changeFrame(player.dir)
    end
  elseif love.keyboard.isDown("right") then
    shootBullet("right", dt)
    if player.dir ~= 2 then
      player.dir = 2
      changeFrame(player.dir)
    end
  end
  if not player.moving then
    if love.keyboard.isDown("w")then
      if player.walk_delay > global.walk_delay then
        player.targety = player.targety - 1
        player.walk_delay = 0
      end
    elseif love.keyboard.isDown("s")then
      if player.walk_delay > global.walk_delay then
        player.targety = player.targety + 1
        player.walk_delay = 0
      end
    elseif love.keyboard.isDown("a") then
      if player.walk_delay > global.walk_delay then
        player.targetx = player.targetx - 1
        player.walk_delay = 0
      end
    elseif love.keyboard.isDown("d") then
      if player.walk_delay > global.walk_delay then
        player.targetx = player.targetx + 1
        player.walk_delay = 0
      end
    end
  end
end

function love.keypressed(key)
  if key == "return" and not player.moving then
    if not shiftWorld() then
      player.sqmx=1
      player.sqmy=1
      player.targetx=1
      player.targety=1
      player.shifts=10+world.diff*7
      player.ammo=10*world.diff
      remakeWorld()
    end
  end
end

function love.draw()
  love.graphics.setColor(255,255,255)
  for i=1, world.sizex, 1 do
    for j=1, world.sizey, 1 do
      if world.map[i][j].box == -1 then
        love.graphics.draw(map.image, map.Quads[7], (i-1)*32+world.map[i][j].offsetx, (j-1)*32+world.map[i][j].offsety)
        --love.graphics.print("".. ((player.targetx - player.sqmx)/(math.abs(player.targetx - player.sqmx))) .."", (i-1)*32+world.map[i][j].offsetx, (j-1)*32+world.map[i][j].offsety)
      elseif (world.map[i][j].box%3) == 1 then
        love.graphics.draw(map.image, map.Quads[8], (i-1)*32, (j-1)*32)
      elseif (world.map[i][j].box%3) == 2 then
        love.graphics.draw(map.image, map.Quads[7], (i-1)*32, (j-1)*32)
      end
    end
  end
  for i=#bullets.info, 1, -1 do
    if math.abs(bullets.info[i].xvel) > math.abs(bullets.info[i].yvel) then
      love.graphics.rectangle("fill", bullets.info[i].px, bullets.info[i].py, 5, 2)
    else love.graphics.rectangle("fill", bullets.info[i].px, bullets.info[i].py, 2, 5)
    end
  end
  love.graphics.draw(player.charImage, player.charQuads[player.frame], (player.sqmx-1)*32 + player.offsetx, (player.sqmy-1) * 32 + player.offsety)
  love.graphics.setColor(255,0,0)
end