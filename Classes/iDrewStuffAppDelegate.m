//
//  iDrewStuffAppDelegate.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/18/09.
//  Copyright Family 2009. All rights reserved.
//

#import "iDrewStuffAppDelegate.h"
#import "Beacon.h"

@interface iDrewStuffAppDelegate (Private)
	-(void) createEditableCopyOfDatabaseIfNeeded;
@end

@implementation iDrewStuffAppDelegate
@synthesize window, viewController, device;

#pragma mark -
#pragma mark Application lifecycle

//- (void)applicationDidFinishLaunching:(UIApplication *)application {    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// used for pinchmedia
	NSString *applicationCode = @"ab8b100314d4fee6512e6fd23c1f82d8";
    [Beacon initAndStartBeaconWithApplicationCode:applicationCode useCoreLocation:NO useOnlyWiFi:NO];
    
	// push notification	
	if (launchOptions) {
		NSLog(@"dict - %@",launchOptions);
		NSString *msg = [[[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"] objectForKey:@"alert"];
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
		//		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:@"%@",launchOptions] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
		[av show];
	}
	
//	[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeLeft];
	// sqlite database
	[self createEditableCopyOfDatabaseIfNeeded];
	
	// starts the game
	viewController = [[RootViewController alloc] init];
    [window addSubview:[viewController view]];
	application.statusBarHidden = YES;
	
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
	[window makeKeyAndVisible];
	return YES;
}

// this is the one that is normally entered
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"worked - deviceToken: %@", deviceToken);
	[self getDeviceData:[NSString stringWithFormat:@"%@",deviceToken]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {     
    NSLog(@"Error in registration. Error: %@", error);
	[self getDeviceData:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	if (userInfo) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Message" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert" ] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
		[av show];
	}
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[[Beacon shared] endBeacon];
	
	// remove badge count
	application.applicationIconBadgeNumber = 0;
	
	// saves items on stage by first clearing the database
	GameViewController *gvc = viewController.gameViewController;
	[gvc.petRock removeItemsPreviouslyOnStageFromDatabase];
	
	for(GObject *gobj in gvc.itemsOnStage) {
		if([gobj.name isEqualToString:@"Poop"])
			[gvc.petRock poopAddedToStageWithScaleFactor:gobj];
		else
			[gvc.petRock storeItemAddedToStage:gobj];
	}
	
	// saves pet's data
	[gvc.petRock updatePetStats];

	
	// not used - core data
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}

-(void)getDeviceData:(NSString*)deviceToken {
	device = [DeviceData new];
	
	NSString *uuid = [[[UIDevice currentDevice] uniqueIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *model = [[[UIDevice currentDevice] model] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *name = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *appName = [@"My Application" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	device.uuid = uuid;
	device.model = model;
	device.name = name;
	device.appName = appName;
	device.deviceToken = deviceToken;
	
	NSLog(@"uuid=>%@, model=>%@, name=>%@, appName=>%@",uuid,model,name,appName);
}

#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent:DATABASE_NAME]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark -
#pragma mark sqlite3
- (void)createEditableCopyOfDatabaseIfNeeded {
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	
	NSString *writableDBPath = [HelperMethods getDatabasePath];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if(success) {
		// ***** uncomment to delete the database...
//		[fileManager removeItemAtPath:writableDBPath error:&error];
		return;
	}
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success)
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[device release];
	[viewController release];
	[window release];
	[super dealloc];
}


@end