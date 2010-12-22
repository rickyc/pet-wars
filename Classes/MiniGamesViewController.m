//
//  MiniGamesViewController.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/25/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "MiniGamesViewController.h"


@implementation MiniGamesViewController
@synthesize exitMiniGamesButton, tableView, gamesAry, ticTacToeViewController, rockPaperScissorViewController, pet, peerToPeerViewController;

- (IBAction)exitMiniGames:(id)sender {
	if(rockPaperScissorViewController != nil) {
		[rockPaperScissorViewController release];
		rockPaperScissorViewController = nil;
	}	
	if(ticTacToeViewController != nil) {
		[ticTacToeViewController release];
		ticTacToeViewController = nil;
	}
	if(peerToPeerViewController != nil) {
		[peerToPeerViewController release];
		peerToPeerViewController = nil;
	}
	[self.view removeFromSuperview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [gamesAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	NSDictionary *game = [gamesAry objectAtIndex:indexPath.row];
	
	CompleteInHimFont *nameLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(50, 15, 160, 22)] autorelease];
	[nameLabel initTextWithSize:24.0f color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[nameLabel updateText:[game objectForKey:@"name"]];
	
	CompleteInHimFont *descriptionLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(50, 40, 250, 22)] autorelease];
	[descriptionLabel initTextWithSize:14.0f color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[descriptionLabel updateText:[game objectForKey:@"description"]];
	
	// add to cell
    [cell.contentView addSubview:nameLabel];
	[cell.contentView addSubview:descriptionLabel];
	
	UIImageView *nextArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
	cell.accessoryView = nextArrow;
	[nextArrow release];
	
	cell.imageView.image = [UIImage imageNamed:[game objectForKey:@"image"]];
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *game = [gamesAry objectAtIndex:indexPath.row];
	NSString *name = [game objectForKey:@"name"];
	[HelperMethods playSound:@"click"];
	
	if([name isEqualToString:@"Rock Paper Scissors"]) {
		if(rockPaperScissorViewController != nil) {
			[rockPaperScissorViewController release];
			rockPaperScissorViewController = nil;
		}
		rockPaperScissorViewController = [[RockPaperScissorViewController alloc] initWithNibName:@"RockPaperScissor" bundle:[NSBundle mainBundle]];
		rockPaperScissorViewController.pet = self.pet;
		[self.view addSubview:rockPaperScissorViewController.view];
	} else if([name isEqualToString:@"Tic Tac Toe"]) {
		if(ticTacToeViewController != nil) { 
			[ticTacToeViewController release];
			ticTacToeViewController = nil;
		}
		ticTacToeViewController = [[TicTacToeViewController alloc] initWithNibName:@"TicTacToe" bundle:[NSBundle mainBundle]];		
		ticTacToeViewController.pet = self.pet;
		[self.view addSubview:ticTacToeViewController.view];
	} else if([name isEqualToString:@"Peer-to-Peer"]) {
		if(peerToPeerViewController != nil) {
			[peerToPeerViewController release];
			peerToPeerViewController = nil;
		}
		peerToPeerViewController = [PeerToPeerViewController new];
		[self.view addSubview:peerToPeerViewController.view];
		NSLog(@"umm this part was all andrews... wheree... is it?");
	}		
}

- (void)viewDidAppear:(BOOL)animted {
	NSLog(@"games appeared");
	[self loadGames];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// generates title
    CompleteInHimFont *miniGamesLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(150, 20, 480, 50)] autorelease];
	[miniGamesLabel initTextWithSize:48.0f color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[miniGamesLabel updateText:[NSString stringWithString:@"Mini Games"]];
	[self.view addSubview:miniGamesLabel];
	
	gamesAry = [NSMutableArray new];
 	self.tableView.backgroundColor = [UIColor clearColor];
	[self loadGames];
	[tableView reloadData];
}

# pragma mark Database Method
- (void)loadGames {
	[gamesAry release];
	gamesAry = [NSMutableArray new];
	
	FMDatabase *db = [FMDatabase databaseWithPath:[HelperMethods getDatabasePath]];
	[db open];

	int petID = 1;
	FMResultSet *rs = [db executeQuery:@"SELECT store_items.* FROM inventory_items LEFT JOIN store_items ON inventory_items.item_id = store_items.id " \
					   "WHERE pet_id = ? AND category_id = 3 ORDER BY item_name ASC", [NSNumber numberWithInt:petID]];
	
	while([rs next]) {
		NSString *gameName = [rs stringForColumn:@"item_name"];
		NSString *description = [rs stringForColumn:@"description"];
		NSString *imageName = [rs stringForColumn:@"image_name"];
				
		NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:gameName,imageName,description,nil] forKeys:
								[NSArray arrayWithObjects:@"name",@"image",@"description",nil]];
		[gamesAry addObject:dict];
	}
	[rs close];
	[db close];
	
	[tableView reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tableView release];
	[gamesAry release];
	[rockPaperScissorViewController release];
	[ticTacToeViewController release];
	[exitMiniGamesButton release];
    [super dealloc];
}


@end
