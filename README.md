# NearestNeighboors (Unstable)


loadsave.lua and luaunit.lua are imported modules. Their origin is specified in each file.


_ files contain unit tests for the specified modules. 


UI construct in main.lua and \*Scene files


## References

The settings logo were based on the following initial designs:
..* Author: freepik @ www.flaticon.com

## TODO

Features needed still: 

1. Settings to chose to do unitary or non unitary weights
2. Chose which distance measure. Euclidean, Manhattan, chebychev
2. Help menu. It can just be a brief explanation of what the app is and does

Implementation:

1. Settings will do in the settingsScene.lua. It has already been implemented as an overlay scene

meaning the scene will be on top of the main scene. Simply put a checkbox for 'Use weighting'

2. The second setting is 'Distance' and will be a choice between the thre mentioned distance
3. All settings should be saved in 'settings' variable and shared using composer.setVariable

