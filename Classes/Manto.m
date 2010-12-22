//
//  Manto.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/24/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "Manto.h"
#import "StoreItem.h"
#import "iDrewStuffAppDelegate.h"

@implementation Manto
@synthesize petName, gender, favoriteColor, mood, health, hygiene, happiness, hunger, fitness, birthDate, ansalas, currentlyAnimated, 
inventoryView, tempConsumableInventory, level, experience, healthPoints, maxHealthPoints, abilityPoints, maxAbilityPoints, strength, defense, 
agility, intelligence, wisdom, dexterity, constitution, resilience, luck, numNuggets, lastLogged, dtw, asleep;

-(id)initWithKey:(int)nKey andName:(NSString*)nName andGender:(NSString*)nGender andHealth:(int)nHealth andHygiene:(int)nHygiene 
	andHappiness:(int)nHappiness andHunger:(int)nHunger andFitness:(int)nFitness andMood:(NSString*)nMood andColor:(NSString*)color 
	andDate:(NSString*)nDate andAnsalas:(int)nAnsalas andLevel:(int)lvl andExperience:(int)exp andHP:(int)hp andMaxHP:(int)maxHP andAP:(int)ap 
	andMaxAP:(int)maxAP andStrength:(int)str andDefense:(int)def andAgility:(int)agi andIntelligence:(int)itl andWisdom:(int)wis andDexterity:(int)dex
	andConstitution:(int)con andResilience:(int)res andLuck:(int)luk andCurrentColor:(NSString*)nCurrentColor andLastLogged:(NSString*)nLastLogged {
	[super init];
	
	self.key = nKey;
	
	self.petName = nName;
	self.gender = nGender;
	self.mood = nMood;
	self.favoriteColor = color;
	
	self.health = nHealth;
	self.happiness = nHappiness;
	self.hygiene = nHygiene;
	self.hunger = nHunger;
	self.fitness = nFitness;
	self.ansalas = nAnsalas;
	self.birthDate = nDate;
	
	self.level = lvl;
	self.experience = exp;
	self.healthPoints = hp;
	self.maxHealthPoints = maxHP;
	self.abilityPoints = ap;
	self.maxAbilityPoints = maxAP;
	self.strength = str;
	self.defense = def;
	self.agility = agi;
	self.intelligence = itl;
	self.wisdom = wis;
	self.dexterity = dex;
	self.constitution = con;
	self.resilience = res;
	self.luck = luk;
	
	self.currentColor = nCurrentColor;
	self.lastLogged = nLastLogged;
	
	self.currentlyAnimated = NO;
	self.asleep = NO;
	
	self.tempConsumableInventory = [NSMutableArray new];
	
	return self;
}

- (NSString*)getAge {
	NSDate *currentDate = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"%@ +0000",[dtw getTimeForSQL]]];
	NSDate *birthday = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"%@ +0000",birthDate]];
	NSTimeInterval seconds = [currentDate timeIntervalSinceDate:birthday];
	NSLog(@"%@ c=>%@, b=>%@, seconds: %f",[dtw getTimeForSQL],currentDate,birthday,seconds);
	[currentDate release];
	[birthday release];
	
	int minutes = seconds/60;	// 60 seconds in a minute
	if(minutes < 60) return [NSString stringWithFormat:@"%i minutes",minutes];
	
	int hours = minutes/60;	// 60 minutes in a hour
	if(hours < 24) return [NSString stringWithFormat:@"%i hours",hours];
	
	int days = hours/24;	// 24 hours in a day
	if(days < 30) return [NSString stringWithFormat:@"%i days",days];
	
	int months = days/30;	// 30 days in a month
	if(months >= 12) {
		int years = months%12;
		months = years/12;
		NSString *yearStr = years == 1 ? @"year" : @"years";
		NSString *monthStr = months == 1? @"month" : @"months";
		return [NSString stringWithFormat:@"%i %@ %i %@",years,yearStr,months,monthStr];
	} else {
		NSString *monthStr = months == 1? @"month" : @"months";
		return [NSString stringWithFormat:@"%i %@",months,monthStr];
	}
	
	return @"Classified";
}

- (void)changeHappiness:(int)nHappiness {
	self.happiness += nHappiness;
	self.happiness = self.happiness < 0 ? 1 : self.happiness;
	self.happiness = self.happiness > 500 ? 500 : self.happiness; 
	[self calculateHealth];
}

- (void)changeHunger:(int)nHunger {
	hunger += nHunger;
	hunger = hunger < 0 ? 1 : hunger;	
	hunger = hunger > 500 ? 500 : hunger;
	
	// if hunger level is less than 100, the pet is considered starving, DO NOT OVERWRITE SICK!
	if(hunger < 100) mood = @"Starving";
	
	[self calculateHealth];
}

- (void)changeHygiene:(int)nHygiene {
	self.hygiene += nHygiene;
	self.hygiene = self.hygiene < 0 ? 1 : self.hygiene;
	self.hygiene = self.hygiene > 500 ? 500 : self.hygiene; 
	[self calculateHealth];
}

- (void)changeFitness:(int)nFitness { 
	self.fitness += nFitness;
	self.fitness = self.fitness < 0 ? 1 : self.fitness;
	self.fitness = self.fitness > 500 ? 500 : self.fitness;
	[self calculateHealth];
}

- (void)calculateHealth {
	int totalValue = self.happiness + self.hunger + self.hygiene + self.fitness;
	self.health = (int)(totalValue/500) + 1;
}

- (void)storeItemAddedToStage:(GObject*)item {
	FMDatabase *db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	
	[db beginTransaction];
	[db executeUpdate:@"INSERT INTO stage_items (pet_id,item_id,x_coord,scale,type) VALUES(?,?,?,?,?)",[NSNumber numberWithInt:key],
	 [NSNumber numberWithInt:item.key],[NSNumber numberWithFloat:item.currentPosition.x],[NSNumber numberWithFloat:1],@"item"];
	if ([db hadError])
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	[db commit];
	[db close];
}

- (void)poopAddedToStageWithScaleFactor:(GObject*)item {
	FMDatabase *db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	
	[db beginTransaction];
	[db executeUpdate:@"INSERT INTO stage_items (pet_id,x_coord,scale,type) VALUES(?,?,?,?)",[NSNumber numberWithInt:key],
	 [NSNumber numberWithFloat:item.currentPosition.x],[NSNumber numberWithFloat:item.scale],@"poop"];
	if ([db hadError])
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	[db commit];
	[db close];
}

- (NSDictionary*)getDictionaryOfItemsPreviouslyOnStage {
	FMDatabase *db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	
	NSMutableArray *poopAry = [[NSMutableArray new] autorelease];
	
	FMResultSet *rs = [db executeQuery:@"SELECT scale, x_coord FROM stage_items WHERE pet_id = ? AND type = ?",[NSNumber numberWithInt:key],@"poop"];
	while([rs next]) {
		NSDictionary *poop = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithDouble:[rs doubleForColumn:@"x_coord"]],
								[NSNumber numberWithDouble:[rs doubleForColumn:@"scale"]],nil] forKeys:[NSArray arrayWithObjects:@"x_coord",@"scale",nil]];
		[poopAry addObject:poop];
	}
	[rs close];
	
	NSMutableArray *itemAry = [[NSMutableArray new] autorelease];
	rs = [db executeQuery:@"SELECT item_id, x_coord FROM stage_items WHERE pet_id = ? AND type = ?",[NSNumber numberWithInt:key],@"item"];
	while([rs next]) {
		NSDictionary *item = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:[rs intForColumn:@"item_id"]],
								[NSNumber numberWithDouble:[rs doubleForColumn:@"x_coord"]],nil] forKeys:[NSArray arrayWithObjects:@"item_id",@"x_coord",nil]];
		[itemAry addObject:item];
	}
	[rs close];
	
	[db close];
	return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:poopAry,itemAry,nil] forKeys:[NSArray arrayWithObjects:@"poop",@"items",nil]];
}

- (void)removeItemsPreviouslyOnStageFromDatabase {
	FMDatabase *db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	[db beginTransaction];
	[db executeUpdate:@"DELETE FROM stage_items WHERE pet_id = ?",[NSNumber numberWithInt:key]];
	[db commit];
	[db close];
}

// if it is a toy add to stage, otherwise do something else
- (void)useItem:(StoreItem*)item atIndex:(int)itemIndex {
	NSLog(@"Item Type=>%@, Item Stats=>%@",item.type, item.statIncrease);
	NSDictionary *statsDict = [self keyValueParser:item.statIncrease];
	NSLog(@"%@",statsDict);
	NSString *type = [item type];
	
	iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
	RootViewController *rootViewController = [appDelegate viewController];
	GameViewController *gameViewController = rootViewController.gameViewController;
	
	// FIX!!!! this will have to be fixed to account for quantity
	if([type isEqualToString:@"consumable"] || [type isEqualToString:@"paint"]) {
		if([type isEqualToString:@"consumable"])
			[self useConsumable:statsDict];
		else if([type isEqualToString:@"paint"]) {
			self.currentColor = item.statIncrease;
			[self changePaintSets:statsDict];			
		}
		[item.imageView removeFromSuperview];
		[inventoryView.consumableInventory removeObjectAtIndex:itemIndex];
		[gameViewController redraw];
		[self deleteItem:item.inventoryId];
	} else if([type isEqualToString:@"toy"]) {		
		item.showInInventory = NO;
		[gameViewController addGObjectToStageWithName:item.itemName andImage:item.imageName andScale:1 andInFront:YES andPosition:-1 andKey:item.key];
		[inventoryView drawInventory];
	}
}

- (void)useConsumable:(NSDictionary*)attr {
	// update quantity plz!!! FIXXXX!!!
	NSArray *keys = [attr allKeys];
	for(int i=0;i<keys.count;i++) {
		NSString *dKey = [keys objectAtIndex:i];
		int value = [[attr objectForKey:dKey] intValue];
		if([dKey isEqualToString:@"hap"])		[self changeHappiness:value];
		else if([dKey isEqualToString:@"hun"])	[self changeHunger:value];
		else if([dKey isEqualToString:@"hyg"])	[self changeHygiene:value];
		else if([dKey isEqualToString:@"fit"])	[self changeFitness:value];
	}
}

- (void)adjustRealTimeStats {
	NSDate *currentDate = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"%@ +0000",[dtw getTimeForSQL]]];
	NSDate *lastLoggedDate = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"%@ +0000",lastLogged]];
	NSTimeInterval seconds = [currentDate timeIntervalSinceDate:lastLoggedDate];
	int hoursPassed = seconds/3600;
	
	// new hunger level
	[self changeHunger:(-1*15*hoursPassed)];
	
	int happinessChange = (health < 2) ? 15 : 6;
	[self changeHappiness:(-1*happinessChange*hoursPassed)];
	[self changeHygiene:(-1*numNuggets*hoursPassed*10)+(hoursPassed*-5)];
	
	NSLog(@"ctime:%@ lastlogged:%@, seconds difference: %f",currentDate,lastLoggedDate,seconds);
	[currentDate release];
	[lastLoggedDate release];
}

- (int)adjustRealTimePoopCycle {
	NSDate *currentDate = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"%@ +0000",[dtw getTimeForSQL]]];
	NSDate *lastLoggedDate = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"%@ +0000",lastLogged]];
	NSTimeInterval seconds = [currentDate timeIntervalSinceDate:lastLoggedDate];
	int numPoop= seconds/3600; // every hour
	
	// 25% chance for the pet to poop every hour
	int poop = 0;
	for(int i=0;i<numPoop;i++) {
		int ran = arc4random()%4;
		if(ran == 1) 
			poop += 1;
	}
	
	[currentDate release];
	[lastLoggedDate release];
	
	return poop;
}

#pragma mark -
#pragma mark Database Methods
- (void)updatePetStats {
	FMDatabase* db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	
	// id = pet_id
	[db beginTransaction];	// unnecessary as there is only one statement, but safety precautions for multiple updates simutanously
	[db executeUpdate:@"UPDATE pets SET health = ?, hygiene = ?, happiness = ?, hunger = ?, fitness = ?, current_color = ?, ansalas = ?, last_logged = ? WHERE id = ?",
	[NSNumber numberWithInt:health],[NSNumber numberWithInt:hygiene],[NSNumber numberWithInt:happiness],[NSNumber numberWithInt:hunger],[NSNumber numberWithInt:fitness],
	 self.currentColor,[NSNumber numberWithInt:ansalas],[dtw getTimeForSQL],[NSNumber numberWithInt:key]];
	if ([db hadError])
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	[db commit];
	[db close];
	
	NSLog(@"finished updating");
}

// delete an item from the inventory based on id, FIX technically I should lower the count by one
- (void)deleteItem:(int)itemID {
	FMDatabase* db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	
	[db beginTransaction];	// unnecessary as there is only one statement, but safety precautions for multiple updates simutanously
	[db executeUpdate:@"DELETE FROM inventory_items where id = ?",[NSNumber numberWithInt:itemID]];
	[db commit];
	if ([db hadError])
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	
	NSLog(@"removed item with id => %i",itemID);
	
	[db close];
}

- (int)getLastInventoryID {
	FMDatabase* db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	
	int keyID = -1;
	// grabs items from categories, SELECT MAX does not work with FMDB
	FMResultSet *rs = [db executeQuery:@"SELECT max(id) AS id FROM inventory_items WHERE pet_id = ?",[NSNumber numberWithInt:key]];
	while([rs next]) {
		keyID = [rs intForColumn:@"id"];
	}
	[rs close];	
	[db close];
	
	return keyID;
}

- (void) dealloc {
	[dtw release];
	[birthDate release];
	[tempConsumableInventory release];
	[inventoryView release];
	[petName release];
	[gender release];
	[mood release];
	[favoriteColor release];
	[super dealloc];
}

@end