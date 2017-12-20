--function love.conf(t)
--    t.screen.width = 1024
--    t.screen.height = 768
--

larguraTela = love.graphics.getWidth()
alturaTela = love.graphics.getHeight()

timer = 0
time = 2
anim = require( "anim8" )

function love.load()
	-- Tanque
	imgTanque = love.graphics.newImage( "imagens/Tanque.png" )

	Tanque = {
		posX = larguraTela / 4,
		posY = alturaTela / 2,
		velocidade = 200
	}
	-- Tanque

	-- Tiros
	atira = true
	delayTiro = 0.5
	tempoAteAtirar = delayTiro
	tiros = {}
	imgTiro = love.graphics.newImage( "imagens/Projetil.png" )
	-- Tiros

	-- Inimigos
	delayInimigo = 0.4
	tempoCriarInimigo = delayInimigo
	imgInimigo = love.graphics.newImage( "imagens/Inimigo.png" )
	inimigos = {}
	-- Inimigos

	-- Vidas e pontuacao
	estaVivo = true
	pontos = 0
	vidas = 5
	gameOver = false
	transparencia = 1
	imgGameOver = love.graphics.newImage( "imagens/gameOver.png" )
	-- Vidas e pontuacao

	-- Background
	fundo = love.graphics.newImage( "imagens/Background1.png" )
	fundoDois = love.graphics.newImage( "imagens/Background1.png" )

	planoDeFundo = {
		x = 0,
		y = 0,
		y2 = 0 - fundo:getHeight(),
		vel = 30
	}
	-- Background

	-- Fonte
	fonte = love.graphics.newImageFont( "imagens/Fonte.png", " abcdefghijklmnopqrstuvwxyz" .. "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" .. "123456789.,!?-+/():;%&`'*#=[]\"" )
	fonteDois = love.graphics.newFont( "fonte/fonteExemplo.ttf", 30 )
	-- Fonte

	-- Sons do jogo
	somDoTiro = love.audio.newSource( "sons/Tiro.wav", "static" )
	explodeTanque = love.audio.newSource( "sons/ExplodeTanque.wav", "static" )
	explodeInimigo = love.audio.newSource( "sons/ExplodeInimigo.wav", "static" )
	musica = love.audio.newSource( "sons/Musica.wav" )
	somGameOver = love.audio.newSource( "sons/GameOver.ogg" )
	musica:play()
	musica:setLooping( true )
	-- Sons do jogo

	-- Efeitos pontuacao
	scaleX = 1
	scaleY = 1
	-- Efeitos pontuacao

	-- Tela titulo
	abreTela = false
	telaTitulo = love.graphics.newImage( "imagens/back.png" )
	inOutX = 0
	inOutY = 0
	-- Tela titulo

	-- Pause
	pausar = false
	-- Pause

	-- Mega bomba
	bombaVazia = love.graphics.newImage( "imagens/BombaVazia.png" )
	bombaCheia = love.graphics.newImage( "imagens/BombaCheia.png" )
	bombaCheiaAviso = love.graphics.newImage( "imagens/BombaCheiaAviso.png" )
	explosao = love.graphics.newImage( "imagens/Explosao.png" )
	somExplosao = love.audio.newSource( "sons/Explosao.mp3" )

	explodir = {}
	podeExplodir = false
	carregador = 0
	animaAviso = 0.7

	local g = anim.newGrid( 192, 192, explosao:getWidth(), explosao:getHeight() )
	animation = anim.newAnimation( g( '1-5', 2, '1-5', 3, '1-5', 4, '1-4', 5 ), 0.09, destroi )
	-- Mega bomba{}

	-- Destroi inimigo
	expInimigo = {}
	destruicaoInimigo = love.graphics.newImage( "imagens/ExplosaoInimigo.png" )
	expInimigo.x = 0
	expInimigo.y = 0
	local gride = anim.newGrid( 64, 64, destruicaoInimigo:getWidth(), destruicaoInimigo:getHeight() )
	destroiInimigo = anim.newAnimation( gride( '1-5', 1, '1-5', 2, '1-5', 3, '1-5', 4, '1-3', 5 ), 0.01, destroiDois )
	-- Destroi inimigo

end

function love.update( dt )
	if not pausar then
		movimentos( dt )
		atirar( dt )
		inimigo( dt )
		colisoes()
		reset()
		planoDeFundoScrolling( dt )
		efeito( dt )
		iniciaJogo( dt )
		controlaExplosao( dt )
		bombaPronta( dt )
		controlaExplosaoDois( dt )



	end

	if gameOver then
		fimJogo( dt )
	end



  timer = time + love.timer.getDelta()
  if timer >= time then
     love.timer.sleep(0,5)
     timer = 0
   end
end


startx = love.timer.getTime()

function love.draw()
	if not gameOver then
		-- Background
		love.graphics.draw( fundo, planoDeFundo.x, planoDeFundo.y )
		love.graphics.draw( fundoDois, planoDeFundo.x, planoDeFundo.y2 )
		-- Background

    --time
    --
    --
love.graphics.print( ' Delta time '.. tostring(love.timer.getDelta()), 0, 0 )
--	Retorna o tempo entre os últimos dois quadros.

--love.graphics.print( ' Averge Delta time '.. tostring(love.timer.getAverageDelta()), 0, 20)
--love.graphics.print( ' Current FPS' .. tostring(love.timer.getFPS()), 0, 40)
--love.graphics.print( ' TEMPO:' .. tostring(love.timer.getTime()), 0, 60)
--
  --time

		-- Tiros
		for i, tiro in ipairs( tiros ) do
			love.graphics.draw( tiro.img, tiro.x, tiro.y, 0, 1, 1, imgTiro:getWidth() / 2, imgTiro:getHeight() )
			if pontos > 20 then
				love.graphics.draw( tiro.img, tiro.x - 10, tiro.y + 15, 0, 1, 1, imgTiro:getWidth() / 2, imgTiro:getHeight() )
				love.graphics.draw( tiro.img, tiro.x + 10, tiro.y + 15, 0, 1, 1, imgTiro:getWidth() / 2, imgTiro:getHeight() )
				delayTiro = 0.4
				if pontos > 50 then
					love.graphics.draw( tiro.img, tiro.x - 20, tiro.y + 30, 0, 1, 1, imgTiro:getWidth() / 2, imgTiro:getHeight() )
					love.graphics.draw( tiro.img, tiro.x + 20, tiro.y + 30, 0, 1, 1, imgTiro:getWidth() / 2, imgTiro:getHeight() )
					delayTiro = 0.3
					if pontos > 100 then
						delayTiro = 0.2
					end
				end
			end
		end
		-- Tiros

		-- Inimigos
		for i, inimigo in ipairs( inimigos ) do
			love.graphics.draw( inimigo.img, inimigo.x, inimigo.y )
		end
		-- Inimigos

		-- Destroi inimigo
		for i, _ in ipairs( expInimigo ) do
			destroiInimigo:draw( destruicaoInimigo, expInimigo.x, expInimigo.y )
		end
		-- Destroi inimigo

		-- Pontos na tela
		love.graphics.setFont( fonte )
		love.graphics.print( "Pontuacao: ", 10, 10, 0, 1, 1, 0, 2, 0, 0 )
		love.graphics.print( pontos, 105, 15, 0, scaleX, scaleY, 5, 5, 0, 0 )
		love.graphics.print( "Vidas: " .. vidas, 400, 15 )
		-- Pontos na tela



		-- Mega bomba
		for i, _ in ipairs( explodir ) do
			animation:draw( explosao, larguraTela / 2, alturaTela / 2, 0, 4, 4, 96, 96 )
		end
		love.graphics.draw( bombaVazia, larguraTela / 2, 50, 0, 1, 1, bombaVazia:getWidth() / 2, bombaVazia:getHeight() / 2 )
		love.graphics.draw( bombaCheia, larguraTela / 2, 50, 0, carregador, carregador, bombaCheia:getWidth() / 2, bombaCheia:getHeight() / 2 )
		if podeExplodir then
			love.graphics.draw( bombaCheiaAviso, larguraTela / 2, 50, 0, animaAviso, animaAviso, bombaCheiaAviso:getWidth() / 2, bombaCheiaAviso:getHeight() / 2 )
		end
		-- Mega bomba
	end

	-- Game over e reset
	if estaVivo then
		love.graphics.draw( imgTanque, Tanque.posX, Tanque.posY, 0, 1, 1, imgTanque:getWidth() / 2, imgTanque:getHeight() / 2 )
	elseif gameOver then
		love.graphics.setColor( 255, 255, 255, transparencia )
		love.graphics.draw( imgGameOver, 0, 0 )
		love.graphics.setFont( fonteDois )
		love.graphics.print( "PONTOS TOTAIS: " .. pontos, larguraTela / 4, 50 )
	else
		love.graphics.draw( telaTitulo, inOutX, inOutY )
	end
	-- Game over e reset
end

function movimentos( dt )
	if love.keyboard.isDown( "right" ) then
		if Tanque.posX < ( larguraTela - imgTanque:getWidth() / 2 ) then
			Tanque.posX = Tanque.posX + Tanque.velocidade * dt
		end
	end
	if love.keyboard.isDown( "left" ) then
		if Tanque.posX > ( 0 + imgTanque:getWidth() / 2 ) then
			Tanque.posX = Tanque.posX - Tanque.velocidade * dt
		end
	end
	if love.keyboard.isDown( "up" ) then
		if Tanque.posY > ( 0 + imgTanque:getHeight() / 2 ) then
			Tanque.posY = Tanque.posY - Tanque.velocidade * dt
		end
	end
	if love.keyboard.isDown( "down" ) then
		if Tanque.posY < ( alturaTela - imgTanque:getHeight() / 2 ) then
			Tanque.posY = Tanque.posY + Tanque.velocidade * dt
		end
	end
end

function atirar( dt )
	tempoAteAtirar = tempoAteAtirar - ( 1 * dt )
	if tempoAteAtirar < 0 then
		atira = true
	end
	if estaVivo then
		if love.keyboard.isDown( "space" ) and atira then
			novoTiro = { x = Tanque.posX, y = Tanque.posY, img = imgTiro }
			table.insert( tiros, novoTiro )
			somDoTiro:stop()
			somDoTiro:play()
			atira = false
			tempoAteAtirar = delayTiro
		end
	end

	for i, tiro in ipairs( tiros ) do
		tiro.y = tiro.y - ( 500 * dt )
		if tiro.y < 0 then
			table.remove( tiros, i )
		end
	end
end

function inimigo( dt )
	tempoCriarInimigo = tempoCriarInimigo - ( 1 * dt )
	if tempoCriarInimigo < 0 then
		tempoCriarInimigo = delayInimigo
		numeroAleatorio = math.random( 10, love.graphics.getWidth() - ( ( imgInimigo:getWidth() / 2 ) + 10 ) )
		novoInimigo = { x = numeroAleatorio, y = -imgInimigo:getWidth(), img = imgInimigo }
		table.insert( inimigos, novoInimigo )
	end

	for i, inimigo in ipairs( inimigos ) do
		inimigo.y = inimigo.y + ( 200 * dt )
		if inimigo.y > 850 then
			table.remove( inimigos, i )
		end
	end
end

function colisoes()
	for i, inimigo in ipairs( inimigos ) do
		for j, tiro in ipairs( tiros ) do
			if checaColisao( inimigo.x, inimigo.y, imgInimigo:getWidth(), imgInimigo:getHeight(), tiro.x, tiro.y, imgTiro:getWidth(), imgTiro:getHeight() ) then
				table.remove( tiros, j )
				expInimigo.x = inimigo.x
				expInimigo.y = inimigo.y
				table.insert( expInimigo, destroiInimigo )
				table.remove( inimigos, i )
				explodeInimigo:stop()
				explodeInimigo:play()
				scaleX = 1.5
				scaleY = 1.5
				pontos = pontos + 1
				carregador = carregador + 0.1
				if carregador >= 1 then
					carregador = 1
					podeExplodir = true
				end
			end
		end
		if checaColisao( inimigo.x, inimigo.y, imgInimigo:getWidth(), imgInimigo:getHeight(), Tanque.posX - ( imgTanque:getWidth() / 2 ), Tanque.posY, imgTanque:getWidth(), imgTanque:getHeight() ) and estaVivo then
			table.remove( inimigos, i )
			explodeTanque:play()
			estaVivo = false
			abreTela = false
			vidas = vidas - 1
			if vidas < 0 then
				gameOver = true
				somGameOver:play()
				somGameOver:setLooping( false )
			end
		end
	end
end

function checaColisao( x1, y1, w1, h1, x2, y2, w2, h2 )
	return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function reset()
	if not estaVivo and inOutY == 0 and love.keyboard.isDown( 'return' ) then
		tiros = {}
		inimigos = {}

		atira = tempoAteAtirar
		tempoCriarInimigo = delayInimigo

		Tanque.posX = larguraTela / 2
		Tanque.posY = alturaTela / 2

		abreTela = true
	end
end

function planoDeFundoScrolling( dt )
	planoDeFundo.y = planoDeFundo.y + planoDeFundo.vel * dt
	planoDeFundo.y2 = planoDeFundo.y2 + planoDeFundo.vel * dt

	if planoDeFundo.y > alturaTela then
		planoDeFundo.y = planoDeFundo.y2 - fundoDois:getHeight()
	end
	if planoDeFundo.y2 > alturaTela then
		planoDeFundo.y2 = planoDeFundo.y - fundo:getHeight()
	end
end

function efeito( dt )
	scaleX = scaleX - 3 * dt
	scaleY = scaleY - 3 * dt

	if scaleX <= 1 then
		scaleX = 1
		scaleY = 1
	end
end

function iniciaJogo( dt )
	if abreTela and not estaVivo then
		inOutX = inOutX + 600 * dt
		if inOutX > 481 then
			inOutY = -701
			inOutX = 0
			estaVivo = true
		end
	elseif not abreTela then
		estaVivo = false
		inOutY = inOutY + 600 * dt
		if inOutY > 0 then
			inOutY = 0
		end
	end
end

function love.keyreleased( key )
	if key == "p" and abreTela then
		pausar = not pausar
	end
	if pausar then
		musica:pause()
	else
		love.audio.resume( musica )
	end
	if key == "e" and not gameOver and podeExplodir then
		novaExplosao = {}
		table.insert( explodir, novaExplosao )
		somExplosao:play()
		carregador = 0
		for i, _ in ipairs( inimigos ) do
			pontos = pontos + 1
		end
		inimigos = {}
		podeExplodir = false
	end
end

function fimJogo( dt )
	pausar = true
	musica:stop()
	transparencia = transparencia + 100 * dt
	if love.keyboard.isDown( "escape" ) then
		love.event.quit()
	end
end

function controlaExplosao( dt )
	for i, _ in ipairs( explodir ) do
		animation:update( dt )
	end
end

function bombaPronta( dt )
	animaAviso = animaAviso + 0.5 * dt
	if animaAviso >= 1 then
		animaAviso = 0.8
	end
end

function destroi()
	for i, _ in ipairs( explodir ) do
		table.remove( explodir, i )
	end
end

function controlaExplosaoDois( dt )
	for i, _ in ipairs( expInimigo ) do
		destroiInimigo:update( dt )
	end
end

function destroiDois()
	for i, _ in ipairs( expInimigo ) do
		table.remove( expInimigo, i )
	end
end


