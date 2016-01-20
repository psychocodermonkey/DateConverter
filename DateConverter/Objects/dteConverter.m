/*===============================================================================
 |     Programmer: Andrew Dixon
 |        Purpose: To convert dates to and from most date formats as a stand
 |                   alone object. To be used in command line and GUI 
 |                   applications
 |           File: dteConverter.m
 | Required Files: dteConverter.h
 |   Initial Date: 2014.12.01
 |    Last Update: 2016.01.19
 |        Version: 1.0.0
 +-------------------------------------------------------------------------------
 | Caveats: Will match Microsoft Excel. Since 02/29/1900 isn't valid, everything
 |           after that date will be one day off if you actually did the math.
 |           This will also include 01/01/1900 as day 1.
 *==============================================================================*/


#import "dteConverter.h"

@interface dteConverter () {
  NSDate *_holdDate;
  NSString *_dateSeperator;
}

@property (nonatomic) NSString *dateValue;
@property (nonatomic) NSString *dateFormat;

@end

@implementation dteConverter

/*------------------------------------------------------------------------------*
 | Set date and format for the object
 |     Takes: Date as NSString and Format as NSString
 |   Returns: True if everything worked and false if there was some problem
 *------------------------------------------------------------------------------*/
-(bool)setDate:(NSString *)dte andFormat:(NSString *)fmt {
  // Variables
  bool isValid = false;
  
  // Set up the date formatter so that we can format whatever date we're passed
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  
  // Set dateValue using internal methods
  [self setDateValue:dte];
  
  // Set dateFormat using internal methods
  [self setDateFormat:fmt];
  
  // Make sure fmt is uppercase for this function
  fmt = [fmt uppercaseString];
  
  // Check to see if we're re-using this object, release the _holdDate if we are
  if (_holdDate) _holdDate = nil;
  self.outputFormat = nil;
  
  // Convert the date from...
  if ([self returnFormatMaskFor:fmt] != nil) {
    [dateFormatter setDateFormat:[self returnFormatMaskFor:fmt]];
    
    // Set the hold date based on the dateFormatter
    if (![dte isEqual:@""]) _holdDate = [dateFormatter dateFromString:dte];
    
  }else if ([fmt isEqual:@"HUN"]) {
    
    // Initilize hold Date to an actual NSDate object
    _holdDate = [[NSDate alloc] init];
    
    // Set the starting date to _holdDate
    [dateFormatter setDateFormat:[self returnFormatMaskFor:@"ISO"]];
    _holdDate = [dateFormatter dateFromString:@"19000101"];
    
    // Build a "days" date component object
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    // Set the number of days in the date component (adjust for being zero based and difference in Excel)
    if ([dte integerValue] >= 59) {
      // Adjust for the fact that it is zero based and 02/29/1900 are not valid dates
      [dateComponents setDay:[dte integerValue] - 2];
      
    }else {
      // Adjust for being zero based
      [dateComponents setDay:[dte integerValue] - 1];
    }
    
    // Add the number of days to _holdDate to get what the value that was passed is
    _holdDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:_holdDate options:0];

  }
  
  // If _holdDate is now set to something, it isValid
  if (_holdDate) isValid = true;
  
  return isValid;
  
}

/*------------------------------------------------------------------------------*
 | Return the date in the specified format
 |     Takes: Format as NSString
 |   Returns: Date as integer representation in the specified format
 |      NOTE: This will set the objects "default" return variable overriding
 |              anything that was stored before including (void)setOutputFormat.
 *------------------------------------------------------------------------------*/
-(int) returnDateForFormat:(NSString *)fmt {
  // Define the initial return value
  int rtnValue = 0;
  
  // Save the outputFormat that was last used
  [self setOutputFormat:fmt];
  
  // Make sure fmt is uppercase for this function
  fmt = [fmt uppercaseString];
  
  // Initilize the date string formatter so we can change how the date looks
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  
  // Make sure it's a valid date format and not HUN
  if ([self returnFormatMaskFor:fmt] != nil) {
    // Build the date formatter object with the correct input mask and get the date
    //   in that format
    [dateFormatter setDateFormat:[self returnFormatMaskFor:fmt]];
    NSString *rtnString = [dateFormatter stringFromDate:_holdDate];
    
    // Set the return value to be returned
    rtnValue = [rtnString intValue];
    
  // If it is HUN do the day difference math to get the date in days
  }else if ([fmt isEqual:@"HUN"]) {
    // Build a date and set it to the start date
    NSDate *startDate = [[NSDate alloc] init];
    [dateFormatter setDateFormat:[self returnFormatMaskFor:@"ISO"]];
    startDate = [dateFormatter dateFromString:@"19000101"];
    
    // TODO: Update to not use depreciated stuff
    // Build a calendar object  so we can find the number of days between the two dates
    NSCalendar *curCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // Figure out the number of days between the start date and the date the object is currently set to
    NSDateComponents *dateDays = [curCalendar components:NSCalendarUnitDay fromDate:startDate toDate:_holdDate options:0];

    // Return the number of days as an integer
    rtnValue = (int)[dateDays day];
    
    // Adjust for being zero based and difference in Excel
    if (rtnValue >= 59){
      // Adjust for the fact that it is zero based and 02/29/1900 are not valid dates
      rtnValue += 2;
      
    }else{
      // Adjust for being zero based
      rtnValue += 1;
    }
    
  }else {
    // If the requested format is invalid log it and clear out outputFormat so that toString doesn't bomb out
    NSLog(@"Date format %@ requested for output invalid", fmt);
    [self setOutputFormat:[[NSString alloc]init]];
  }

  // Return the integer value of the date in the requested format
  return rtnValue;
}

/*------------------------------------------------------------------------------*
 | Return the date in the specified format
 |     Takes: Format as NSString
 |   Returns: Date as NSString representation in the specified format
 |      NOTE: This will set the objects "default" return variable overriding
 |              anything that was stored before including (void)setOutputFormat.
 *------------------------------------------------------------------------------*/
-(NSString *) returnStringDateForFormat:(NSString *)fmt {
  // Define the initial return value
  int rtnValue = 0;
  
  NSString *returnString = [[NSString alloc] init];
  
  // Save the outputFormat that was last used
  [self setOutputFormat:fmt];
  
  // Make sure fmt is uppercase for this function
  fmt = [fmt uppercaseString];
  
  // Initilize the date string formatter so we can change how the date looks
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  
  // Make sure it's a valid date format and not HUN
  if ([self returnFormatMaskFor:fmt] != nil) {
    // Build the date formatter object with the correct input mask and get the date
    //   in that format
    [dateFormatter setDateFormat:[self returnFormatMaskFor:fmt withFormatting:true]];
    NSString *rtnString = [dateFormatter stringFromDate:_holdDate];
    
    // Set the return value to be returned
    returnString = rtnString;
    
    // If it is HUN do the day difference math to get the date in days
  }else if ([fmt isEqual:@"HUN"]) {
    // Build a date and set it to the start date
    NSDate *startDate = [[NSDate alloc] init];
    [dateFormatter setDateFormat:[self returnFormatMaskFor:@"ISO"]];
    startDate = [dateFormatter dateFromString:@"19000101"];
    
    // TODO: Update to not use depreciated stuff
    // Build a calendar object  so we can find the number of days between the two dates
    NSCalendar *curCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // Figure out the number of days between the start date and the date the object is currently set to
    NSDateComponents *dateDays = [curCalendar components:NSCalendarUnitDay fromDate:startDate toDate:_holdDate options:0];
    
    // Return the number of days as an integer
    rtnValue = (int)[dateDays day];
    
    // Adjust for being zero based and difference in Excel
    if (rtnValue >= 59){
      // Adjust for the fact that it is zero based and 02/29/1900 are not valid dates
      rtnValue += 2;
      
    }else{
      // Adjust for being zero based
      rtnValue += 1;
    }
    
    returnString = [NSString stringWithFormat:@"%i", rtnValue];
    
  }else {
    // If the requested format is invalid log it and clear out outputFormat so that toString doesn't bomb out
    NSLog(@"Date format %@ requested for output invalid", fmt);
    [self setOutputFormat:[[NSString alloc]init]];
  }
  
  // Return the integer value of the date in the requested format
  return returnString;
}

/*------------------------------------------------------------------------------*
 | Return the string representation of the date from the "default" format
 |     Takes: nothing
 |   Returns: Date as NSString representation in the "default" format
 |      NOTE: This requires the "default" format being set from either
 |              (int)returndDateForFormat or (void)setOutputFormat before it 
 |              will return anything
 *------------------------------------------------------------------------------*/
-(NSString *) toString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  
  // String to define what the format of our date is in
  NSString *rtnString = [[NSString alloc] init];
  NSString *outputFormat = [self outputFormat];
  
  // Make sure it's a valid date format and not HUN
  if ([self returnFormatMaskFor:outputFormat] != nil) {
    [dateFormatter setDateFormat:[self returnFormatMaskFor:outputFormat withFormatting:true]];
    rtnString = [dateFormatter stringFromDate:_holdDate];
  
  // If it is HUN do the day difference math to get the date in days
  }else if ([outputFormat isEqual:@"HUN"]) {
    // Build a date and set it to the start date
    NSDate *startDate = [[NSDate alloc] init];
    [dateFormatter setDateFormat:[self returnFormatMaskFor:@"ISO"]];
    startDate = [dateFormatter dateFromString:@"19000101"];
    
    // TODO: Update to not use depreciated stuff
    // Build a calendar object  so we can find the number of days between the two dates
    NSCalendar *curCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    // Figure out the number of days between the start date and the date the object is currently set to
    NSDateComponents *dateDays = [curCalendar components:NSCalendarUnitDay fromDate:startDate toDate:_holdDate options:0];

    // Build the return string from the number of days (adjust for zero based and difference in Excel)
    if ((int)[dateDays day] >= 59) {
      // Adjust for the fact that it is zero based and 02/29/1900 are not valid dates
      rtnString = [NSString stringWithFormat:@"%d", (int)[dateDays day] + 2];
      
    }else {
      // Adjust for being zero based
      rtnString = [NSString stringWithFormat:@"%d", (int)[dateDays day] + 1];
    }
    
  }
  
  // Return the date as a formatted string (Can be NIL)
  return rtnString;
}

/*------------------------------------------------------------------------------*
 | Return the formatMask string for the given date format
 |     Takes: Format as NSString
 |   Returns: Date format mask as NSString without formatting
 |      NOTE: Will return NIL for invalid formats. HUN is an invalid format for
 |             this purpose
 *------------------------------------------------------------------------------*/
-(NSString *)returnFormatMaskFor:(NSString *)fmt {
  // Just a shorter call for if you don't want formatting, so call the main one
  //  defaulting false for withFormatting
  return [self returnFormatMaskFor:fmt withFormatting:false];
}

/*------------------------------------------------------------------------------*
 | Return the formatMask string for the given date format
 |     Takes: Format as NSString and wether to return formatting as bool
 |   Returns: Date format mask as NSString with or without formatting
 |      NOTE: Will return NIL for invalid formats. HUN is an invalid format for
 |             this purpose
 *------------------------------------------------------------------------------*/
-(NSString *)returnFormatMaskFor:(NSString *)fmt withFormatting:(bool)yes {
  
  NSString *formatMask = [[NSString alloc] init];
  
  // Set a default seperator to use
  NSString *sprtr = @"/";
  
  // If the seperator is overriden the pull it in instead
  if (_dateSeperator) sprtr = _dateSeperator;
  
  // Make sure fmt is upper case
  fmt = [fmt uppercaseString];
  
  // Check for MDY
  if ([fmt isEqual: @"MDY"]) {
    if (yes) {
      // Set up the default format mask with our character to replace
      formatMask = @"MM?dd?yy";
      
      // Scan through and replace the ? with whatever seperator we decided on before
      formatMask = [formatMask stringByReplacingOccurrencesOfString:@"?" withString:sprtr];
    }else {
      formatMask = @"MMddyy";
    }
    
  // Check for YMD
  }else if ([fmt isEqual:@"YMD"]) {
    if (yes) {
      // Set up the default format mask with our character to replace
      formatMask = @"yy?MM?dd";
      
      // Scan through and replace the ? with whatever seperator we decided on before
      formatMask = [formatMask stringByReplacingOccurrencesOfString:@"?" withString:sprtr];
    }else {
      formatMask = @"yyMMdd";
    }
    
  // Check for USA
  }else if ([fmt isEqual:@"USA"]) {
    if (yes) {
      // Set up the default format mask with our character to replace
      formatMask = @"MM?dd?yyyy";
      
      // Scan through and replace the ? with whatever seperator we decided on before
      formatMask = [formatMask stringByReplacingOccurrencesOfString:@"?" withString:sprtr];
    }else {
      formatMask = @"MMddyyyy";
    }
    
  // Check for ISO
  }else if ([fmt isEqual:@"ISO"]) {
    if (yes) {
      // Set up the default format mask with our character to replace
      formatMask = @"yyyy?MM?dd";
      
      // Scan through and replace the ? with whatever seperator we decided on before
      formatMask = [formatMask stringByReplacingOccurrencesOfString:@"?" withString:sprtr];
    }else {
      formatMask = @"yyyyMMdd";
    }
    
  // Check for Julian
  }else if ([fmt isEqual: @"JUL"]) {
    if (yes) {
      // Set up the default format mask with our character to replace
      formatMask = @"yy?DDD";
      
      // Scan through and replace the ? with whatever seperator we decided on before
      formatMask = [formatMask stringByReplacingOccurrencesOfString:@"?" withString:sprtr];
    }else {
      formatMask = @"yyDDD";
    }
    
  // Check for Long Julian
  }else if ([fmt isEqual:@"LJUL"]) {
    if (yes) {
      // Set up the default format mask with our character to replace
      formatMask = @"yyyy?DDD";
      
      // Scan through and replace the ? with whatever seperator we decided on before
      formatMask = [formatMask stringByReplacingOccurrencesOfString:@"?" withString:sprtr];
    }else {
      formatMask = @"yyyyDDD";
    }

  // If it wasn't one of the above formats be sure to return NIL
  }else formatMask = nil;
  
  return formatMask;
}

/*------------------------------------------------------------------------------*
 | Return the formatMask length for the given date format
 |     Takes: Format as NSString
 |   Returns: Length of the format string
 |      NOTE: Will return zero for invalid formats. HUN is an invalid format for
 |             this purpose
 *------------------------------------------------------------------------------*/
-(int)returnFormatMaskLengthFor:(NSString *)fmt {
  // Initilize the return value
  int rtnValue = 0;
  
  // Make sure that the format string is uppercase
  fmt = [fmt uppercaseString];
  
  // Return the length of the format string for the given format
  if ([self returnFormatMaskFor:fmt] != nil) rtnValue = (int)[[self returnFormatMaskFor:fmt] length];
  
  // Return the length or zero depending on if a valid format string was passed
  return rtnValue;
}

/*------------------------------------------------------------------------------*
 | Return the format specifier for the given date format
 |     Takes: Nothing
 |   Returns: Format specifier as NSString
 |      NOTE: Will return nil for invalid formats. HUN is an invalid format for
 |             this purpose
 *------------------------------------------------------------------------------*/
-(NSString *)returnFormatSpecifierFor {
  
  // Return the format specifier for the built in output format
  return [self returnFormatSpecifierFor:[self outputFormat]];
}

/*------------------------------------------------------------------------------*
 | Return the format specifier for the given date format
 |     Takes: Format as NSString
 |   Returns: format specifier as NSString
 |      NOTE: Will return nil for invalid formats. HUN is an invalid format for
 |             this purpose
 *------------------------------------------------------------------------------*/
-(NSString *)returnFormatSpecifierFor:(NSString *)fmt {
  // Initilize the return value
  NSString *rtnValue = @"%0?D";
  
  // Make sure that the format string is uppercase
  fmt = [fmt uppercaseString];
  
  // Return the length of the format string for the given format
  if ([self returnFormatMaskFor:fmt] != nil) {
    
    // We need the length as a number that we can get the string representaiton of easily
    NSNumber *fmtLength = [[NSNumber alloc] initWithInt:[self returnFormatMaskLengthFor:fmt]];
    
    // Set the new return value to the modified string
    rtnValue = [rtnValue stringByReplacingOccurrencesOfString:@"?" withString:[fmtLength stringValue]];
    
  // If the format is invalid make the return value nil to pass it back
  } else rtnValue = nil;
  
  // Return the format specifier for the given format
  return rtnValue;
}

/*------------------------------------------------------------------------------*
 | Change what the seperator is for the formatted date string
 |     Takes: Seperator as NSString
 |   Returns: True if everything worked and false if there was some problem
 *------------------------------------------------------------------------------*/
-(bool)setDateSeperator:(NSString *)sprtr {
  // Set the default return value
  bool isValid = false;
  
  // Check to make sure that the seperator is a valid value before making any changes to what is already there
  if ([sprtr isEqualTo:@"/"] || [sprtr isEqualTo:@"-"] || [sprtr isEqualTo:@"."]) {
    
    // If the date seperator is already defined, cut it loose
    if (_dateSeperator) _dateSeperator = nil;
    
    // Set the date seperator with the new seperator value
    _dateSeperator = [[NSString alloc] initWithString:sprtr];
    
    // If we hit this space we changed the seperator
    isValid = true;
  }
  
  // Return success or failure
  return isValid;
}

/*------------------------------------------------------------------------------*
 | Return if the set date for the object is a leap year or not
 |     Takes: Nothing
 |   Returns: True if the set year is a leap year, false if it is not
 *------------------------------------------------------------------------------*/
-(bool)isLeapYear {
  
  bool isLeap = false;
  
  if (_holdDate) {
    // Get a date formatter object for us to extract the year portion of the date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Specify the year portion of the date field
    dateFormatter.dateFormat = @"yyyy";
    
    // Get the year from the hold date that is previously set
    NSInteger year = [[dateFormatter stringFromDate:_holdDate] integerValue];
    
    // This formula decides if a year is a leap year or not
    isLeap = ((year % 100 !=0) && (year % 4 == 0)) || year % 400 ==0;
  }
  
  return isLeap;
  
}

/*------------------------------------------------------------------------------*
 | Return if the passed date is a leap year or not
 |     Takes: Date as NSDATE
 |   Returns: True if the set year is a leap year, false if it is not
 *------------------------------------------------------------------------------*/
-(bool)isLeapYear:(NSDate *)dte {
  
  bool isLeap = false;
  
  if (dte) {
    // Get a date formatter object for us to extract the year portion of the date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Specify the year portion of the date field
    dateFormatter.dateFormat = @"yyyy";
    
    // Get the year from the hold date that is previously set
    NSInteger year = [[dateFormatter stringFromDate:dte] integerValue];
    
    // This formula decides if a year is a leap year or not
    isLeap = ((year % 100 !=0) && (year % 4 == 0)) || year % 400 ==0;
  }
  return isLeap;
  
}

@end
