-- ---------------
-- selectScene.lua
-- ---------------

local composer = require( "composer" )
local widget = require("widget")
local loadsave = require("loadsave")

local scene = composer.newScene()
local confTable = loadsave.loadTable('config.json')
local data = composer.getVariable('data')

local centerX  = display.contentCenterX
local centerY  = display.contentCenterY
local fullw    = display.actualContentWidth 
local fullh    = display.actualContentHeight
local left     = centerX - fullw/2
local top      = centerY - fullh/2
local right    = (centerX + fullw/2)
local bottom   = centerY + fullh/2

local function dataToCordinates(data, axis)
    --Simply maps the data points to the range of the axis
    --by using the ratio between the axis-range and relevant maximum data point.
    local cordinates
    for i=0, data.length, 1 do
        coordinates[i].x = data[i].x*(axis.right/data.xmax)
        coordinates[i].y = data[i].y*(axis.bottom/data.ymax)
    end
    return coordinates

end
local function makexyAxis(group, data)
    --Will make the xy axis as well as populate data
    --Returns reference to said group

    --create group
    local axis = {}
    local axisGroup = display.newGroup()
    group:insert(axisGroup)
    axis.rightMargin = 10
    axis.bottomMargin = 50
    
    axis.left = 50
    axis.top = 10
    axis.right = fullw - axis.rightMargin
    axis.bottom = centerY - axis.bottomMargin
    axis.xLabel = data.xlabel
    axis.yLabel = data.yLabel
    axisBackground = display.newRect(axisGroup, 0,0,0,0)
    axisBackground:setFillColor( 0.8 )
    axisBackground.path.x1, axisBackground.path.y1 = 0,0
    axisBackground.path.x2, axisBackground.path.y2 = 0,centerY
    axisBackground.path.x3, axisBackground.path.y3 = fullw,centerY
    axisBackground.path.x4, axisBackground.path.y4 = fullw,0
    --Below's function will place the data points on the axis.
    local cordinates = dataToCordinates(data, axis)
    
    --Xaxis line with a max and a mid line
    axis.width = 10
    axis.colour = {0,0,0,1}
    local xaxis = display.newLine(axisGroup, 0, axis.bottom, axis.right, axis.bottom)
    xaxis.strokeWidth = axis.width
    xaxis:setStrokeColor( 0, 0, 0  )
    local xmax = display.newLine(axisGroup, axis.right-5, axis.bottom, axis.right-5, axis.bottom+30)
    xmax.strokeWidth = 5
    xmax:setStrokeColor( 0, 0, 1 )
    local xmid = display.newLine(axisGroup, (axis.left+axis.right)/2, axis.bottom, (axis.left+axis.right)/2, axis.bottom+5)
    xmid.strokeWidth = 5
    xmid:setStrokeColor( 0, 0, 1 )

    --Yaxis line with a max and a mid line
    local yaxis = display.newLine(axisGroup, axis.left, centerY, axis.left, axis.top)
    yaxis.strokeWidth = axis.width
    yaxis:setStrokeColor( 0, 0, 0 )
    local ymax = display.newLine(axisGroup, axis.left-5, axis.top, axis.left, axis.top)
    ymax.strokeWidth = 5
    ymax:setStrokeColor( 0, 0, 0 )
    local ymid = display.newLine(axisGroup, axis.left-5, (axis.bottom+axis.top)/2, axis.left, (axis.bottom+axis.top)/2)
    ymid.strokeWidth = 5
    ymid:setStrokeColor( 0, 0, 1 )


    --Below's function will return relevant xy-cordinates of axis
    local cordinates = dataToCordinates(data, axis)
    -- plot points --

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------

function scene:create( event )
    
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Assign "self.view" to local variable "sceneGroup" for easy reference
    local sceneGroup = self.view
    makexyAxis(sceneGroup, data)
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
    loadsave.saveTable(confTable, 'config.json')
    -- Code here runs prior to the removal of scene's view

end



scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene