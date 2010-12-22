//
//  DeviceData.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/17/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceData : NSObject {
	NSString *uuid;
	NSString *model;
	NSString *name;
	NSString *appName;
	NSString *deviceToken;
}

@property(nonatomic, retain) NSString *uuid;
@property(nonatomic, retain) NSString *model;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *appName;
@property(nonatomic, retain) NSString *deviceToken;

@end
