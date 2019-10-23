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

local function loadHeader(options, color)

    local headertext = display.newEmbossedText( options )
    headertext:setFillColor( 0,1,0,1)
    headertext:setEmbossColor( color )
end
function axisGroup:plotPoints(coordinates, option, locData)
    --Use image as dots made with display.newCircle() look like polygons
    --plots different image based on class. Finds it in locData
    --Assumes trying to plot global data if not given

    --Done this way so as to not duplicate information.
    --if points and class in same data, it can be passed twice.

        if option == 'selected' then
            self.selected.point = display.newImageRect( self, 'selectedDot.png', 60, 60 )
            self.selected.point.x = coordinates.x
            self.selected.point.y = coordinates.y

        elseif option == 'data' then
            --Plots points from the data.
            area = fullh*fullw --TODOuse content area to determine appropriate size for small screens
            self.points = {}
            local locData = locData or data

            for i=1, locData.length, 1 do
                --class 'a' red dots, class 'b' blue dots
                filename = (data[i].class == 'a' and 'redDot.png') or 'blueDot.png'
                self.points[i] = display.newImageRect( self, filename, 60, 60 )
                self.points[i].x = coordinates[i].x
                self.points[i].y = coordinates[i].y
            end
        end
end

function axisGroup:makexyAxis(group, data)
    --Will make the xy axis as well as populate data
    --Returns reference to said group

    group:insert(self)
    self.yOffset = 200
    self.coordinates = {}
    self.selected = {}
    self.xmaxMargin = 10
    self.yminMargin = 50
    self.ymaxMargin = 25
    
    self.xmin = 50
    self.coordinates.xmin = self.xmin

    self.ymax = 10 + self.yOffset
    self.coordinates.ymax = self.ymax

    self.xmax = fullw - self.xmaxMargin
    self.coordinates.xmax = (self.xmax-30)

    self.ymin = centerY - self.yminMargin + self.yOffset
    self.coordinates.ymin = self.ymin

    self.xLabel = data.xlabel
    self.yLabel = data.yLabel
    self.background = display.newRect(self, 0,0,0,0)
    self.background:setFillColor( 0.8 )
    self.background.path.x1, self.background.path.y1 = 0,self.yOffset
    self.background.path.x2, self.background.path.y2 = 0,centerY+self.yOffset
    self.background.path.x3, self.background.path.y3 = fullw,centerY+self.yOffset
    self.background.path.x4, self.background.path.y4 = fullw,self.yOffset
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
    self.yaxis = display.newLine(axisGroup, self.xmin, self.ymin+self.yminMargin, self.xmin, self.ymax)
    self.yaxis.strokeWidth = self.axisWidth
    self.yaxis:setStrokeColor( 0, 0, 0 )
    --local ymax = display.newLine(axisGroup, axis.left-5, axis.top, axis.left, axis.top)
    --ymax.strokeWidth = 5
    --ymax:setStrokeColor( 0, 0, 0 )
    --local ymid = display.newLine(axisGroup, axis.left-5, (axis.bottom+axis.top)/2, axis.left, (axis.bottom+axis.top)/2)
    --ymid.strokeWidth = 5
    --ymid:setStrokeColor( 0, 0, 1 )


    --Below's function will return relevant xy-coordinates of axis 
    self.coordinates = classify.scaler(data, self.coordinates)
    -- plot points --
    --Convert to OOP
    self:plotPoints(self.coordinates, 'data')

end
function axisGroup:selectedAxisRemove()

    local removed = false
    
    if self.selected.xAxis then
        print('removing x/y axis')
        self.selected.xAxis:removeSelf()
        self.selected.xAxis = nil

        self.selected.yAxis:removeSelf()
        self.selected.yAxis = nil
        removed = true
    end
    if self.selected.point then
        print('removing point')
        --if point has already been plotted
        --then remove it
        self.selected.point.x = nil
        self.selected.point.y=nil
        self.selected.point:removeSelf()
        self.selected.point = nil
        removed = true
    end
    if self.selected.result then
        print('removing connecting lines')
        --Classification done and plotted. Remove it

        for i=1, #self.selected.result, 1 do
            self.selected.result[i].axis:removeSelf()
            self.selected.result[i].alpha = nil
        end
        self.selected.result = nil
        removed = true
    end

    print('End removing selected details')
    return removed

end
function axisGroup:selectedAxis(x,y)
    
    --Will reuse this line to represent the xy axises for selected point
    self.selected.xAxis = display.newLine(axisGroup,x,y,self.xmin,y)
    self.selected.xAxis.strokeWidth = 10
    self.selected.xAxis:setStrokeColor( 0, 0, 0 )

    self.selected.yAxis = display.newLine(axisGroup,x,y,x,self.ymin)
    self.selected.yAxis.strokeWidth = 10
    self.selected.yAxis:setStrokeColor( 0, 0, 0 )
end

function axisGroup:showWinners(k)
    --Will simply plot lines with varying colours
    --to the nearest k-neighboors
    print('showing winners of selected point x/y:')
    print(self.selected.point.x, self.selected.point.y)
    self.selected.result = {}
    local filename
    local x,y = 0,0

    outRange = {
        xmin = self.coordinates.xmin,
        xmax = self.coordinates.xmax,
        ymin = self.coordinates.ymin,
        ymax = self.coordinates.ymax
    }
    self.sortedData.xmin, self.sortedData.xmax = data.xmin, data.xmax 
    self.sortedData.ymin, self.sortedData.ymax = data.ymin, data.ymax
    self.sortedData.length= data.length
    --local x-y coordinates of closest points
    self.sortedData.coordinates = classify.scaler(self.sortedData, outRange)
    
    outRange = nil
    --Create lines
    for i=k, 1, -1 do
        
        self.selected.result[i] = {}
        --Below will determine how strong the colour will be
        self.selected.result[i].axis = display.newLine(
            self,
            self.selected.point.x, --Start points at selected point
            self.selected.point.y,
            self.sortedData.coordinates[i].x, --End points at corresponding point.
            self.sortedData.coordinates[i].y)

        self.selected.result[i].axis.strokeWidth = 5

        if self.sortedData[i].class=='a' then
            print('class a point @ x/y')
            print(self.sortedData[i].x, self.sortedData[i].y)
            --Figure out alpha value based on relative value of point's weight vs its own class weight
            self.selected.result[i].alpha = self.sortedData[i].dist/self.sortedData.result.totalDistA
            self.selected.result[i].axis:setStrokeColor( 1, 0, 0, self.selected.result[i].alpha )
        else 
            print('class b point')
            print(self.sortedData[i].x, self.sortedData[i].y)
            --Figure out alpha value based on relative value of point's weight vs its own class weight
            self.selected.result[i].alpha = self.sortedData[i].dist/self.sortedData.result.totalDistB
            self.selected.result[i].axis:setStrokeColor( 0, 0, 1, self.selected.result[i].alpha )
        end
    end

    --Changing selected colour to it's new class colour
    filename = (self.sortedData.result.winner == 'a' and 'redDot.png') or 'blueDot.png'
    x,y = self.selected.point.x,self.selected.point.y
    self.selected.point:removeSelf()
    self.selected.point = display.newImageRect( self, filename, 60, 60 )
    self.selected.point.x,self.selected.point.y = x,y
    print('end showing winners')
end
function axisGroup:classify()
    --self.selected.point
    --self.points
    --Implement options (second part of screen.)
    print('Data 1st point x/y: ',data[1].x, data[1].y)
    local point = {}
    point[1] = {x=self.selected.point.x, y=self.selected.point.y}
    point.xmin, point.xmax = self.coordinates.xmin, self.coordinates.xmax
    point.ymin, point.ymax = self.coordinates.ymin, self.coordinates.ymax
    point.length = 1
    outRange = {
        xmin = data.xmin,
        xmax = data.xmax,
        ymin = data.ymin,
        ymax = data.ymax
    }
    --print(point[1].x, point[1].y)
    outRange = classify.scaler(point, outRange)

    self.dataPoint = {x=outRange[1].x, y=outRange[1].y}
    --print(self.dataPoint.x, self.dataPoint.y)
    self.sortedData = classify.main(self.dataPoint, data, 4, 'euclidean')
    point = nil
    outRange = nil
    axisGroup:showWinners(4)
end
-- -----------------------------------------------------------------------------------
-- axisGroup event function listeners
-- -----------------------------------------------------------------------------------

-- Forever grow shrinking behaviour
local grow
local function shrink(ref)
    print('shrinking')
    transition.scaleTo( axisGroup.selected.point, {xScale = 1, yScale=1, time=2000, onComplete=grow} )
end
grow = function (ref)
    print('growing')
    transition.scaleTo( axisGroup.selected.point, {xScale = 2, yScale=2, time=2000, onComplete=shrink} )
end

local function growShrinkRemove()
    --Cancel shrinkng and growing on selected point.
    if axisGroup.selected.point and axisGroup.selected.point.growShrink then
        transition.cancel(axisGroup.selected.point)
        axisGroup.selected.point:removeEventListener('touch', grow)
        axisGroup.selected.point:removeEventListener('touch', shrink)
        grow = nil
        shrink = nil
        axisGroup.selected.point.growShrink = nil
        return true
    end
    return false
end

local function selectPoint(event)

    if event.phase == "began" then
        --If a point has already been plotted, then remove it
        growShrinkRemove()
        axisGroup:selectedAxisRemove()
        axisGroup:selectedAxis(event.xStart, event.yStart)
        return true
    elseif event.phase == 'moved' then
        --If a point has already been plotted, then remove it
        axisGroup:selectedAxisRemove()
        axisGroup:selectedAxis(event.x, event.y)
    elseif event.phase == 'ended' then
        local pnt = {x=event.x, y=event.y}
        -- Plot selected point
        axisGroup:plotPoints( pnt, 'selected')
        --Classify selected point
        --Confirmation beforehand needed?
        axisGroup:classify()
    end
end

-- -----------------------------------------------------------------------------------
-- Options Group.
-- -----------------------------------------------------------------------------------

local options = display.newGroup()


function options:render()
--Define area
end
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------

function scene:create( event )
    print('creating scene')
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --Create Header
    local headerOptions = {
        text = 'Select a point',
        x=centerX+100,
        y=100,
        height = 200,
        width = fullw,
        font = 'Helvetica',
        fontSize =100
    }
    local color = 
    {
        highlight = { r=0, g=1, b=0},
        shadow = { r=1, g=1, b=1 },
        alpha = {0,1,0,1}
    }
    --loadHeader(headerOptions, color)
    -- Assign "self.view" to local variable "sceneGroup" for easy reference
    local sceneGroup = self.view
    axisGroup:makexyAxis(sceneGroup, data)
    axisGroup.background:addEventListener( "touch", selectPoint )
    --center of background to plot initial selected point
    local coordinates = {
        x=(axisGroup.background.path.x4-axisGroup.background.path.x1)/2,
        y=axisGroup.yOffset+(axisGroup.background.path.y2-axisGroup.background.path.y1)/2
    }

    print('Initial x/y of selected',coordinates.x, coordinates.y)
    axisGroup:selectedAxisRemove()
    axisGroup:selectedAxis(coordinates.x, coordinates.y)
    axisGroup:plotPoints(coordinates, 'selected')
    axisGroup.selected.point.growShrink = true
    axisGroup.selected.point:addEventListener( "touch", grow )
    axisGroup.selected.point:addEventListener( "touch", shrink )
    grow()

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