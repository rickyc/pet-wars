//
//  StoreItem.h
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/2/09.
//  Copyright 2009 Family. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreItem : NSObject {
	int key;
	int categoryId;
	int price;
	int myQuantity;		// how should I store this?
	int storeQuantity;	
	int inventoryId;
	BOOL consumable;
	BOOL showInInventory;

	NSString *category; // maybe not necessary
	NSString *itemName;
	NSString *description;
	NSString *statIncrease;
	NSString *type;
	NSString *imageName;
	
	UIImageView *imageView;
}

@property(nonatomic, assign) int key;
@property(nonatomic, assign) int categoryId;
@property(nonatomic, assign) int price;
@property(nonatomic, assign) int myQuantity;
@property(nonatomic, assign) int storeQuantity;
@property(nonatomic, assign) BOOL consumable;
@property(nonatomic, assign) BOOL showInInventory;
@property(nonatomic, assign) int inventoryId;
@property(nonatomic, retain) NSString *category;
@property(nonatomic, retain) NSString *itemName;
@property(nonatomic, retain) NSString *statIncrease;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *imageName;
@property(nonatomic, retain) UIImageView *imageView;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
