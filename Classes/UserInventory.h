//
//  UserInventory.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/16/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInventory : UIScrollView {
	NSMutableArray *consumableInventory;
}

@property(nonatomic, retain) NSMutableArray *consumableInventory;

- (void)clearInventoryView;
- (void)drawInventory;

@end