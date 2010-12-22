//
//  iDrewStuffAppDelegate.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/18/09.
//  Copyright Family 2009. All rights reserved.
//

#import "RootViewController.h"
#import <sqlite3.h>
#import "DeviceData.h"

@interface iDrewStuffAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	UIWindow *window;
	RootViewController *viewController;
	DeviceData *device;
	sqlite3 *database;
}

- (IBAction)saveAction:sender;
- (void)getDeviceData:(NSString*)deviceToken;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *viewController;
@property (nonatomic, retain) DeviceData *device;

@end

