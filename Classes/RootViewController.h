//
//  RootViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/22/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"
#import "TitleScreenViewController.h"
#import "GameViewController.h"
#import "StoreViewController.h"
#import "DeviceData.h"

@interface RootViewController : UIViewController {
	SplashViewController *splashViewController;
	
	// major hax, global vars
	// our view implementation is actually all over the place, i don't know what i did =X
	TitleScreenViewController *titleScreenViewController;
	GameViewController *gameViewController;
	StoreViewController *storeViewController;
}

@property(nonatomic, retain) SplashViewController *splashViewController;

// ugliness
@property(nonatomic, retain) TitleScreenViewController *titleScreenViewController;
@property(nonatomic, retain) GameViewController *gameViewController;
@property(nonatomic, retain) StoreViewController *storeViewController;

@end
