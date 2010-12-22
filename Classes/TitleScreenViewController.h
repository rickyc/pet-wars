//
//  TitleScreenViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/18/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manto.h"
#import "DateTimeWeather.h"
#import "GameViewController.h"
#import "InstructionsViewController.h"
#import "InfoViewController.h"
#import "SettingsViewController.h"
#import "KeyboardViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface TitleScreenViewController : UIViewController {
	IBOutlet UIButton *newGameButton;
	IBOutlet UIButton *instructionsButton;
	IBOutlet UIButton *exitGameButton;
	IBOutlet UIButton *infoButton;
	IBOutlet UIButton *settingsButton;
	IBOutlet UIButton *restartGameButton;
	
	GameViewController *gameViewController;
	InstructionsViewController *instructionsViewController;
	InfoViewController *infoViewController;
	SettingsViewController *settingsViewController;
	DateTimeWeather *dateTimeWeather;
	KeyboardViewController *keyboardViewController;
	
	NSMutableDictionary *newPetData;
	NSTimer *timer;
	Manto *manto;	NSMutableData *receivedData;
}

@property(nonatomic, retain) IBOutlet UIButton *newGameButton;
@property(nonatomic, retain) IBOutlet UIButton *instructionsButton;
@property(nonatomic, retain) IBOutlet UIButton *exitGameButton;
@property(nonatomic, retain) IBOutlet UIButton *infoButton;
@property(nonatomic, retain) IBOutlet UIButton *settingsButton;
@property(nonatomic, retain) IBOutlet UIButton *restartGameButton;

@property(nonatomic, retain) GameViewController *gameViewController;
@property(nonatomic, retain) InstructionsViewController *instructionsViewController;
@property(nonatomic, retain) InfoViewController *infoViewController;
@property(nonatomic, retain) SettingsViewController *settingsViewController;
@property(nonatomic, retain) DateTimeWeather *dateTimeWeather;
@property(nonatomic, retain) KeyboardViewController *keyboardViewController;
@property(nonatomic, retain) NSMutableDictionary *newPetData;
@property(nonatomic, retain) NSMutableData *receivedData;

@property(nonatomic, retain) Manto *manto;
@property(nonatomic, retain) NSTimer *timer;

- (IBAction)startGame:(id)sender;
- (IBAction)launchInstructions:(id)sender;
- (IBAction)exitGame:(id)sender;
- (IBAction)getInfo:(id)sender;
- (IBAction)viewSettings:(id)sender;
- (IBAction)adoptNewPet:(id)sender;

- (void)checkOnlineDatabase;
- (void)loadPetFromDatabase;
- (void)createANewPet;
- (void)loadInventory:(int)petID;

@end