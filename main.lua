-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local font = love.graphics.newFont(20) -- font (nécessaire pour mesurer l'affichage des textes)

pad = {}
pad.x = 1
pad.y = 1
pad.largeur = 20
pad.hauteur = 80

pad2 = {}
pad2.x = 1
pad2.y = 1
pad2.largeur = 20
pad2.hauteur = 80

vitesseInitiale = 3

balle = {}
balle.x = 0
balle.y = 0
balle.largeur = 20
balle.hauteur = 20
balle.vitesse_x = vitesseInitiale
balle.vitesse_y = vitesseInitiale

local largeurEcran, hauteurEcran
local balleSortie 

score_joueur1 = 0
score_joueur2 = 0

listeTrainee = {}

function departBalle()
    balle.x = pad.x + pad.largeur + 1
    balle.y = pad.y + pad.hauteur/2 - balle.hauteur/2
    balle.vitesse_x = 0
    balle.vitesse_y = 0
end


function love.load()
    largeurEcran = love.graphics.getWidth()
    hauteurEcran = love.graphics.getHeight() 

    pad.y = hauteurEcran/2 - pad.hauteur/2
    pad2.y = hauteurEcran/2 - pad2.hauteur/2
    pad2.x = largeurEcran - pad2.largeur -1

    balleSortie = true
    departBalle() 
end

function love.update(dt)
    if love.keyboard.isDown("q") then
        if pad.y < (hauteurEcran - (pad.hauteur + 1)) then
            pad.y = pad.y + vitesseInitiale
        end
    end
    if love.keyboard.isDown("a") then
        if pad.y > 1 then
            pad.y = pad.y - vitesseInitiale
        end
    end

    if love.keyboard.isDown("down") then
        if pad2.y < (hauteurEcran - (pad2.hauteur + 1)) then
            pad2.y = pad2.y + vitesseInitiale
        end
    end
    if love.keyboard.isDown("up") then
        if pad2.y > 1 then
            pad2.y = pad2.y - vitesseInitiale
        end
    end

    --collision raquette
    if balle.x <= (pad.x + pad.largeur) 
        and (balle.y + balle.hauteur) > pad.y 
        and balle.y < (pad.y + pad.hauteur) then

        balle.vitesse_x = -balle.vitesse_x
        --apres collision on repositionne toujours la balle
        balle.x = pad.x + pad.largeur
    end 

    if (balle.x + balle.largeur) >= pad2.x
        and (balle.y + balle.hauteur) > pad2.y 
        and balle.y < (pad2.y + pad.hauteur) then

        balle.vitesse_x = -balle.vitesse_x
        --apres collision on repositionne toujours la balle
        balle.x = pad2.x - balle.largeur
    end 

    --collision bords
    if balle.y >= (hauteurEcran - balle.hauteur) or balle.y <= 0 then 
        balle.vitesse_y = -balle.vitesse_y
    end
        -- if balle.x >= (largeurEcran - balle.largeur) then 
        --     balle.vitesse_x = -balle.vitesse_x
        -- end

    --balle sortie 
    --on repositionne balle sur la raquette
    if balle.x < 0  then 
        balleSortie = true  
        score_joueur2 = score_joueur2 + 1 
    end
    if balle.x >= (largeurEcran - balle.largeur) then 
        balleSortie = true
        score_joueur1 = score_joueur1 + 1
    end
    if balleSortie then
        departBalle()
    end

    -- gestion de la trainee
    for n=#listeTrainee,1,-1 do
        listeTrainee[n].vie = listeTrainee[n].vie - dt
        --pour faire trainee dans tous les sens
        listeTrainee[n].x = listeTrainee[n].x + listeTrainee[n].vx 
        listeTrainee[n].y = listeTrainee[n].y + listeTrainee[n].vy 
        if listeTrainee[n].vie <= 0 then
            table.remove(listeTrainee, n)
        end
    end

    local maTrainee = {}
    maTrainee.x = balle.x
    maTrainee.y = balle.y
    maTrainee.vx = math.random(-1,1)
    maTrainee.vy = math.random(-1,1)
    maTrainee.r = math.random()
    maTrainee.v = math.random()
    maTrainee.b = math.random()
    maTrainee.vie = 1
    table.insert(listeTrainee, maTrainee)
    
    balle.x = balle.x + balle.vitesse_x
    balle.y = balle.y + balle.vitesse_y
end

function love.draw()
    --love.graphics.setFont(font)
   love.graphics.rectangle("fill", pad.x, pad.y, pad.largeur, pad.hauteur) 
   love.graphics.rectangle("fill", pad2.x, pad2.y, pad2.largeur, pad2.hauteur) 

   --dessin de la trainee
   for n=1,#listeTrainee do
    --love.graphics.setColor(1,1,1,listeTrainee[n].vie/2)  -- avec opacite reduite
    --love.graphics.rectangle("fill", listeTrainee[n].x,listeTrainee[n].y, balle.largeur, balle.hauteur)

    -- pour faire des bulles bleues
    --love.graphics.setColor(0.5,0.5,1,listeTrainee[n].vie/2)
    love.graphics.setColor(listeTrainee[n].r,listeTrainee[n].b,listeTrainee[n].b,listeTrainee[n].vie/2)
    love.graphics.circle("line",listeTrainee[n].x + balle.largeur/2, listeTrainee[n].y + balle.hauteur/2, 5)
   end

   --dessin de la balle
   love.graphics.setColor(1,1,1,1)
   love.graphics.rectangle("fill", balle.x, balle.y, balle.largeur, balle.hauteur)

    love.graphics.print(score_joueur1, font ,(largeurEcran/4), 1)
    love.graphics.print(score_joueur2, font ,(largeurEcran/4) * 3, 1)

    -- partie milieu qui coupe ecran en deux
    local positionY = 1
    while positionY <= (hauteurEcran - font:getHeight()) do
        love.graphics.print("|", font, (largeurEcran/2), positionY )
        positionY = positionY + (1 + font:getHeight())
    end

end

function love.keypressed(key)
    if key == "space" and balleSortie then
        balleSortie = false
        balle.vitesse_x = vitesseInitiale
        balle.vitesse_y = vitesseInitiale
    end
end
