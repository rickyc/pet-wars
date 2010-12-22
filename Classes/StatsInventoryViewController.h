//
//  StatsInventoryViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/2/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manto.h"

@interface StatsInventoryViewController : UIViewController {
	Manto *pet;
	
	CompleteInHimFont *itemTitle;
	CompleteInHimFont *quantityLabel;
	
	UIScrollView *inventoryScrollView;
	UITextView *description;
	UIView *statsView;
	UIView *buttonsView;
	int currentlySelectedItemKey;
}

- (void)goBack:(id)sender;
- (void)initInventoryFrame;
- (void)initButtonView;
@property(nonatomic, retain) Manto *pet;

@end
