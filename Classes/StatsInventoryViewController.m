//
//  StatsInventoryViewController.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/2/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "StatsInventoryViewController.h"

@implementation StatsInventoryViewController
@synthesize pet;

// click to return to previous screen
- (void)goBack:(id)sender {
	[HelperMethods playSound:@"click"];
	[self.view removeFromSuperview];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,480,320)];
	contentView.backgroundColor = [UIColor blackColor];
	self.view = contentView;
	[contentView release];
	
	[self.view addSubview:[HelperMethods createImageWithX:0 andY:0 andImage:@"background.png"]];
	[self.view addSubview:[HelperMethods createButtonWithX:420 andY:295 andUpImage:@"keyboard_back.png" andDownImage:@"keyboard_backDOWN.png" 
												 andTarget:self andSelector:@selector(goBack:)]];
	
	[self.view addSubview:[HelperMethods createLabelWithX:170 andY:15 andWidth:400 andHeight:48 andText:@"Items Inventory" andTextSize:34]];
	
	// creates inventory scroll view; left frame
	[self initInventoryFrame];
	[self initButtonView];
	
	// default title messages
	itemTitle = [HelperMethods createLabelWithX:250 andY:60 andWidth:220 andHeight:30 andText:@"Press an item for more details." andTextSize:20];
	[self.view addSubview:itemTitle];
	
	// inits the right frame
	description = [[UITextView alloc] initWithFrame:CGRectMake(250,85,220,100)];
	description.editable = NO;
	description.userInteractionEnabled = NO;
	description.backgroundColor = [UIColor clearColor];
	[self.view addSubview:description];
}

- (void)initInventoryFrame {
	[inventoryScrollView removeFromSuperview];
	[inventoryScrollView release];
	inventoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20,60,220,220)];
	inventoryScrollView.userInteractionEnabled = YES;
	inventoryScrollView.scrollEnabled = YES;
	inventoryScrollView.showsVerticalScrollIndicator = YES;
	inventoryScrollView.contentSize = CGSizeMake(220,400);
	[self.view addSubview:inventoryScrollView];
	
	int column = 0;
	int row = 0;
	for(int i=0;i<pet.inventoryView.consumableInventory.count;i++) {
		StoreItem *sItem = [pet.inventoryView.consumableInventory objectAtIndex:i];
		int xLocation = column*25 + column*15;
		int yLocation = row*25 + row*20;
		
		UIButton *itemButton = [HelperMethods createButtonWithX:xLocation andY:yLocation andUpImage:sItem.imageName andDownImage:sItem.imageName 
													  andTarget:self andSelector:@selector(toggleItem:)];
		itemButton.tag = i;
		[inventoryScrollView addSubview:itemButton];
		
		// there are five items per row
		column++;
		if(column == 5) {
			column = 0;
			row++;
		}
	}
}

// store item is toggled
- (void)toggleItem:(id)sender {
	[HelperMethods playSound:@"click"];
	UIButton *btn = (UIButton*)sender;
	currentlySelectedItemKey = btn.tag;
	StoreItem *sItem = [pet.inventoryView.consumableInventory objectAtIndex:currentlySelectedItemKey];

	[itemTitle removeFromSuperview];
	itemTitle = [HelperMethods createLabelWithX:250 andY:60 andWidth:220 andHeight:30 andText:sItem.itemName andTextSize:20];
	[self.view addSubview:itemTitle];
	
	[quantityLabel removeFromSuperview];
	quantityLabel = [HelperMethods createLabelWithX:250 andY:190 andWidth:220 andHeight:20 andText:[NSString stringWithFormat:@"Quantity: %i",sItem.myQuantity] andTextSize:18];
	[self.view addSubview:quantityLabel];
	
	// consumable items change the stats of the pet
	if([sItem.type isEqualToString:@"consumable"]) {
		NSDictionary *statsDict = [pet keyValueParser:sItem.statIncrease];
		NSLog(@"%@",statsDict);
		
		[statsView removeFromSuperview];	
		statsView = [[UIView alloc] initWithFrame:CGRectMake(250,160,220,60)];
		[self.view addSubview:statsView];
		
		[statsView addSubview:[HelperMethods createImageWithX:0 andY:0 andImage:@"stats_happiness.png"]];
		[statsView addSubview:[HelperMethods createImageWithX:55 andY:0 andImage:@"stats_hunger.png"]];
		[statsView addSubview:[HelperMethods createImageWithX:110 andY:0 andImage:@"stats_hygiene.png"]];
		[statsView addSubview:[HelperMethods createImageWithX:175 andY:0 andImage:@"stats_fitness.png"]];
		
		[statsView addSubview:[HelperMethods createLabelWithX:28 andY:-2 andWidth:100 andHeight:25 andText:[statsDict objectForKey:@"hap"]]];
		[statsView addSubview:[HelperMethods createLabelWithX:83 andY:-2 andWidth:100 andHeight:25 andText:[statsDict objectForKey:@"hun"]]];
		[statsView addSubview:[HelperMethods createLabelWithX:143 andY:-1 andWidth:100 andHeight:25 andText:[statsDict objectForKey:@"hyg"]]];
		[statsView addSubview:[HelperMethods createLabelWithX:200 andY:0 andWidth:100 andHeight:25 andText:[statsDict objectForKey:@"fit"]]];
		[statsView release];
	} else {
		statsView.hidden = YES;
	}
	
	buttonsView.hidden = NO;
	
	// description
	description.text = sItem.description;
}

- (void)initButtonView {
	buttonsView = [[UIView alloc] initWithFrame:CGRectMake(260, 240, 200, 26)];
	buttonsView.hidden = YES;
	[self.view addSubview:buttonsView];
	
	// use item
	CompleteInHimFont *useItemLabel = [HelperMethods createLabelWithX:0 andY:0 andWidth:70 andHeight:26 andText:@"Use Item" andTextSize:26];
	[buttonsView addSubview:useItemLabel];
	
	UIButton *useItemButton = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(0, 0, 70, 26)];
	[useItemButton addTarget:self action:@selector(useItem:) forControlEvents:UIControlEventTouchUpInside];		
	[buttonsView addSubview:useItemButton];
	
	// sell item
	CompleteInHimFont *sellItemLabel = [HelperMethods createLabelWithX:110 andY:0 andWidth:80 andHeight:30 andText:@"Sell Item" andTextSize:26];
	[buttonsView addSubview:sellItemLabel];
	
	UIButton *sellItemButton = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(110, 0, 80, 26)];
	[sellItemButton addTarget:self action:@selector(sellItem:) forControlEvents:UIControlEventTouchUpInside];		
	[buttonsView addSubview:sellItemButton];
}

- (void)useItem:(id)sender {
	StoreItem *sItem = [pet.inventoryView.consumableInventory objectAtIndex:currentlySelectedItemKey];
	[pet useItem:sItem atIndex:currentlySelectedItemKey];
	[self initInventoryFrame];
	
	[itemTitle removeFromSuperview];
	itemTitle = [HelperMethods createLabelWithX:250 andY:60 andWidth:220 andHeight:30 andText:@"Press an item for more details." andTextSize:20];
	[self.view addSubview:itemTitle];

	description.text = @"";
	buttonsView.hidden = YES;
	quantityLabel. hidden = YES;
	statsView.hidden = YES;
	
	// THIS ALERT IS A TEST!!!!
	[HelperMethods alertWithTitle:@"Item Used" andMessage:@"An item was just used!" andTarget:self];
}


- (void)sellItem:(id)sender {
	NSLog(@"sell");
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[pet release];
    [super dealloc];
}


@end
