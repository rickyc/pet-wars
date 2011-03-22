//
//  TitleScreenViewController.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/18/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "TitleScreenViewController.h"
#import "iDrewStuffAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface UIApplication(PrivateMethods)
	- (void)terminateWithSuccess;
@end

@implementation TitleScreenViewController
@synthesize gameViewController, instructionsViewController, timer, newGameButton, exitGameButton, instructionsButton, infoButton, 
settingsButton, dateTimeWeather, manto, infoViewController, settingsViewController, keyboardViewController, newPetData, receivedData,
restartGameButton;

// FIX: maybe make this button more generic for launchInstructions as well
BOOL gameStarted;

- (IBAction)viewSettings:(id)sender {
	if(settingsViewController == nil)
		settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:[NSBundle mainBundle]];
	
	iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
	RootViewController *rootViewController = [appDelegate viewController];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:rootViewController.view cache:YES];
	[rootViewController.view addSubview:settingsViewController.view];
	[self.view removeFromSuperview];
	
	[UIView commitAnimations];	
}

- (IBAction)getInfo:(id)sender {
	if(infoViewController == nil)
		infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoView" bundle:[NSBundle mainBundle]];
	
	iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
	RootViewController *rootViewController = [appDelegate viewController];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:rootViewController.view cache:YES];
	[rootViewController.view addSubview:infoViewController.view];
	[self.view removeFromSuperview];
	
	[UIView commitAnimations];
}

// If there is no pet created, then create a new game, otherwise load the previous game
- (IBAction)startGame:(id)sender {
	[HelperMethods playSound:@"click"];
	// create a new pet if there is none in the database
	if(self.manto == nil) {
		keyboardViewController = [[KeyboardViewController alloc] initWithNibName:@"Keyboard" bundle:[NSBundle mainBundle]];
		[self.view addSubview:keyboardViewController.view];
	} else if(!gameStarted) {
		if(instructionsViewController != nil)
			[instructionsViewController release];
		
		if(infoViewController != nil)
			[infoViewController release];
		
		if(keyboardViewController != nil)
			[keyboardViewController release];
		
		gameStarted = YES;
		self.gameViewController = [[GameViewController alloc] initWithNibName:@"GameView" bundle:[NSBundle mainBundle]];
		self.gameViewController.dateTimeWeather = self.dateTimeWeather;
		self.gameViewController.petRock = manto;
		
		// is this necessary?
		iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
		RootViewController *rootViewController = [appDelegate viewController];
		rootViewController.gameViewController = self.gameViewController;
		
		self.gameViewController.view.alpha = 0.0;
	//	[self.view addSubview:gameViewController.view];	
		
		timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fadeScreen) userInfo:nil repeats:NO];
	}
}

- (IBAction)launchInstructions:(id)sender {
//	[[Beacon shared] startSubBeaconWithName:@"Instructions" timeSession:NO];
	[HelperMethods playSound:@"click"];	
	
	instructionsViewController = [[InstructionsViewController alloc] initWithNibName:@"InstructionsView" bundle:[NSBundle mainBundle]];
	
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.3];
	//[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromTop];
	[animation setRemovedOnCompletion:NO];
	[[instructionsViewController.view layer] addAnimation:animation forKey:@""];
	[self.view addSubview:instructionsViewController.view];
//	[self.view removeFromSuperview];
//	[rootViewController presentModalViewController:instructionsViewController animated:YES];
}


- (IBAction)exitGame:(id)sender {
	[HelperMethods playSound:@"click"];
	[self performSelector:@selector(exitApplication) withObject:nil afterDelay:0];
}

-(void) exitApplication {
	// exit(0);
	//[[UIApplication sharedApplication] terminate];	
	[[UIApplication sharedApplication] terminateWithSuccess];
}

-(void) terminateWithSuccess {
	NSLog(@"Exit");
}

- (void)onTimer{
	NSLog(@"Loading");
}

- (void)fadeScreen {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0];        
	[UIView setAnimationDelegate:self];       
	[UIView setAnimationDidStopSelector:@selector(finishedFading)];  
	self.view.alpha = 1.0;       
	[UIView commitAnimations]; 
}

- (void) finishedFading {
	[UIView beginAnimations:nil context:nil];	// begins animation block
	[UIView setAnimationDuration:0.50];			// sets animation duration
	self.view.alpha = 1.0;						// fades the view to 1.0 alpha over 0.75 seconds
	self.gameViewController.view.alpha = 1.0;
	[UIView commitAnimations];					// commits the animation block.  This Block is done.
	//[self.view removeFromSuperview];
	
	// grabs the RootViewController from the App Delegate
	iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
	RootViewController *rootViewController = [appDelegate viewController];
	//rootViewController.gameViewController = self.gameViewController;		// INITS GameViewController
	
	[rootViewController.view addSubview:gameViewController.view];
	[self.view removeFromSuperview];
	[self release];			// I DO NOT THINK THIS WORKS!
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	gameStarted = NO;
	
	// creates a new DTW object, if there is no network connection, do not initialize
	// core location because it makes use of date,time,weather APIs
	dateTimeWeather = [DateTimeWeather new];
	if([HelperMethods isNetworkAvailable])
		[dateTimeWeather initCoreLocation];
	
	// SQL
	[self loadPetFromDatabase];
	
	if(self.manto != nil) {
		 // uncomment for release
		[newGameButton setImage:[UIImage imageNamed:@"joinPetBtn.png"] forState:UIControlStateNormal];
		[newGameButton setImage:[UIImage imageNamed:@"joinPetBtn_hl.png"] forState:UIControlStateHighlighted]; 
		newGameButton.autoresizesSubviews = YES;
		NSLog(@"a pet has already been created");
	}

	// how should i set up user settings?
//	[self loadDefaultSettings];
}

// RESTART GAME (ADD PROMPT?)
- (IBAction)adoptNewPet:(id)sender {
	self.manto = nil;
	[newGameButton setImage:[UIImage imageNamed:@"adoptPetBtn.png"] forState:UIControlStateNormal];
	[newGameButton setImage:[UIImage imageNamed:@"adoptPetBtn_hl.png"] forState:UIControlStateHighlighted]; 
	newGameButton.autoresizesSubviews = YES;
	NSLog(@"creating a new pet");
}

- (void)loadInventory:(int)petID {
	FMDatabase* db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	
	FMResultSet *rs = [db executeQuery:@"SELECT store_items.*, inventory_items.quantity as `mquantity`, inventory_items.id as `mid` FROM inventory_items " \
					   "LEFT JOIN store_items ON inventory_items.item_id = store_items.id WHERE pet_id = ? AND consumable = ?", [NSNumber numberWithInt:petID], @"YES"];
	while ([rs next]) {
		NSString *key = [NSString stringWithFormat:@"%i",[rs intForColumn:@"id"]];
		NSString *category = [NSString stringWithFormat:@"%i",[rs intForColumn:@"category_id"]];
		NSString *itemName = [rs stringForColumn:@"item_name"];
		NSString *description = [rs stringForColumn:@"description"];
		NSString *price = [NSString stringWithFormat:@"%i",[rs stringForColumn:@"price"]];
		NSString *quantity = [NSString stringWithFormat:@"%i",[rs stringForColumn:@"quantity"]];
		NSString *maxQuantity = [NSString stringWithFormat:@"%i",[rs stringForColumn:@"max_quantity"]];
		NSString *statIncrease = [rs stringForColumn:@"stats_increase"];
		NSString *type = [rs stringForColumn:@"type"];
		NSString *imageName = [rs stringForColumn:@"image_name"];
		NSString *consumable = [rs stringForColumn:@"consumable"];
		NSString *mQuantity = [NSString stringWithFormat:@"%i",[rs intForColumn:@"mquantity"]];
		NSString *mID = [NSString stringWithFormat:@"%i",[rs intForColumn:@"mid"]];
		
		NSDictionary *item = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:key,category,itemName,description,price,quantity,imageName,
								maxQuantity,statIncrease,type,consumable,mQuantity,mID,nil] forKeys:[NSArray arrayWithObjects:@"key",@"category",@"name",@"description",
								@"price",@"quantity",@"image",@"max_quantity",@"stat_increase",@"type",@"consumable",@"my_quantity",@"inventory_id",nil]];
	
		StoreItem *sItem = [[StoreItem alloc] initWithDictionary:item];
		[self.manto.tempConsumableInventory addObject:sItem];
		[sItem release];
	}
	[rs close];
	[db close];
}

// DEPRECATED METHOD
/*
- (void)loadDefaultSettings {
	// fun SQL stuff
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
	
	if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		const char *sql = "SELECT * FROM users LIMIT 1";
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			while (sqlite3_step(statement) == SQLITE_ROW) {
				int key = sqlite3_column_int(statement, 0);
				int ansalas = sqlite3_column_int(statement, 1);
				
				char *lastLogged = (char*)sqlite3_column_text(statement, 2);
				NSString *lastLoggedStr = [NSString stringWithUTF8String: lastLogged];
				
				char *music = (char*)sqlite3_column_text(statement, 3);
				NSString *musicStr = [NSString stringWithUTF8String: music];
				
				char *weather = (char*)sqlite3_column_text(statement, 4);
				NSString *weatherStr = [NSString stringWithUTF8String:weather];
				
				char *coreLocation = (char*)sqlite3_column_text(statement, 5);
				NSString *coreLocationStr = [NSString stringWithUTF8String:coreLocation];
				
				NSLog(@"key=>%i, ansalas=>%i, lastLogged=>%@, music=>%@, weather=>%@, coreLocation=>%@",key,ansalas,
					  lastLoggedStr,musicStr,weatherStr,coreLocationStr);
			}
		}else {
			NSLog(@"Failed to prepare DB - %s", sqlite3_errmsg(database)); 
			NSLog(@"failed error!!!");
		}
		sqlite3_finalize(statement);
	} else {
		sqlite3_close(database);
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}	
}
*/

- (void)loadPetFromDatabase {
	FMDatabase* db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM pets"];
	while ([rs next]) {
		int key = [rs intForColumn:@"id"];
		NSString *petName = [rs stringForColumn:@"name"];
		NSString *gender = [rs stringForColumn:@"gender"];
		
		int health = [rs intForColumn:@"health"];
		int hygiene = [rs intForColumn:@"hygiene"];
		int happiness = [rs intForColumn:@"happiness"];
		int hunger = [rs intForColumn:@"hunger"];
		int fitness = [rs intForColumn:@"fitness"];
		NSString *mood = [rs stringForColumn:@"mood"];
		NSString *favColorStr = [rs stringForColumn:@"favorite_color"];
		NSString *creationDate = [rs stringForColumn:@"creation_time"];	// test to see if this works
		int ansalas = [rs intForColumn:@"ansalas"];
		
		// there has to be a better way to do this... coredata perhaps?
		int level = [rs intForColumn:@"level"];
		int experience = [rs intForColumn:@"experience"];
		int hp = [rs intForColumn:@"health_points"];
		int maxHp = [rs intForColumn:@"max_health_points"];
		int ap = [rs intForColumn:@"ability_points"];
		int maxAp = [rs intForColumn:@"max_ability_points"];
		int str = [rs intForColumn:@"strength"];
		int def = [rs intForColumn:@"defense"];		
		int agi = [rs intForColumn:@"agility"];
		int itl = [rs intForColumn:@"intelligence"];
		int wis = [rs intForColumn:@"wisdom"];
		int dex = [rs intForColumn:@"dexterity"];
		int con = [rs intForColumn:@"constitution"];
		int res = [rs intForColumn:@"resilience"];		
		int luk = [rs intForColumn:@"luck"];
		NSString *currentColor = [rs stringForColumn:@"current_color"];
		NSString *lastLogged = [rs stringForColumn:@"last_logged"];
		
//		NSLog(@"name=>%@, gender=>%@, health=>%i, hygiene=>%i, happiness=>%i, hunger=>%i, fitness=>%i, mood=>%@, color=>%@, date=>%@, last_logged=>%@",
//			  petName, gender, health, hygiene, happiness, hunger, fitness, mood, favColorStr, creationDate, lastLogged);
		
		self.manto = [[Manto alloc] initWithKey:key andName:petName andGender:gender andHealth:health andHygiene:hygiene andHappiness:happiness andHunger:hunger 
									 andFitness:fitness andMood:mood andColor:favColorStr andDate:creationDate andAnsalas:ansalas andLevel:level andExperience:experience
										  andHP:hp andMaxHP:maxHp andAP:ap andMaxAP:maxAp andStrength:str andDefense:def andAgility:agi andIntelligence:itl andWisdom:wis andDexterity:dex 
								andConstitution:con andResilience:res andLuck:luk andCurrentColor:currentColor andLastLogged:lastLogged];
		manto.dtw = dateTimeWeather;
		// if a pet exists then load its inventory as well
		[self loadInventory:key];
	}
	[rs close];
	[db close];
}

-(void)createANewPet {
//	[[Beacon shared] startSubBeaconWithName:@"Created New Pet" timeSession:NO];
	//DATETIME('NOW')
	
	NSNumber *hp = [NSNumber numberWithInt:arc4random()%5+30];
	NSNumber *ap = [NSNumber numberWithInt:arc4random()%5+20];
	NSNumber *str = [NSNumber numberWithInt:arc4random()%5+10];
	NSNumber *def = [NSNumber numberWithInt:arc4random()%5+10];
	NSNumber *agi = [NSNumber numberWithInt:arc4random()%5+10];
	NSNumber *itl = [NSNumber numberWithInt:arc4random()%5+10];
	NSNumber *wis = [NSNumber numberWithInt:arc4random()%5+10];
	NSNumber *dex = [NSNumber numberWithInt:arc4random()%5+10];
	NSNumber *con = [NSNumber numberWithInt:arc4random()%5+10];
	NSNumber *res = [NSNumber numberWithInt:arc4random()%5+10];
	NSNumber *luk = [NSNumber numberWithInt:arc4random()%5+3];
	
	FMDatabase* db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	
	[db beginTransaction];
	// i made this so ugly, at least its cleaner than pure objective c version
	[db executeUpdate:@"INSERT INTO pets (name, gender, health, hygiene, happiness, hunger, fitness, mood, favorite_color, creation_time, ansalas, " \
	"health_points, max_health_points, ability_points, max_ability_points, strength, defense, agility, intelligence, wisdom, dexterity, constitution, " \
	"resilience, luck, level, experience, prefer_question, hygiene_question, current_color, last_logged) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
	[[newPetData objectForKey:@"name"] capitalizedString],[newPetData objectForKey:@"gender"],[NSNumber numberWithInt:3],[NSNumber numberWithInt:300],
	[NSNumber numberWithInt:300],[NSNumber numberWithInt:300],[NSNumber numberWithInt:300],@"Happy",[newPetData objectForKey:@"fav_color"],[dateTimeWeather getTimeForSQL],
	[NSNumber numberWithInt:50],hp,hp,ap,ap,str,def,agi,itl,wis,dex,con,res,luk,[NSNumber numberWithInt:1],[NSNumber numberWithInt:0],
	[newPetData objectForKey:@"prefer"],[newPetData objectForKey:@"hygiene"],@"r:0,g:0,b:0,a:1,t:0",[dateTimeWeather getTimeForSQL]];
	[db commit];
	
	NSLog(@"done---@@@#@# :D");
	
	// change adopt a pet to join a pet
	[newGameButton setImage:[UIImage imageNamed:@"joinPetBtn.png"] forState:UIControlStateNormal];
	[newGameButton setImage:[UIImage imageNamed:@"joinPetBtn_hl.png"] forState:UIControlStateHighlighted]; 
	newGameButton.autoresizesSubviews = YES;
	
	// check ONLINE
	if([HelperMethods isNetworkAvailable])
		[self checkOnlineDatabase];
	[self loadPetFromDatabase];
	[db close];
}

#pragma mark -
#pragma mark Connection Methods
// separate this into another class probably
- (void)checkOnlineDatabase {
	NSString* uuid = [[[UIDevice currentDevice] uniqueIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *name = [[[newPetData objectForKey:@"name"] capitalizedString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSString *post = [NSString stringWithFormat:@"uuid=%@&pet_name=%@&health=3&happiness=300&hunger=300&hygiene=300&fitness=300&ansalas=50",uuid,name];
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PETWARS_URL,@"petwars.php"]]];  
	[request setHTTPMethod:@"POST"];              
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];  
	
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];  
	if (conn)
		receivedData = [[NSMutableData data] retain];
	else   
		NSLog(@"error");

	[conn release];	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {  
    [receivedData setLength:0];  
}  

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {  
    [receivedData appendData:data];  
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[receivedData release];
}

#pragma mark -
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[newPetData release];
	[manto release];
	[keyboardViewController release];
	[settingsViewController release];
	[infoViewController release];
	[dateTimeWeather release];
	[timer release];
	[settingsButton release];
	[newGameButton release];
	[exitGameButton release];
	[infoButton release];
	[instructionsButton release];
	[gameViewController release];
    [super dealloc];
}

@end