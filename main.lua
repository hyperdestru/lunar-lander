love.graphics.setDefaultFilter("nearest")

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function round2(num, numDecimalPlaces)
  return string.format("%." .. (numDecimalPlaces or 0) .. "f", num)
end

function goodLanding()
	if math.abs(Lander.vy) <= 1 and 
		math.abs(Lander.vx) <= 1 and
		Lander.angle >= 265 and 
		Lander.angle <= 275 and 
		Lander.fuel > 0 then
		return true
	else
		return false
	end
end

function love.load()

	GAME_WIDTH = love.graphics.getWidth()
	GAME_HEIGHT = love.graphics.getHeight()

	current_screen = 'menu'

	Lander = {}
	Lander.x = love.math.random(50, GAME_WIDTH - 50)
	Lander.y = GAME_HEIGHT / 4
	Lander.vx = 0
	Lander.vy = 0
	Lander.angle = 270
	Lander.speed = 3
	Lander.vmax = 2
	Lander.fuel = 100
	Lander.engine_on = false
	Lander.crash = false
	Lander.landed = false

	Lander.img = love.graphics.newImage("images/spaceship.png")
	Lander.width = Lander.img:getWidth()
	Lander.height = Lander.img:getHeight()

	Lander.img_engine = love.graphics.newImage("images/engine-exhaust.png")
	Lander.engine_width = Lander.img_engine:getWidth()
	Lander.engine_height = Lander.img_engine:getHeight()

	Lander.sound = love.audio.newSource('sounds/spaceship.wav', 'static')
	Lander.sound:isLooping(true)
	Lander.sound_explode = love.audio.newSource('sounds/explode_touch.wav', 'static')

	gravity = 0.4
	music = love.audio.newSource('sounds/apollo-houston-problem.mp3', 'stream')
	music:setVolume(0.1)
	music:play()

	Stars = {}
	Stars.number = 100

	Map = {}
	Map.tilesheet = love.graphics.newImage('images/gc-tilesheet1.png')
	Map.TileTextures = {}

	grid1 = { 
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,53 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,53 },
		{ 53,53,00,00,00,00,00,00,00,53,53,53,53,00,00,00,00,00,00,00,00,00,00,53,53 },
		{ 53,53,53,00,00,00,00,53,53,53,53,53,53,53,00,00,00,00,00,00,00,00,00,53,53 },
		{ 53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53 },
		{ 53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53 },
		{ 53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53 }
	}

	grid2 = { 
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 53,00,00,53,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00 },
		{ 53,00,00,53,53,00,00,00,00,00,00,00,00,00,00,53,00,00,00,00,00,00,00,00,00 },
		{ 53,53,53,53,53,53,00,00,00,00,53,53,00,00,00,53,53,00,00,00,00,53,00,00,00 },
		{ 53,53,53,53,53,53,00,53,00,53,53,53,53,00,53,53,53,53,00,00,00,53,00,00,00 },
		{ 53,53,53,53,53,53,00,53,53,53,53,53,53,53,53,53,53,53,53,00,53,53,53,00,00 },
		{ 53,53,53,53,53,53,00,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53 },
		{ 53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53 },
	}

	local rand_nb = love.math.random(1, 2)
	if rand_nb == 1 then Map.Grid = grid1 elseif rand_nb == 2 then Map.Grid = grid2 else Map.Grid = nil end

	Map.TILE_HEIGHT = 32
	Map.TILE_WIDTH = 32
	Map.MAP_HEIGHT = 19
	Map.MAP_WIDTH = 25

	Map.TileTextures[0] = nil

    --Reading/cuting each Map.tilesheet tiles one by one : not related to the screen in any way
    local nb_cols = Map.tilesheet:getWidth() / Map.TILE_WIDTH
    local nb_lines = Map.tilesheet:getHeight() / Map.TILE_HEIGHT
    local l,c
    local id = 1
    for l = 1, nb_lines do
      for c = 1, nb_cols do
        Map.TileTextures[id] = love.graphics.newQuad(
          (c - 1) * Map.TILE_WIDTH, 
          (l - 1) * Map.TILE_HEIGHT, 
          Map.TILE_WIDTH, 
          Map.TILE_HEIGHT, 
          Map.tilesheet:getWidth(),
          Map.tilesheet:getHeight()
        )
        id = id + 1
      end
    end
    ----

	----Creating random Stars coordinates
	for i = 1, Stars.number do
		local x_rand = love.math.random(0, GAME_WIDTH)
		local y_rand = love.math.random(0, GAME_HEIGHT)
		Stars[i] = {}
		Stars[i][1] = x_rand
		Stars[i][2] = y_rand
	end
	----
end


function love.update(dt)

	if current_screen == 'game' then

		--Simulate the gravity pull of the moon : the lander is sort of attracted to the bottom because we increment its vertical velocity
		--It's an incrementation so it's like an acceleration : the vertical velocity is not constant (that'd have been : Lander.vy = gravity)
		Lander.vy = Lander.vy + (gravity * dt)

		Lander.x = Lander.x + Lander.vx
		Lander.y = Lander.y + Lander.vy

		--This is the way I deal with maximum velocity of the lander
		--I don't deal with the downwards acceleration limit: it'd be counter intuitive about the gravity pull we apply at the beginning
		--If you turn the engine on when going down it's the gravity pull + the "normal" engine acceleration (cf. press up key) => it is not constrained by a maximum velocity
		if Lander.vy < -Lander.vmax then Lander.vy = -Lander.vmax end --Accelerating upwards (< 0)
		if Lander.vx < -Lander.vmax then Lander.vx = -Lander.vmax end --Accelerating to the left (< 0)
		if Lander.vx > Lander.vmax then Lander.vx = Lander.vmax end --Accelerating to the right (> 0)

		----SHIP CONTROL
		if love.keyboard.isDown('right') then
			Lander.angle = Lander.angle + (90 * dt)
			if Lander.angle > 360 then Lander.angle = 0 end
		end

		if love.keyboard.isDown('left') then
			Lander.angle = Lander.angle - (90 * dt)
			if Lander.angle < 0 then Lander.angle = 360 end
		end

		if love.keyboard.isDown('up') and Lander.fuel > 0 then
			----Movement equations
			local angle_rad = math.rad(Lander.angle)
			local force_x = math.cos(angle_rad) * (Lander.speed * dt)
			local force_y = math.sin(angle_rad) * (Lander.speed * dt)

			Lander.vx = Lander.vx + force_x
			Lander.vy = Lander.vy + force_y
			----

			Lander.engine_on = true
			Lander.fuel = Lander.fuel - 1
			Lander.sound:play()
		else
			Lander.engine_on = false
			Lander.sound:stop()
		end
		----

		----SHIP GROUND COLLISION
		do
			local c = math.floor(Lander.x / Map.TILE_WIDTH) + 1
			local l = math.floor((Lander.y + Lander.height / 2) / Map.TILE_HEIGHT) + 1
			if Map.Grid[l][c] == 53 then
				if goodLanding() == true then
					current_screen = 'win'
				else
					music:stop()
					Lander.sound_explode:play()
					current_screen = 'gameover'
				end
				Lander.vx = 0
				Lander.vy = 0
				gravity = 0
			else
				gravity = 0.6
			end
		end
		----
	end

end


function love.draw()

	----Drawing the actual textures "cut" off the Map.tilesheet in Game.Load()
    local c, l
    for l = 1, Map.MAP_HEIGHT do
      for c = 1, Map.MAP_WIDTH do
        local id = Map.Grid[l][c]
        local texQuad = Map.TileTextures[id]
        if texQuad ~= nil then
            local x = (c - 1) * Map.TILE_WIDTH
            local y = (l - 1) * Map.TILE_HEIGHT
            love.graphics.draw(Map.tilesheet, texQuad, x, y)
        end
      end
    end
    ----

	--DRAW STARS
	love.graphics.points(Stars)

	if current_screen == 'menu' then

		local str_title = "LUNAR LANDER"
		local str_start = "Press SPACE to Start"
		love.graphics.print(str_title, GAME_WIDTH / 4, GAME_HEIGHT / 3.5, 0, 4, 4)
		love.graphics.print(str_start, GAME_WIDTH / 3, GAME_HEIGHT / 3.5 + 132, 0, 2, 2)

	elseif current_screen == 'win' then

		local str_win = "MODULE IS LANDED. CONGRATULATIONS."
		love.graphics.print(str_win, GAME_WIDTH / 5, GAME_HEIGHT / 2, 0, 2, 2)

		--DRAW THE SHIP
		love.graphics.draw(Lander.img, Lander.x, Lander.y, math.rad(Lander.angle), 1, 1, Lander.width / 2, Lander.height / 2)

	elseif current_screen == 'game' then
		--DRAW THE SHIP
		love.graphics.draw(Lander.img, Lander.x, Lander.y, math.rad(Lander.angle), 1, 1, Lander.width / 2, Lander.height / 2)

		----DRAW ENGINE EXHAUST
		if Lander.engine_on == true then
			love.graphics.draw(Lander.img_engine, Lander.x, Lander.y, math.rad(Lander.angle), 1, 1, Lander.engine_width / 2, Lander.engine_height / 2)
		end

		----PRINTING LANDER DATA
		local vx = round2(math.abs(Lander.vx), 1)
		local vy = round2(math.abs(Lander.vy), 1)
		local ang = math.floor(Lander.angle)
		local fuel = Lander.fuel

		local str_data = ""
		str_data = str_data .. "X VELOCITY : " .. vx .. "\n"
		str_data = str_data .. "Y VELOCITY : " .. vy .. "\n"
		str_data = str_data .. "ANGLE : " .. ang .. "\n"
		str_data = str_data .. "FUEL : " .. fuel .. "\n"
		love.graphics.setColor(0,1,0)
		love.graphics.print(str_data, 20, 20, 0, 2, 2)
		love.graphics.setColor(1,1,1)
		----
	elseif current_screen == 'gameover' then

		local str_gameover = "MODULE HAS CRASHED. MISSION A06B IS OVER."
		love.graphics.print(str_gameover, GAME_WIDTH / 8, GAME_HEIGHT / 2, 0, 2, 2)

	end
end

function love.keypressed(key)
	if current_screen == 'menu' then
		if key == 'space' then
			current_screen = 'game'
		end
	end
end