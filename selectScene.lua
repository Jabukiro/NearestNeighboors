-- ---------------
-- selectScene.lua
-- ---------------

local composer = require( "composer" )
local widget = require("widget")
local loadsave = require("loadsave")
local classify = require("classify")

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

local axisGroup = display.newGroup()

function axisGroup:plotPoints(coordinates, locData)
    --Use image as dots made with display.newCircle() look like polygons
    --plots different image based on class. Finds it in locData
    --Assumes trying to plot global data if not given

    --Done this way so as to not duplicate information.
    --if points and class in same data, it can be passed twice.

        area = fullh*fullw --TODOuse content area to determine appropriate size for small screens

        local locData = locData or data

        for i=1, data.length, 1 do
            --class 'a' red dots, class 'b' blue dots
            print(data[i].class)
            filename = (data[i].class == 'a' and 'redDot.png') or 'blueDot.png'
            local object = display.newImageRect( self, filename, 60, 60 )
            object.x = coordinates[i].x
            object.y = coordinates[i].y
        end
end

function axisGroup:makexyAxis(group, data)
    --Will make the xy axis as well as populate data
    --Returns reference to said group

    local coordinates = {}

    group:insert(self)
    print(self)

    self.xmaxMargin = 10
    self.yminMargin = 50
    
    self.xmin = 50
    coordinates.xmin = self.xmin

    self.ymax = 10
    coordinates.ymax = self.ymax

    self.xmax = fullw - self.xmaxMargin
    coordinates.xmax = (self.xmax-30)

    self.ymin = centerY - self.yminMargin
    coordinates.ymin = self.ymin

    self.xLabel = data.xlabel
    self.yLabel = data.yLabel
    self.background = display.newRect(self, 0,0,0,0)
    self.background:setFillColor( 0.8 )
    self.background.path.x1, self.background.path.y1 = 0,0
    self.background.path.x2, self.background.path.y2 = 0,centerY
    self.background.path.x3, self.background.path.y3 = fullw,centerY
    self.background.path.x4, self.background.path.y4 = fullw,0
    print(self.background)
    --Below's function will place the data points on the axis.

    
    --Xaxis line with a max and a mid line
    self.axisWidth = 10
    self.colour = {0,0,0,1}
    self.xaxis = display.newLine(self, 0, self.ymin, self.xmax, self.ymin)
    self.xaxis.strokeWidth = self.axisWidth
    self.xaxis:setStrokeColor( 0, 0, 0  )
    --local xmax = display.newLine(axisGroup, axis.right-5, axis.bottom, axis.right-5, axis.bottom+30)
    --xmax.strokeWidth = 5
    --xmax:setStrokeColor( 0, 0, 1 )
    --local xmid = display.newLine(axisGroup, (axis.left+axis.right)/2, axis.bottom, (axis.left+axis.right)/2, axis.bottom+5)
    --xmid.strokeWidth = 5
    --xmid:setStrokeColor( 0, 0, 1 )

    --Yaxis line with a max and a mid line
    self.yaxis = display.newLine(axisGroup, self.xmin, centerY, self.xmin, self.ymax)
    self.yaxis.strokeWidth = self.axisWidth
    self.yaxis:setStrokeColor( 0, 0, 0 )
    --local ymax = display.newLine(axisGroup, axis.left-5, axis.top, axis.left, axis.top)
    --ymax.strokeWidth = 5
    --ymax:setStrokeColor( 0, 0, 0 )
    --local ymid = display.newLine(axisGroup, axis.left-5, (axis.bottom+axis.top)/2, axis.left, (axis.bottom+axis.top)/2)
    --ymid.strokeWidth = 5
    --ymid:setStrokeColor( 0, 0, 1 )


    --Below's function will return relevant xy-coordinates of axis 
    coordinates = classify.scaler(data, coordinates)
    print(coordinates.xmax, coordinates.xmin, coordinates.ymax, coordinates.ymin)
    -- plot points --
    --Convert to OOP
    self:plotPoints(coordinates)

end
function axisGroup:selectedAxisRemove()
    if axisGroup.selectedXaxis then
        axisGroup.selectedXaxis:removeSelf()
        axisGroup.selectedXaxis = nil

        axisGroup.selectedYaxis:removeSelf()
        axisGroup.selectedYaxis = nil
        return true
    else 
        return false
    end

end
function axisGroup:selectedAxis(x,y)
    
    --Can't edit line paths so recreate it everytime. First delete if exists
    local deleted = self:selectedAxisRemove()
    
    --Will reuse this line to represent the xy axises for selected point
    axisGroup.selectedXaxis = display.newLine(axisGroup,x,y,self.xmin,y)
    axisGroup.selectedXaxis.strokeWidth = 10
    axisGroup.selectedXaxis:setStrokeColor( 0, 0, 0 )

    axisGroup.selectedYaxis = display.newLine(axisGroup,x,y,x,self.ymin)
    axisGroup.selectedYaxis.strokeWidth = 10
    axisGroup.selectedYaxis:setStrokeColor( 0, 0, 0 )
end
-- -----------------------------------------------------------------------------------
-- axisGroup event function listeners
-- -----------------------------------------------------------------------------------

local function selectPoint(event)

    if event.phase == "began" then
        axisGroup:selectedAxis(event.xStart, event.yStart)
        return true
    elseif event.phase == 'moved' then
        axisGroup:selectedAxis(event.x, event.y)
    elseif event.phase == 'ended' then
        print('point selected at x= '..event.x..' and y='..event.y)
    end
end
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------

function scene:create( event )
    
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Assign "self.view" to local variable "sceneGroup" for easy reference
    local sceneGroup = self.view
    axisGroup:makexyAxis(sceneGroup, data)
    
    axisGroup.background:addEventListener( "touch", selectPoint )
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