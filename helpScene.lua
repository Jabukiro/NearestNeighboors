-- -----------------------------------------------------------------------------------
-- settingsScene.lua
-- Serve as the overlay scene that will show when settings button pressed
-- Will return chosen k value and use of weight or not to parent 'options' scene.
-- -----------------------------------------------------------------------------------
local widget = require("widget")
local composer = require( "composer" )
local json = require ("json")

local scene = composer.newScene()

-- Screen framing
local centerX  = display.contentCenterX
local centerY  = display.contentCenterY
local fullw    = display.actualContentWidth 
local fullh    = display.actualContentHeight
local left     = centerX - fullw/2
local top      = centerY - fullh/2
local right    = (centerX + fullw/2)
local bottom   = centerY + fullh/2

--serve as reference to parrent
local options

--Variable to 'return'(via composer) to main scene.
local settings

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function quitScene()
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function settingsHelp(group)
    local weightsHelp = "The Weights settings is used to give more consideration, i.e. weight, to points closer to the selected point.\nThe closer the point, the more weight it has.\n\n\n"
    local euclideanHelp = "Eudlidean: The shortest distance measure. Straight line between two points.\n\n"
    local manhttanHelp = "Manhattan: Also known as 'snake' distance. Distance is the sum of the absolute differences between the coordinates.\n\n"
    local chebyshevHelp = "Chebyshev: The most interesting of the three. Also known as 'King\'s moves'. Points lying anywhere on a square of which a selected point is the center, will have the same distance to the selected point."

    local helpMsg = weightsHelp..euclideanHelp..manhttanHelp..chebyshevHelp
    local weights = display.newText( {
        parent = group,
        text = helpMsg,
        width = fullw - 130,
        height = 0,
        x = centerX,
        y = 800,
        fontSize = 50
    })
end

local function help(group)
    local intro = "This app serves to showcase k-nn classification.\nThe 'k' stands for any number(1,2,3,4 etc...). 'nn' 'Nearest Neighboor'\n\n"
    local example = "For example, 4-nn classification (default of this app) will classify a selected point based on the classes of its 4 nearest points.\n\n"
    local usage = "A point can be selected by tapping anywhere on the map. It will turn red/blue based on its classification.\n\n"
    local settings = "Head on over to the settings to see what options you can configure. Click the help whilst in the settings menu for explanation."

    local helpMsg = intro..example..usage..settings
    local weights = display.newText( {
        parent = group,
        text = helpMsg,
        width = fullw - 130,
        height = 0,
        x = centerX,
        y = 800,
        fontSize = 50
    })
end


-- create()
function scene:create( event )

    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Assign "self.view" to local variable "sceneGroup" for easy reference
    local sceneGroup = self.view
    options = event.parent
    local paint = {
        type = "gradient",
        color1 = { 0,0,0,1 },
        color2 = { 0,0,0,0.6 },
        direction = "right"
    }
     
    sceneGroup.rect = display.newRect( sceneGroup, centerX, centerY, fullw-100, fullh-130 )
    sceneGroup.rect:setFillColor( 0,0,0,1 )
    sceneGroup.rect.stroke = paint
    sceneGroup.rect.strokeWidth = 200
    if event.params.settingsContext then 
        --Show help wittin settingsContext
        settingsHelp(sceneGroup)
    else
        help(sceneGroup)
    end
    
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end



-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
return scene