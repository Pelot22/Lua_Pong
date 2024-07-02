-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

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

balle = {}
balle.x = 0
balle.y = 0
balle.largeur = 20
balle.hauteur = 20
balle.vitesse_x = 2
balle.vitesse_y = 2

local largeurEcran, hauteurEcran
local balleSortie 

score_joueur1 = 0
score_joueur2 = 0

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
            pad.y = pad.y + 3
        end
    end
    if love.keyboard.isDown("a") then
        if pad.y > 1 then
            pad.y = pad.y - 3
        end
    end

    if love.keyboard.isDown("down") then
        if pad2.y < (hauteurEcran - (pad2.hauteur + 1)) then
            pad2.y = pad2.y + 3
        end
    end
    if love.keyboard.isDown("up") then
        if pad2.y > 1 then
            pad2.y = pad2.y - 3
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
    if balle.x < 0 or balle.x >= (largeurEcran - balle.largeur) then 
        balleSortie = true   
    end
    if balleSortie then
        departBalle()
    end

    balle.x = balle.x + balle.vitesse_x
    balle.y = balle.y + balle.vitesse_y
end

function love.draw()
   love.graphics.rectangle("fill", pad.x, pad.y, pad.largeur, pad.hauteur) 
   love.graphics.rectangle("fill", pad2.x, pad2.y, pad2.largeur, pad2.hauteur) 

   love.graphics.rectangle("fill", balle.x, balle.y, balle.largeur, balle.hauteur)

    local score = score_joueur1.." - "..score_joueur2
    love.graphics.print(score,(largeurEcran/2 -score.getWidth()/2), 1)

end

function love.keypressed(key)
    if key == "space" then
        balleSortie = false
        balle.vitesse_x = 2
        balle.vitesse_y = 2
    end
end
