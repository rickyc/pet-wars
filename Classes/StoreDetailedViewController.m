//
//  StoreDetailedViewController.m
//  iDrewStuff
//
//  Created by Ricky Cheng & JDog on 5/2/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "StoreDetailedViewController.h"

@implementation StoreDetailedViewController
@synthesize item, shopper;

- (void)closeStatsScreen:(id)sender {
	[HelperMethods playSound:@"click"];
	[self.view removeFromSuperview];
}

- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,480,320)];
	contentView.backgroundColor = [UIColor blackColor];
	self.view = contentView;
	[contentView release];
	
	[self.view addSubview:[HelperMethods createImageWithX:0 andY:0 andImage:@"background.png"]];
	[self.view addSubview:[HelperMethods createButtonWithX:420 andY:295 andUpImage:@"keyboard_back.png" andDownImage:@"keyboard_backDOWN.png" 
												 andTarget:self andSelector:@selector(closeStatsScreen:)]];
	
	int leftMargin = 30;
	//item name
	[self.view addSubview:[HelperMethods createLabelWithX:75 andY:25 andWidth:380 andHeight:50 andText:item.itemName andTextSize:34]];
	
	//item image
	[self.view addSubview:[HelperMethods createImageWithX:leftMargin andY:25 andImage:item.imageName]];
	
	//price
	NSString *priceStr = [NSString stringWithFormat:@"Price %i ansalas",item.price];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:130 andWidth:380 andHeight:50 andText:priceStr andTextSize:24]];
	
	// currently have how many quantity
	NSString *quantityStr = [NSString stringWithFormat:@"Quantity Left in Store: %i",item.storeQuantity];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:165 andWidth:380 andHeight:50 andText:quantityStr andTextSize:24]];
	
	//currently user owns how many
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:200 andWidth:380 andHeight:50 andText:@"You Currently Own: ?" andTextSize:24]];
	
	// description of item
	UITextView *textView = [[[UITextView alloc] initWithFrame:CGRectMake(45,60,390,50)] autorelease];
	textView.text = item.description;
	textView.userInteractionEnabled = NO;
	textView.editable = NO;
	textView.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
	textView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:textView];

	//purchase
	UIButton *btn = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(15, 290, 100, 20)];
	[btn addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
	[btn setBackgroundImage:[UIImage imageNamed:@"purchasebtn.png"] forState:UIControlStateNormal];
	[btn setBackgroundImage:[UIImage imageNamed:@"purchasebtndown.png"] forState:UIControlStateHighlighted];
	[self.view addSubview:btn];
	
}

- (void)purchase:(id)sender{
	if(![item.type isEqualToString:@"game"]) {
		[self.shopper.inventoryView.consumableInventory addObject:item]; 
		[self.shopper.inventoryView drawInventory];
	}
	
	// database update
	[self updateInventory:item];
	
	[self.view removeFromSuperview];
	NSLog(@"Purchased item");
}

// FIX: select and get current quantity....
-(void)updateInventory:(StoreItem*)purchasedItem {
	FMDatabase* db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];

	// temp var, change this, or remote altogether
	int quantity = 1;

	[db beginTransaction];
	[db executeUpdate:@"INSERT INTO inventory_items (item_id, quantity, purchase_date, pet_id) VALUES(?,?,?,?)",
	 [NSNumber numberWithInt:purchasedItem.key],[NSNumber numberWithInt:quantity],[shopper.dtw getTimeForSQL],[NSNumber numberWithInt:shopper.key]];
	[db commit];
	[db close];

	// saves the inventory id to the newly purchased item
	int lastID = [shopper getLastInventoryID];
	NSLog(@"last id => %i",lastID);
	self.item.inventoryId = lastID;
		
	NSLog(@"done---@@@#@# :D");
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
