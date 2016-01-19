/*===============================================================================
|     Programmer: Andrew Dixon
|        Purpose: To convert dates to and from most date formats as a stand
|                   alone object. To be used in command line and GUI
|                   applications
|           File: DateConverter-Bridging-Header.h
| Required Files: dteCOnverter.h
|   Initial Date: 2015.06.27
|    Last Update: 2015.07.24
|     2015.07.24: ADIXON - Moved files to new project structure
+-------------------------------------------------------------------------------
| Caveats: Will match Microsoft Excel. Since 02/29/1900 isn't valid, everything
|           after that date will be one day off if you actually did the math.
|           This will also include 01/01/1900 as day 1.
*==============================================================================*/

//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "dteConverter.h"