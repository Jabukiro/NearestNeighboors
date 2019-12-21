# NearestNeighboors (Unstable)


loadsave.lua and luaunit.lua are imported modules. Their origin is specified in each file.


_ files contain unit tests for the specified modules. 


UI construct in main.lua and \*Scene files


## References

The settings logos were based on the following initial designs:
..* Author: freepik @ www.flaticon.com
..* Author: free-icon @ www.flaticon.com

## TODO

Features needed still: 

1. Settings to chose to do unitary or non unitary weights

Known Bugs:

1. Return to main scene(selectScene), after directly switching from settings scene to help scene(Shows context dependent help for settings),

causes main scene to become unresponsive.

#####Likely Reason: Reference to main scene might be lost causing event listeners to not work properly. Pass reference to main selection scene. 

