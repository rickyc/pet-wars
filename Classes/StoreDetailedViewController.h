//
//  StoreDetailedViewController.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/2/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreItem.h"
#import "Manto.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface StoreDetailedViewController : UIViewController {
	StoreItem *item;
	Manto *shopper;
}

@property(nonatomic, retain) StoreItem *item;
@property(nonatomic, retain) Manto *shopper;

-(void)updateInventory:(StoreItem*)item;

@end
