/*===============================================================================
|     Programmer: Andrew Dixon
|        Purpose: To convert dates to and from most date formats as a stand
|                   alone object. This is the GUI Implementation.
|           File: AppDelegate.swift
| Required Files: MainWindowController.swift, MainWindowController.xib
|   Initial Date: 2015.06.27
|    Last Update: 2015.07.24
|     2015.07.24: ADIXON - Moved files to new project structure
+-------------------------------------------------------------------------------
| Caveats: Will match Microsoft Excel. Since 02/29/1900 isn't valid, everything
|           after that date will be one day off if you actually did the math.
|           This will also include 01/01/1900 as day 1.
*==============================================================================*/

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var mainWindowController: MainWindowController?
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // Create a window controller
    let mainWindowController = MainWindowController()
    
    // Put the window of the window controller onthe screen
    mainWindowController.showWindow(self)
    
    // Set the property to point to the window controller
    self.mainWindowController = mainWindowController
  }
  
  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }


}

