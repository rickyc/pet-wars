//
//  StoreItem.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/2/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "StoreItem.h"

@implementation StoreItem
@synthesize key, categoryId, category, itemName, price, myQuantity, storeQuantity, statIncrease, type, consumable, description,
imageName, imageView, inventoryId, showInInventory;

- (id)initWithDictionary:(NSDictionary*)dictionary {
	[super init];
	self.key = [[dictionary objectForKey:@"key"] intValue];
	self.categoryId = [[dictionary objectForKey:@"category"] intValue];
	self.itemName = [dictionary objectForKey:@"name"];
	self.price = [[dictionary objectForKey:@"price"] intValue];
	self.storeQuantity = [[dictionary objectForKey:@"quantity"] intValue];
	self.statIncrease = [dictionary objectForKey:@"stat_increase"];
	self.type = [dictionary objectForKey:@"type"];
	self.consumable = [[dictionary objectForKey:@"consumable"] isEqualToString:@"YES"] ? YES : NO;
	self.showInInventory = self.consumable;
	self.description = [dictionary objectForKey:@"description"];
	self.imageName = [dictionary objectForKey:@"image"];
	self.inventoryId = [[dictionary objectForKey:@"inventory_id"] intValue];
	
	if([dictionary objectForKey:@"my_quantity"] != nil)
		self.myQuantity = [[dictionary objectForKey:@"my_quantity"] intValue];
	
	return self;
}

- (void)dealloc {
	[imageView release];
	[imageName release];
	[description release];
	[category release];
	[itemName release];
	[statIncrease release];
	[type release];
	[super dealloc];
}

@end
