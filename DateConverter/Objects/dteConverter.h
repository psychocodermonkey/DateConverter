/*===============================================================================
 |     Programmer: Andrew Dixon
 |        Purpose: To convert dates to and from most date formats as a stand
 |                   alone object. To be used in command line and GUI 
 |                   applications
 |           File: dteConverter.h
 | Required Files: dteConverter.m
 |   Initial Date: 2014.12.01
 |    Last Update: 2016.01.16
 |        Version: 1.0.0
 +-------------------------------------------------------------------------------
 | Caveats: Will match Microsoft Excel. Since 02/29/1900 isn't valid, everything
 |           after that date will be one day off if you actually did the math.
 |           This will also include 01/01/1900 as day 1.
 *==============================================================================*/

#import <Foundation/Foundation.h>

@interface dteConverter : NSObject {
}

// Sets the "default" output format
@property (nonatomic) NSString *outputFormat;

// Sets the date and input format string for the object returns boolean of success
-(bool)setDate:(NSString *)dte andFormat:(NSString *)fmt;

// Returns the date that was previously set in the given format (will override
//   setOutputFormat value that was set)
-(int)returnDateForFormat:(NSString *)fmt;

// Returns the date that was previously set in the given format (will override
//   setOutputFormat value that was set)
-(NSString *)returnStringDateForFormat:(NSString *)fmt;

// Requires that you've requested the numeric output or set the outputformat via
//   an above method
-(NSString *)toString;

// Return the formatMask for the provided date format without any seperators
-(NSString *)returnFormatMaskFor:(NSString *)fmt;

// Return the formatMask for the provided date format with or without any seperators
-(NSString *)returnFormatMaskFor:(NSString *)fmt withFormatting:(bool)yes;

// Return the formatMask length for the provided date format
-(int)returnFormatMaskLengthFor:(NSString *)fmt;

// Return format specifier for the passed format
-(NSString *)returnFormatSpecifierFor:(NSString *)fmt;

// Return format specifier for the set return format
-(NSString *)returnFormatSpecifierFor;

// Set the seperator to use for the date with seperators
-(bool)setDateSeperator:(NSString *)sprtr;

// Return if the year that is set for the object is a leap year
-(bool)isLeapYear;

// Return if the year that is passed is a leap year or not
-(bool)isLeapYear:(NSDate *)dte;

@end
