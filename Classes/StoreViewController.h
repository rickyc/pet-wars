//
//  StoreViewController.h
//  StoreViewController
//
//  Created by Jamin aka JDog on 4/21/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manto.h"
#import "StoreDetailedViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface StoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	NSMutableDictionary *categoriesDictionary;
	NSMutableDictionary *itemsDictionary;
	
	NSString *currentList;
	IBOutlet UITableView *tv;
	
	StoreDetailedViewController *storeDetailedViewController;
	
	Manto *shopper;
}

@property(nonatomic, retain) NSMutableDictionary *categoriesDictionary;
@property(nonatomic, retain) NSMutableDictionary *itemsDictionary;

@property(nonatomic, retain) NSString *currentList;
@property(nonatomic, retain) UITableView *tv;

@property(nonatomic, retain) Manto *shopper;
@property(nonatomic, retain) StoreDetailedViewController *storeDetailedViewController;

- (void)goBack:(id)sender;
- (void)loadStoreCategories;
- (NSArray*)loadStoreItems:(int)category;

@end

