-- ---------------
-- loading.lua
-- ---------------

local composer = require( "composer" )

local scene = composer.newScene()
local widget = require("widget")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- Preload the data here
local sceneNumber = 0

local message = "A wise man once said:\n\n ...Machine Learning is like teenage sex. Everyone talks about it, nobody really knows how to do it, everyone thinks everybody else is doing it, so everyone claims they're doing it."

local height = display.actualContentHeight
local width = display.actualContentWidth

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------

function scene:create( event )

    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Assign "self.view" to local variable "sceneGroup" for easy reference
    local sceneGroup = self.view
    -- Options for our little greeting message.
    messageOptions = {
        parent = sceneGroup,
        text = message,
        x=display.contentCenterX,
        y=display.contentCenterY,
        height = height*0.8,
        width = width*0.8,
        font = 'Helvetica',
        fontSize =90
    }

    local button1 = widget.newButton(
    {
        id = "continueBtn",
        label = "Continue",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 300,
        height = 100,
        cornerRadius = 80,
        fillColor = { default={0,1,0,1}, over={0,1,0,0.8} },
        x= display.contentCenterX,
        y = height*0.9
    }
)
    button1._view._label.size = 60
    button1._view._label.color = {1,1,1}

    print(height*0.9, width)

    local messageText = display.newEmbossedText( messageOptions )
    messageText:setFillColor( 0.8 )
 
    local color = 
    {
        highlight = { r=1, g=1, b=1 },
        shadow = { r=0.3, g=0.3, b=0.3 }
    }
    messageText:setEmbossColor( color )
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



scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene