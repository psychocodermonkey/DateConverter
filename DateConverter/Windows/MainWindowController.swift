/*===============================================================================
|     Programmer: Andrew Dixon
|        Purpose: To convert dates to and from most date formats as a stand
|                   alone object. This is the GUI Implementation.
|           File: MainWindowController.swift
| Required Files: MainWindowController.xib
|   Initial Date: 2015.06.27
|    Last Update: 2016.01.16
|     2015.07.24: ADIXON - Moved files to new project structure
+-------------------------------------------------------------------------------
| Caveats: Will match Microsoft Excel. Since 02/29/1900 isn't valid, everything
|           after that date will be one day off if you actually did the math.
|           This will also include 01/01/1900 as day 1.
*==============================================================================*/

import Cocoa

class MainWindowController: NSWindowController {
  
  // MARK: Outlets for window components
  @IBOutlet weak var selInputFormat: NSComboBox!
  @IBOutlet weak var txtInputValue: NSTextField!
  @IBOutlet weak var selOutputFormat: NSComboBox!
  @IBOutlet weak var lblOutput: NSTextField!
  @IBOutlet weak var swtSeperatorsSwitch: NSSegmentedControl!
  @IBOutlet weak var btnConvert: NSButton!
  @IBOutlet weak var selSeperator: NSComboBox!
  
  // The window NIB name
  override var windowNibName: String {
    return "MainWindowController"
  }
  
  // Initilizer for superclass
  override func windowDidLoad() {
    super.windowDidLoad()
    // TODO: Make the starting cursor position be the first selection box instead of the text box
    
    // Make sure the seperator switch is off on load
    swtSeperatorsSwitch.selectedSegment = 0
    
    // Set the default seperator to use
    selSeperator.selectItemAtIndex(0)
    
    // Make sure that the window stays on top of other windows
    window?.level = Int(CGWindowLevelForKey(CGWindowLevelKey.MaximumWindowLevelKey))
  }
  
  // MARK: Input Selection box action
  @IBAction func selInputOnUpdate(sender: NSComboBox) {
    // Get a date object to be able to use
    let dteModule = dteConverter()
    
    // Clear out the string that's sitting in the input text box
    txtInputValue.stringValue = ""
    
    // Put the format from the date object as the placeholder text
    txtInputValue.placeholderString = dteModule.returnFormatMaskFor(sender.stringValue)
    
    // Make the placeholder all uppercase
    txtInputValue.placeholderString = txtInputValue.placeholderString?.uppercaseString
  }
  
  // MARK: Output selection box action
  @IBAction func selOutputOnUpdate(sender: NSComboBox) {
    // Get a date object to be able to use
    let dteModule = dteConverter()
    
    // Set the seperator from the combo box
    dteModule.setDateSeperator(selSeperator.stringValue)
    
    // Clear out the string that's sitting
    lblOutput.stringValue = ""
    
    // Put the format from the date object as the placeholder text
    // If the seperators are on, get the format string with seperators
    if swtSeperatorsSwitch.selectedSegment == 1 {
      lblOutput.placeholderString = dteModule.returnFormatMaskFor(sender.stringValue, withFormatting: true)
      
    // If the seperators are off, get the format string without the seperators
    }else {
      lblOutput.placeholderString = dteModule.returnFormatMaskFor(sender.stringValue)
    }
    
    // Mke the placeholder all uppercase
    lblOutput.placeholderString = lblOutput.placeholderString?.uppercaseString
  }
  
  // MARK: Convert button on click action
  @IBAction func convertDate(sender: NSButton) {
    // If there's nothing in the input box, call the ouput combo box piece to format the seperators
    if txtInputValue.stringValue == "" {
      
      // Kick off the code for updating the seperator
      self.selOutputOnUpdate(selOutputFormat)
      
      // If we did this we don't want to do anything else
      return
    }
    
    // Get a date object to be able to use
    let dteModule = dteConverter()
    
    // Set the seperator from the combo box
    dteModule.setDateSeperator(selSeperator.stringValue)    

    // If setting the date objects starting date and format is successful, do the output items
    if dteModule.setDate(txtInputValue.stringValue as String, andFormat: selInputFormat.stringValue as String) {
      
      // if the output format drop down is empty
      if selOutputFormat.stringValue.isEmpty {
        
        // Throw an error in the output label that there is no output selected
        lblOutput.stringValue = "Select output"
        
      // If the output is selected do the conversion in the date object
      } else {
        
        // Output the string representation of the numeric output of the date object
        // String for padding leading zeros
        var stringDate: String = ""
        
        // Set the default output format from the selection box
        dteModule.outputFormat = selOutputFormat.stringValue
        
        // If the switch is off, then the seperators are off too
        if swtSeperatorsSwitch.selectedSegment == 0 {
          
          // Perform the date conversion in the object
          let dateValue = dteModule.returnDateForFormat(selOutputFormat.stringValue)
          
          // Pad the leading zeros for the date formats that have specified lengths
          if dteModule.returnFormatMaskLengthFor(selOutputFormat.stringValue) != 0 {
            
            // Pad leading zeros for the output format
            stringDate = NSString(format: dteModule.returnFormatSpecifierFor(), dateValue) as String
            
            // TODO: Handle added functionality of showing if a year is a leap year or not. Add indicator to window as well.
            // TODO: Make this show the Day of the week spelled out. Maybe done with NSDATE, need to research.
            
          // Otherwise something else happend in the object
          } else {
            // The format string doesn't have a length because it's HUN or invalid so just make it a string
            stringDate = String(dateValue)
          }
          
        // If the switch is on then the seperators are on
        } else if swtSeperatorsSwitch.selectedSegment == 1 {
          
          // Output the date from the object as a string with seperators
          stringDate = dteModule.returnStringDateForFormat(selOutputFormat.stringValue)
        }
        
        // Output the string after it has been manipulated
        lblOutput.stringValue = stringDate
      }
      
    // If there was an error in setting the date and format on the object
    } else {
      
      // Update the output label with error concerning invalid input
      // TODO: Maybe make this a little more specific based on what is actually wrong
      lblOutput.stringValue = "Invalid input"
    }
  }
  
  // MARK: Seperator Switch action
  @IBAction func seperatorSwitchFlipped(sender: NSSegmentedControl) {
    // Just call the convert acation again if the switch changes
    self.convertDate(btnConvert)
  }
  
  // MARK: Update Seperator combo box action
  @IBAction func updateSeperator(sender: NSComboBox) {
    // If the seperator combo box changes be sure to re-update the output format
    self.convertDate(btnConvert)
  }
  
}