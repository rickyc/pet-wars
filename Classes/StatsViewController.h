//
//  StatsViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/25/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manto.h"
#import "GlobalDataViewController.h"
#import "StatsInventoryViewController.h"
#import "StatsWeaponViewController.h"

@interface StatsViewController : UIViewController {
	IBOutlet UIButton *backButton;
	Manto *pet;
	GlobalDataViewController *globalDataViewController;
	StatsInventoryViewController *inventoryViewController;
	StatsWeaponViewController *weaponsViewController;
}

@property(nonatomic, retain) UIButton *backButton;
@property(nonatomic, retain) Manto *pet;
@property(nonatomic, retain) GlobalDataViewController *globalDataViewController;
@property(nonatomic, retain) StatsInventoryViewController *inventoryViewController;
@property(nonatomic, retain) StatsWeaponViewController *weaponsViewController;


- (void)closeStatsScreen:(id)sender;
- (void)initLeftView;
- (void)initRightView;
- (void)freeAndNil;

@end
