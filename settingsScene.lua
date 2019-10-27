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
    sceneGroup.rect = display.newText(sceneGroup, "SETTINGS", centerX, centerY, fullw-300, fullh-200 )
    sceneGroup.rect = display.newText(sceneGroup, "Weights", centerX, centerY, fullw-300, fullh-360 )
    sceneGroup.rect = display.newText(sceneGroup, "Distance Metrics:", centerX, centerY, fullw-300, fullh-600 )
    sceneGroup.rect = display.newText(sceneGroup, "Euclidean", centerX, centerY, fullw-300, fullh-760 )
    sceneGroup.rect = display.newText(sceneGroup, "Manhattan", centerX, centerY, fullw-300, fullh-960 )
    sceneGroup.rect = display.newText(sceneGroup, "Chebychev", centerX, centerY, fullw-300, fullh-1160 )
    
    local settings = {}

    local function onSwitchPress(event)
        local switch = event.target
        print("Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn))
        local buttonData = switch.isOn
        if switch.id == "WeightsCheckbox" then
            --Set it to true/false
            settings.weights = buttonData
        else
            --Sets the chosen distance
        settings.distance = switch.id
        composer.setVariable("settings", settings)
        end
        local serializedJSON = json.encode(settings)
        print(serializedJSON)
    end

    -- Create a group for the radio button set
    local radioGroup = display.newGroup()

    sceneGroup:insert(radioGroup)

    -- Create three associated radio buttons (inserted into the same display group)
    local radioButton1 = widget.newSwitch(
    {
        left = 100,
        top = 400,
        style = "radio",
        id = "euclidean",
        initialSwitchState = true,
        onPress = onSwitchPress
    }
    )
    radioGroup:insert( radioButton1 )
 
    local radioButton2 = widget.newSwitch(
    {
        left = 100,
        top = 500,
        style = "radio",
        id = "manhattan",
        onPress = onSwitchPress
    }
    )
    radioGroup:insert( radioButton2 )

    local radioButton3 = widget.newSwitch(
    {
        left = 100,
        top = 600,
        style = "radio",
        id = "chebyshev",
        onPress = onSwitchPress
    }
    )
    radioGroup:insert( radioButton3 )

    local checkboxButton1 = widget.newSwitch(
        {
            left = 100,
            top = 200,
            style = "checkbox",
            id = "WeightsCheckbox",
            initialSwitchState = false,
            onPress = onSwitchPress
        }
    )
    sceneGroup:insert(checkboxButton1)
    
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