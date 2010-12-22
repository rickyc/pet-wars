//
//  Manto.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/24/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GObject.h"
#import "StoreItem.h"
#import "UserInventory.h"
#import	"FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "DateTimeWeather.h"

@interface Manto : GObject {
	//int key;			// pet id currently unused
	NSString *petName;	// name of pet
	NSString *gender;	// gender of pet
	NSString *mood;		// pet's mood
	NSString *birthDate;
	int health;			// five hearts max, 0 hearts = dead

	// bars
	int hygiene;
	int happiness;
	int hunger;
	
	int fitness;
	
	NSString *favoriteColor;
	
	int ansalas;	// currency
	
	//
	BOOL currentlyAnimated;
	BOOL asleep;
	
	// inventory
	UserInventory *inventoryView;
	NSMutableArray *tempConsumableInventory;
	NSString *lastLogged;
	
	// stats for pet wars
	int level;
	int experience;
	int healthPoints;
	int maxHealthPoints;
	int abilityPoints;
	int maxAbilityPoints;
	int strength;
	int defense;
	int agility;
	int intelligence;
	int wisdom;
	int dexterity;
	int constitution;
	int resilience;
	int luck;
	
	int numNuggets;
	
	DateTimeWeather *dtw;
}

@property(nonatomic, retain) NSString *petName;
@property(nonatomic, retain) NSString *gender;
@property(nonatomic, retain) NSString *mood;
@property(nonatomic, retain) NSString *favoriteColor;
@property(nonatomic, retain) NSString* birthDate;

@property(nonatomic, retain) UserInventory *inventoryView;
@property(nonatomic, retain) NSMutableArray *tempConsumableInventory;
@property(nonatomic, retain) NSString *lastLogged;

//@property(nonatomic, assign) int key;
@property(nonatomic, assign) int health;
@property(nonatomic, assign) int hygiene;
@property(nonatomic, assign) int happiness;
@property(nonatomic, assign) int hunger;
@property(nonatomic, assign) int fitness;
@property(nonatomic, assign) int ansalas;
@property(nonatomic, assign) BOOL currentlyAnimated;
@property(nonatomic, assign) BOOL asleep;

@property(nonatomic, assign) int level;
@property(nonatomic, assign) int experience;
@property(nonatomic, assign) int healthPoints;
@property(nonatomic, assign) int maxHealthPoints;
@property(nonatomic, assign) int abilityPoints;
@property(nonatomic, assign) int maxAbilityPoints;
@property(nonatomic, assign) int strength;
@property(nonatomic, assign) int defense;
@property(nonatomic, assign) int agility;
@property(nonatomic, assign) int intelligence;
@property(nonatomic, assign) int wisdom;
@property(nonatomic, assign) int dexterity;
@property(nonatomic, assign) int constitution;
@property(nonatomic, assign) int resilience;
@property(nonatomic, assign) int luck;

@property(nonatomic, assign) int numNuggets;
@property(nonatomic, retain) DateTimeWeather *dtw;

-(id)initWithKey:(int)nKey andName:(NSString*)nName andGender:(NSString*)nGender andHealth:(int)nHealth andHygiene:(int)nHygiene 
	andHappiness:(int)nHappiness andHunger:(int)nHunger andFitness:(int)nFitness andMood:(NSString*)nMood andColor:(NSString*)color 
	andDate:(NSString*)nDate andAnsalas:(int)nAnsalas andLevel:(int)lvl andExperience:(int)exp andHP:(int)hp andMaxHP:(int)maxHP andAP:(int)ap 
	andMaxAP:(int)maxAP andStrength:(int)str andDefense:(int)def andAgility:(int)agi andIntelligence:(int)itl andWisdom:(int)wis andDexterity:(int)dex
	andConstitution:(int)con andResilience:(int)res andLuck:(int)luk andCurrentColor:(NSString*)nCurrentColor andLastLogged:(NSString*)nLastLogged;

- (void)changeHappiness:(int)nHappiness;
- (void)changeHunger:(int)nHunger;
- (void)changeHygiene:(int)nHygiene;
- (void)changeFitness:(int)nFitness;
- (void)calculateHealth;
- (void)useItem:(StoreItem*)item atIndex:(int)itemIndex;
- (void)useConsumable:(NSDictionary*)attr;
- (void)updatePetStats;
- (void)deleteItem:(int)itemID;
- (int)getLastInventoryID;
- (void)adjustRealTimeStats;
- (void)storeItemAddedToStage:(GObject*)item;
- (void)poopAddedToStageWithScaleFactor:(GObject*)item;
- (NSDictionary*)getDictionaryOfItemsPreviouslyOnStage;
- (void)removeItemsPreviouslyOnStageFromDatabase;
- (int)adjustRealTimePoopCycle;
- (NSString*)getAge;

@end