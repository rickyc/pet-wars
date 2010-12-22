//
//  DateTimeWeather.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/22/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "DateTimeWeather.h"

@implementation DateTimeWeather
@synthesize currentLocation, locationManager, zipCode;

BOOL success;

- (BOOL)coreLocationLoaded {
	return success;
}

- (void)initCoreLocation {
	self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
}

- (void)refreshCoreLocation {
	[locationManager startUpdatingLocation];	
}

- (NSString*)getTimeForSQL {
	NSDictionary *time = [self getTime];
	NSString *year = [time objectForKey:@"year"];
	NSString *month = [time objectForKey:@"month"];
	NSString *day = [time objectForKey:@"day"];
	NSString *hour = [time objectForKey:@"hour"];
	NSString *minute = [time objectForKey:@"minute"];
	NSString *second = [time objectForKey:@"second"];
	
	return [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hour,minute,second];
}

- (NSDictionary*)parseStringToKeyValue:(NSString*)parseString {
	// starts generating the dictionary
	NSMutableDictionary *dictionary = [[NSMutableDictionary new] autorelease];
	NSMutableString *key = [[NSMutableString new] autorelease];
	NSMutableString *value = [[NSMutableString new] autorelease];
	BOOL currentlyKey = YES;
	BOOL openQuote = NO;
	
	// goes through each character to parse out data
	for(int i=0;i<parseString.length;i++) {
		char c = [parseString characterAtIndex:i];
		
		// if there is an apostrophe that means it is a start/ end of a value
		if(c == '"') {
			// hits first instance of ", meaning start value recording
			if(!openQuote) {
				[dictionary setObject:value forKey:key];
				currentlyKey = NO;
				openQuote = YES;
				continue;
			} else {
				//[[dictionary objectForKey:key] release];
				[value setString:[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
				[dictionary setObject:[value substringFromIndex:1] forKey:key];
				key = [[NSMutableString new] autorelease];
				value = [[NSMutableString new] autorelease];
				currentlyKey = YES;
				openQuote = NO;
				continue;
			}
		}
		
		if(currentlyKey && c != ' ' && c != '=')
			[key appendString:[NSString stringWithFormat:@"%c",c]];
		else
			[value appendString:[NSString stringWithFormat:@"%c",c]];
	}
	return dictionary;
}

- (NSString*)getStringFromRange:(NSRange)r1 toRange:(NSRange)r2 withString:(NSString*)string {	
	NSRange nRange;
	nRange.location = r1.location + r1.length;
	nRange.length = r2.location - r1.location - r2.length + 1;
	return [string substringWithRange:nRange];
}

- (NSDictionary*)getWeather {
	if(self.zipCode == nil)	return nil;
	
	// weather api
	NSString *weatherAPI = [NSString stringWithContentsOfURL:[NSURL URLWithString:
								[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?p=%@",self.zipCode]]];
	
	// Starting Low Level Parser
	// Example: <yweather:condition  text="Fair"  code="34"  temp="63"  date="Wed, 22 Apr 2009 6:56 am PDT" />
	// grabs the location of the string 
	NSRange weatherConditions = [weatherAPI rangeOfString:@"<yweather:condition"];
	NSRange description = [weatherAPI rangeOfString:@"<description><![CDATA["];
	NSString *attributesString = [self getStringFromRange:weatherConditions toRange:description withString:weatherAPI];
	
	NSDictionary *weatherDictionary = [self parseStringToKeyValue:attributesString];
	
	// make this into a function plz
	NSRange astronomy = [weatherAPI rangeOfString:@"<yweather:astronomy"];
	NSRange image = [weatherAPI rangeOfString:@"<image>"];
	NSString *astroString = [self getStringFromRange:astronomy toRange:image withString:weatherAPI];
	
	NSDictionary *astroDictionary = [self parseStringToKeyValue:astroString];
	
	return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:weatherDictionary,astroDictionary,nil]
									   forKeys:[NSArray arrayWithObjects:@"weather",@"astronomy",nil]];
}

// Takes in a date with the format HH:MM am or H:MM pm
- (int)dateToSeconds:(NSString*)date {
	NSLog(@"hello world %@", date);
	NSRange colon = [date rangeOfString:@":"];
	NSRange space = [date rangeOfString:@" "];
	NSRange minuteRange;
	minuteRange.location = colon.location + colon.length;
	minuteRange.length = 2;
	int hour = [[date substringToIndex:colon.location] intValue];
	int minutes = [[date substringWithRange:minuteRange] intValue];
	NSString *ampm = [date substringFromIndex:space.location+space.length];
	
	if([ampm isEqualToString:@"pm"] && hour != 12) hour += 12;
	else if([ampm isEqualToString:@"am"] && hour == 12) hour = 0;
	
//	[ampm release];
	
//	NSLog(@"hour: %i, min: %i, ampm: %@",hour,minutes,ampm);
	return hour*60*60 + minutes*60;
}

- (NSDictionary*)makeDictionaryFromDate:(NSDate*)date {
	NSMutableDictionary *dictionary = [[NSMutableDictionary new] autorelease];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateFormat:@"yyyy"];
	[dictionary setObject:[NSNumber numberWithInt:[[dateFormatter stringFromDate:date] intValue]] forKey:@"year"];
	
	[dateFormatter setDateFormat:@"MM"];
	[dictionary setObject:[NSNumber numberWithInt:[[dateFormatter stringFromDate:date] intValue]] forKey:@"month"];
	
	[dateFormatter setDateFormat:@"dd"];
	[dictionary setObject:[NSNumber numberWithInt:[[dateFormatter stringFromDate:date] intValue]] forKey:@"day"];
	
	[dateFormatter setDateFormat:@"HH"];
	[dictionary setObject:[NSNumber numberWithInt:[[dateFormatter stringFromDate:date] intValue]] forKey:@"hour"];
	
	[dateFormatter setDateFormat:@"mm"];
	[dictionary setObject:[NSNumber numberWithInt:[[dateFormatter stringFromDate:date] intValue]] forKey:@"minute"];
	
	[dateFormatter setDateFormat:@"ss"];
	[dictionary setObject:[NSNumber numberWithInt:[[dateFormatter stringFromDate:date] intValue]] forKey:@"second"];
	
	[dateFormatter release];
	return dictionary;	
}

- (NSDictionary*)getTime {
	// if corelocation or internet is disabled, use system time
	if(self.zipCode == nil)	{
		return [self makeDictionaryFromDate:[NSDate date]];	
	}
	
	// otherwise grab time from a time api for accuracy
	// time api, sunset can also be retrieved from this API, but yahoo weather does it as well
	NSString *timeAPI = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.earthtools.org/timezone/%f/%f",
									currentLocation.coordinate.latitude,currentLocation.coordinate.longitude]]];
	
	NSRange startISOTime = [timeAPI rangeOfString:@"<isotime>"];
	NSRange endISOTime = [timeAPI rangeOfString:@"</isotime>"];
//	NSLog(@"timeApl: %@",[self getStringFromRange:startISOTime toRange:endISOTime withString:timeAPI]);
	NSDate *date = [[[NSDate alloc] initWithString:[self getStringFromRange:startISOTime toRange:endISOTime withString:timeAPI]] autorelease];
//	NSLog(@"datte: %@",date);
	return [self makeDictionaryFromDate:date];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	NSLog(@"core location is going!");
	self.currentLocation = newLocation;
//	MKReverseGeocoder *reverse = [[MKReverseGeocoder alloc] initWithCoordinate:currentLocation];

	// google maps - reverse geocode api
	NSString *reverseGeoCode = [NSString stringWithContentsOfURL:[NSURL URLWithString: [NSString stringWithFormat:
								@"http://maps.google.com/maps/geo?output=xml&oe=utf-8&ll=%f,%f", currentLocation.coordinate.latitude,
								currentLocation.coordinate.longitude]]];
	
	NSString *keyStr = [NSString stringWithString:@"<PostalCodeNumber>"];
	NSRange indexOfPostalCode = [reverseGeoCode rangeOfString:keyStr];

	NSRange range = {indexOfPostalCode.location+keyStr.length, 5};	
	self.zipCode = [reverseGeoCode substringWithRange:range];
	
	NSLog(@"i live here -> %@",zipCode);
//	NSLog(@"dictionary: %@",[self getWeather]);
//	NSLog(@"hello");
//	NSLog(@"time: %@",[self getTime]);
	success = YES;
	[locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error gettingg location from Core Location" message:errorType delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
	[alert show];
	[alert release];
	success = NO;
}

-(void)dealloc {
	[super dealloc];
	[currentLocation release];
	[locationManager release];
	[zipCode release];	
}

@end
