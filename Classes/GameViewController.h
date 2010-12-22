//
//  GameViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/18/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "DateTimeWeather.h"
#import "StoreViewController.h"
#import "MiniGamesViewController.h"
#import "StatsViewController.h"
#import "Manto.h"
#import "GObject.h"
#import "UserInventory.h"

#define kMenuYOpened 28
#define kMenuYClosed -18

#define kMaxBarStats 500

// two finger swipe
#define kMinimumGestureLength 25
#define kMaximumVariance 5

// accelerometer speed
#define kUpdateInterval (1.0f/30.0f)
#define kAccelerometerSpeed 30.0
#define kAccelerometerThreshold 2.2

// those methods should really be inside... WOAPS
BOOL accelerometerActive;	// currently using accelerometer
BOOL touchBegan;			// if touch started

// clouds move across the screen at varying speeds
float largeCloudSpeed, smallCloudSpeed;

// grass animations
int grassShearCounter, grassMaxShear, grassShearDirection;

@interface GameViewController : UIViewController <UIAccelerometerDelegate> {
	// main character
	Manto *petRock;
	
	// variables for the game / stage
	IBOutlet UIImageView *grass; // if there is no animation please remove and resize the grass image to 480px
	IBOutlet UIImageView *largeCloud;
	IBOutlet UIImageView *smallCloud;
	IBOutlet UIImageView *sunMoon;
	IBOutlet UIButton *openCloseMenuButton;
	
	// upper right corner icons
	IBOutlet UIView *menuView;
	IBOutlet UIButton *jukeboxButton;
	IBOutlet UIButton *shoppingButton;
	IBOutlet UIButton *minigamesButton;
	
	// bars & hearts
	IBOutlet UIView *healthView;
	IBOutlet UIImageView *happinessBarImageView;
	IBOutlet UIImageView *hygieneBarImageView;
	IBOutlet UIImageView *hungerBarImageView;
	IBOutlet UIImageView *happinessBar;
	IBOutlet UIImageView *hygieneBar;
	IBOutlet UIImageView *hungerBar;
	
	IBOutlet UIView *ansalasView;
	IBOutlet UILabel *ansalasLabel;
	
	// variables used for the jukebox
	MPMediaQuery *songList; 
	MPMusicPlayerController *musicPlayer;
	CompleteInHimFont *songTitleLabel;
	
	DateTimeWeather *dateTimeWeather;
	NSTimer *weatherChecker;
	NSTimer *petAnimationTimer;
	
	StoreViewController *storeViewController;
	MiniGamesViewController *miniGamesViewController;
	StatsViewController *statsViewController;
	
	BOOL userMusicOn;
	
	CGPoint gestureStartPoint;
	NSMutableArray *itemsOnStage;
	
	UserInventory *inventoryView;
}

@property(nonatomic, retain) Manto *petRock;

@property(nonatomic, retain) UIImageView *grass;
@property(nonatomic, retain) UIImageView *largeCloud;
@property(nonatomic, retain) UIImageView *smallCloud;
@property(nonatomic, retain) UIImageView *sunMoon;

@property(nonatomic, retain) UIView *menuView;
@property(nonatomic, retain) UIButton *openCloseMenuButton;

@property(nonatomic, retain) UIButton *jukeboxButton;
@property(nonatomic, retain) UIButton *shoppingButton;
@property(nonatomic, retain) UIButton *minigamesButton;

@property(nonatomic, retain) MPMediaQuery *songList;
@property(nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property(nonatomic, retain) CompleteInHimFont *songTitleLabel;

@property(nonatomic, retain) UIView *ansalasView;
@property(nonatomic, retain) UILabel *ansalasLabel;

// health & bars
@property(nonatomic, retain) IBOutlet UIView *healthView;
@property(nonatomic, retain) IBOutlet UIImageView *happinessBarImageView;
@property(nonatomic, retain) IBOutlet UIImageView *hygieneBarImageView;
@property(nonatomic, retain) IBOutlet UIImageView *hungerBarImageView;
@property(nonatomic, retain) IBOutlet UIImageView *happinessBar;
@property(nonatomic, retain) IBOutlet UIImageView *hygieneBar;
@property(nonatomic, retain) IBOutlet UIImageView *hungerBar;

@property(nonatomic, retain) DateTimeWeather *dateTimeWeather;
@property(nonatomic, retain) NSTimer *weatherChecker;
@property(nonatomic, retain) NSTimer *petAnimationTimer;
@property(nonatomic, retain) StoreViewController *storeViewController;
@property(nonatomic, retain) MiniGamesViewController *miniGamesViewController;
@property(nonatomic, retain) StatsViewController *statsViewController;

// used once and then removed
@property(nonatomic, retain) UserInventory *inventoryView;

// manto's toys and poop are stored in this array
@property(nonatomic, retain) NSMutableArray *itemsOnStage;

// TESTING: i do not think this is necessary
@property(nonatomic, assign) BOOL userMusicOn;

// two finger swipe, currently not used
@property(nonatomic, assign) CGPoint gestureStartPoint;

- (IBAction)playJukeBox:(id)sender;
- (IBAction)playMiniGames:(id)sender;
- (IBAction)gotoStore:(id)sender;
- (IBAction)openCloseMenu:(id)sender;

- (void)redraw;
- (void)drawHealth;
- (void)drawStatBars;
- (void)addGObjectToStageWithName:(NSString*)name andImage:(NSString*)image andScale:(float)scaleFactor andInFront:(BOOL)front andPosition:(double)position andKey:(int)key;

@end