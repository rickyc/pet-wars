//
//  StoreViewController.m
//  StoreViewController
//
//  Created by Jamin aka JDog on 4/21/09.
//  *Sorry, I destroyed your class =(
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreItem.h"

@implementation StoreViewController
@synthesize categoriesDictionary, itemsDictionary, shopper, storeDetailedViewController;

@synthesize currentList;
@synthesize tv;

// because of jdogs crappy implementation
int lastSelectedRow;

# pragma mark Database Method
- (void)loadStoreCategories {
	FMDatabase* db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];

	// grabs items from categories
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM store_categories"];
	while ([rs next]) {
		int key = [rs intForColumn:@"id"];
		NSString *category = [rs stringForColumn:@"name"];
		NSString *image = [rs stringForColumn:@"image"];
		NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:category,image,nil] forKeys:
								[NSArray arrayWithObjects:@"name",@"image",nil]];
				
		// load store items by category
		[itemsDictionary setObject:[self loadStoreItems:key] forKey:[NSString stringWithFormat:@"%i",key]];
		[categoriesDictionary setObject:dict forKey:[NSString stringWithFormat:@"%i",key]];
	}
	[rs close];
	[db close];
}

- (NSArray*)loadStoreItems:(int)category {
	// this array basically holds all the items from the database
	NSMutableArray *itemsArray = [NSMutableArray new];

	FMDatabase* db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];
	
	// grabs items from categories
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM store_items WHERE category_id = ? AND hidden = ? ORDER BY item_name ASC", [NSNumber numberWithInt:category],@"NO"];
	while([rs next]) {
		NSString *key = [NSString stringWithFormat:@"%i",[rs intForColumn:@"id"]];
		NSString *itemName = [rs stringForColumn:@"item_name"];
		NSString *description = [rs stringForColumn:@"description"];
		NSString *price = [NSString stringWithFormat:@"%i",[rs intForColumn:@"price"]];
		NSString *quantity = [NSString stringWithFormat:@"%i",[rs intForColumn:@"quantity"]];
		NSString *maxQuantity = [NSString stringWithFormat:@"%i",[rs intForColumn:@"max_quantity"]];
		NSString *statIncrease = [rs stringForColumn:@"stats_increase"];
		NSString *type = [rs stringForColumn:@"type"];
		NSString *imageName = [rs stringForColumn:@"image_name"];
		NSString *consumable = [rs stringForColumn:@"consumable"];
		
		// category_id
		NSString *categoryStr = [NSString stringWithFormat:@"%i",category];
		
		NSDictionary *item = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:key,categoryStr,itemName,description,price,quantity,imageName,
								maxQuantity,statIncrease,type,consumable,nil] forKeys:[NSArray arrayWithObjects:@"key",@"category",@"name",@"description",
								@"price",@"quantity",@"image",@"max_quantity",@"stat_increase",@"type",@"consumable",nil]];
		StoreItem *sItem = [[StoreItem alloc] initWithDictionary:item];
		[itemsArray addObject:sItem];
		// NSLog(@"database shit: key=>%i, item_name=>%@, quantity=>%i, imageName=>%@",key,itemName,quantity,imageName);
	}
	[rs close];
	[db close];
	
	// returns the array full of items
	return itemsArray;
}

#pragma mark -
- (IBAction)exitStore:(id)sender {
	currentList = @"categories";
	lastSelectedRow = 0;
	[tv reloadData];
	
	[self.view removeFromSuperview];
	// supposedly release view, recreate game view and add to RootViewController
	// however FAIL
//	[self release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	categoriesDictionary = [NSMutableDictionary new];
	itemsDictionary = [NSMutableDictionary new];
	[self loadStoreCategories];
	
//	NSLog(@"cat dic: %@",categoriesDictionary);
//	NSLog(@"items dict: %@",itemsDictionary);
	
	currentList = @"categories";
	lastSelectedRow = 0;
	
	// generates title
    CompleteInHimFont *marketLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(150, 30, 480, 50)] autorelease];
	[marketLabel initTextWithSize:48.0f color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[marketLabel updateText:[NSString stringWithString:@"The Market"]];
	[self.view addSubview:marketLabel];

	// back / exit button
	[self.view addSubview:[HelperMethods createButtonWithX:420 andY:295 andUpImage:@"keyboard_back.png" andDownImage:@"keyboard_backDOWN.png" 
												 andTarget:self andSelector:@selector(goBack:)]];
	
	[super viewDidLoad];
}

-(void)goBack:(id)sender{
	[HelperMethods playSound:@"click"];
	
	// exit
	if([currentList isEqualToString:@"categories"]) {
		currentList = @"categories";
		lastSelectedRow = 0;
		[tv reloadData];
		
		[self.view removeFromSuperview];		
	} else {
		currentList = @"categories";
		lastSelectedRow = 0;
		
		//backButton.hidden = YES;
		[tv reloadData];
	}
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(self.currentList == @"categories")
		return [[categoriesDictionary allKeys] count];
	else
		return [[itemsDictionary objectForKey:[NSString stringWithFormat:@"%i",lastSelectedRow+1]] count];
	// should never reach here
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	tableView.backgroundColor = [UIColor clearColor];
	
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	NSDictionary *categoryRow;
	StoreItem *itemRow;
	
	int itemsPerCategory;
	// indexPath.row + 1, because the key on a SQL database begins at 1 not 0
	if(self.currentList == @"categories") {
		categoryRow = [categoriesDictionary objectForKey:[NSString stringWithFormat:@"%i",indexPath.row+1]];
		itemsPerCategory = [[itemsDictionary objectForKey:[NSString stringWithFormat:@"%i",indexPath.row+1]] count];
	} else if(self.currentList == @"items") {
		NSArray *dictionary = [itemsDictionary objectForKey:[NSString stringWithFormat:@"%i",lastSelectedRow+1]];
		itemRow = [dictionary objectAtIndex:indexPath.row];
	}
	// ^ fix this and integrate into one nsdictionary
	
	// categories
	CompleteInHimFont *categoryLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(50, 10, 160, 22)] autorelease];
	[categoryLabel initTextWithSize:24.0f color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	
	if(self.currentList == @"categories")
		[categoryLabel updateText:[categoryRow objectForKey:@"name"]];
	else	// remove this else when dictionary is done
		[categoryLabel updateText:itemRow.itemName];

	// quantity
	NSString *qn;
	int defaultPosition;
	if(self.currentList == @"categories") {
		qn = [NSString stringWithFormat:@"%i Items", itemsPerCategory];
		defaultPosition = 230-3*(qn.length - 7);
	} else {
		// check for sold out!
		qn = [NSString stringWithFormat:@"Quantity: %i", itemRow.storeQuantity];
		defaultPosition = 210-3*(qn.length - 10);
	}
	
	// algorithm needs fixing!
	CGRect frame = CGRectMake(defaultPosition, 10, 150, 16);
	CompleteInHimFont *secondLabel = [[CompleteInHimFont alloc] initWithFrame:frame];
	[secondLabel initTextWithSize:20 color:[UIColor redColor] bgColor:[UIColor clearColor]];
	[secondLabel updateText:qn];
	
	// add to cell
    [cell.contentView addSubview:categoryLabel];
	[cell.contentView addSubview:secondLabel];
	
	UIImageView *nextArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
	cell.accessoryView = nextArrow;
	[nextArrow release];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	if(self.currentList==@"categories"){
		cell.imageView.image = [UIImage imageNamed:[categoryRow objectForKey:@"image"]];
	} else if(self.currentList == @"items")
		cell.imageView.image = [UIImage imageNamed:itemRow.imageName];
	
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[HelperMethods playSound:@"click"];
	
	// blahhhhhhh cause of jdog's code!
	if(self.currentList == @"categories") {
		lastSelectedRow = indexPath.row;
		self.currentList = @"items";
		//backButton.hidden = NO;
		[tableView reloadData];	
	}
	// select item
	else {
		NSArray *dictionary = [itemsDictionary objectForKey:[NSString stringWithFormat:@"%i",lastSelectedRow+1]];
		StoreItem *item = [dictionary objectAtIndex:indexPath.row];
		
		if(storeDetailedViewController != nil)
			[self.storeDetailedViewController release];
		
		self.storeDetailedViewController = [StoreDetailedViewController new];
		self.storeDetailedViewController.item = item;
		self.storeDetailedViewController.shopper = self.shopper;
		
		[self.view addSubview:self.storeDetailedViewController.view];
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)viewDidDisappear:(BOOL)animated {
	//NSLog(@"shoppers inventory's %@:",self.shopper.consumableInventory);
}

- (void)dealloc {
	[storeDetailedViewController release];
	[itemsDictionary release];
	[categoriesDictionary release];
	[currentList release];
	[tv release];
    [super dealloc];
}

@end
