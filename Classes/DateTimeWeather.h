//
//  DateTimeWeather.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/22/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DateTimeWeather : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation *currentLocation;
	NSString *zipCode;
}

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) CLLocation *currentLocation;
@property(nonatomic, retain) NSString *zipCode;

- (NSDictionary*)parseStringToKeyValue:(NSString*)parseString;
- (NSDictionary*)getWeather;
- (NSDictionary*)getTime;
- (NSString*)getStringFromRange:(NSRange)r1 toRange:(NSRange)r2 withString:(NSString*)string;
- (NSDictionary*)makeDictionaryFromDate:(NSDate*)date;
- (void)initCoreLocation;
- (void)refreshCoreLocation;
- (int)dateToSeconds:(NSString*)date;
- (BOOL)coreLocationLoaded;
- (NSString*)getTimeForSQL;

@end
