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

local sceneGroup
--serve as reference to parrent
local parent

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function saved()
    local rect = display.newText(sceneGroup, "Saved", centerX, bottom*0.7 )
    rect:setFillColor( 0, 1, 0 )
    sceneGroup:insert(rect)
end

local function textListener( event )
 
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        if event.target.text == '' then 
            parent.settings.k = 4
        else 
            parent.settings.k = event.target.text +0
        end
        saved()
    elseif ( event.phase == "editing" ) then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
        if event.target.text == '' then 
            parent.settings.k = 4
        else 
            parent.settings.k = event.target.text +0
        end
        saved()
    end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Assign "self.view" to local variable "sceneGroup" for easy reference
    sceneGroup = self.view
    parent = event.params.parent

    -- Set intial checkboxes checked or unchecked
    local euclid, manhat, cheb = false, false, false
    if parent.settings.distance == 'euclidean' then 
        euclid = true
    elseif parent.settings.distance == 'manhattan' then
        manhat = true
    else
        cheb = true
    end
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
    sceneGroup.rect = display.newText(sceneGroup, "Weights", centerX, centerY, fullw-350, fullh-360 )
    sceneGroup.rect = display.newText(sceneGroup, "Distance Metrics:", centerX, centerY, fullw-300, fullh-600 )
    sceneGroup.rect = display.newText(sceneGroup, "Euclidean", centerX, centerY, fullw-350, fullh-760 )
    sceneGroup.rect = display.newText(sceneGroup, "Manhattan", centerX, centerY, fullw-350, fullh-960 )
    sceneGroup.rect = display.newText(sceneGroup, "Chebychev", centerX, centerY, fullw-350, fullh-1160 )
    sceneGroup.rect = display.newText(sceneGroup, "K-Value:", centerX, centerY, fullw-300, fullh-1400 )
    

    local function onSwitchPress(event)
        local switch = event.target
        print("Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn))
        local buttonData = switch.isOn
        if switch.id == "WeightsCheckbox" then
            --Set it to true/false
            parent.settings.weights = buttonData
            saved()
        else
            --Sets the chosen distance
        parent.settings.distance = switch.id
        saved()
        end
    end

    -- Create a group for the radio button set
    local radioGroup = display.newGroup()

    sceneGroup:insert(radioGroup)

    -- Create three associated radio buttons (inserted into the same display group)
    local radioButton1 = widget.newSwitch(
    {
        left = 125,
        top = 400,
        style = "radio",
        id = "euclidean",
        initialSwitchState = euclid,
        onPress = onSwitchPress
    }
    )
    radioGroup:insert( radioButton1 )
 
    local radioButton2 = widget.newSwitch(
    {
        left = 125,
        top = 500,
        style = "radio",
        id = "manhattan",
        initialSwitchState = manhat,
        onPress = onSwitchPress
    }
    )
    radioGroup:insert( radioButton2 )

    local radioButton3 = widget.newSwitch(
    {
        left = 125,
        top = 600,
        style = "radio",
        id = "chebyshev",
        initialSwitchState = cheb,
        onPress = onSwitchPress
    }
    )
    radioGroup:insert( radioButton3 )

    local checkboxButton1 = widget.newSwitch(
        {
            left = 125,
            top = 200,
            style = "checkbox",
            id = "WeightsCheckbox",
            initialSwitchState = parent.settings.weights,
            onPress = onSwitchPress
        }
    )
    radioGroup:insert( checkboxButton1 )
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        local kInput = native.newTextField( centerX-260, fullh-1080, 200, 80 )
        sceneGroup:insert(kInput)
        kInput.inputType = "number"
        kInput.placeholder = '4'
        kInput:addEventListener( "userInput", textListener )
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
-- -----------------------------------------------------------------------------------
return scene