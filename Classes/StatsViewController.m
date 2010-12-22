//
//  StatsViewController.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/25/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "StatsViewController.h"

@implementation StatsViewController
@synthesize backButton, pet, globalDataViewController, inventoryViewController, weaponsViewController;

- (void)closeStatsScreen:(id)sender {
	[self freeAndNil];
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
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	// init
	[self initLeftView];
	[self initRightView];
}

- (void)initLeftView {
	int leftMargin = 28;
	int topMargin = -10;
	int spacing = 35;
	
	// pet name
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:topMargin+1*spacing andWidth:250 andHeight:20 andText:[NSString stringWithFormat:@"%@ %@",@"Name:",pet.petName]]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:topMargin+2*spacing andWidth:150 andHeight:20 andText:@"Gender:"]];
	[self.view addSubview:[HelperMethods createImageWithX:100 andY:topMargin+2*spacing andImage:[NSString stringWithFormat:@"stats_%@.png",pet.gender]]];
	
	// age
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:topMargin+3*spacing andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %@",@"Age:",[pet getAge]]]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:topMargin+4*spacing andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %@",@"Mood:",pet.mood]]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:topMargin+5*spacing andWidth:250 andHeight:20 andText:[NSString stringWithFormat:@"%@ %@",@"Fav. Color:",pet.favoriteColor]]];
	
	spacing = 30;
	[self.view addSubview:[HelperMethods createImageWithX:leftMargin+50 andY:6.8*spacing andImage:@"stats_left_line.png"]];
	
	// change below
	int imageMargin = 35;
	[self.view addSubview:[HelperMethods createImageWithX:imageMargin andY:8*spacing andImage:@"stats_happiness.png"]];
	[self.view addSubview:[HelperMethods createImageWithX:imageMargin andY:9*spacing andImage:@"stats_hunger.png"]];
	[self.view addSubview:[HelperMethods createImageWithX:imageMargin-5+90 andY:8*spacing andImage:@"stats_hygiene.png"]];
	[self.view addSubview:[HelperMethods createImageWithX:imageMargin+90 andY:9*spacing andImage:@"stats_fitness.png"]];
	
	[self.view addSubview:[HelperMethods createLabelWithX:imageMargin+35 andY:8*spacing-5 andWidth:50 andHeight:20 andText:[NSString stringWithFormat:@"%i",pet.happiness]]];
	[self.view addSubview:[HelperMethods createLabelWithX:imageMargin+35 andY:9*spacing-2 andWidth:50 andHeight:20 andText:[NSString stringWithFormat:@"%i",pet.hunger]]];
	[self.view addSubview:[HelperMethods createLabelWithX:imageMargin+35+90 andY:8*spacing-2 andWidth:50 andHeight:20 andText:[NSString stringWithFormat:@"%i",pet.hygiene]]];
	[self.view addSubview:[HelperMethods createLabelWithX:imageMargin+35+90 andY:9*spacing andWidth:50 andHeight:20 andText:[NSString stringWithFormat:@"%i",pet.fitness]]];
}

- (void)showHighScores:(id)sender {
	[[Beacon shared] startSubBeaconWithName:@"High Scores" timeSession:NO];
	[HelperMethods playSound:@"click"];
	
	if(globalDataViewController == nil)
		globalDataViewController = [GlobalDataViewController new];
	[self.view addSubview:globalDataViewController.view];
}

- (void)showP2PInventory:(id)sender {
	[[Beacon shared] startSubBeaconWithName:@"P2P Inventory" timeSession:NO];
	[HelperMethods playSound:@"click"];
	
	if(weaponsViewController == nil)
		weaponsViewController = [StatsWeaponViewController new];
	[self.view addSubview:weaponsViewController.view];
}

- (void)showInventory:(id)sender {
	[[Beacon shared] startSubBeaconWithName:@"Inventory" timeSession:NO];
	[HelperMethods playSound:@"click"];
	
	if(inventoryViewController == nil) {
		inventoryViewController = [StatsInventoryViewController new];
		inventoryViewController.pet = pet;
	}
	
	[self.view addSubview:inventoryViewController.view];
}

// UIButtons are leaking =(
- (void)initRightView {
	UIImage *highScoresImg = [UIImage imageNamed:@"stats_high_scores.png"];
	UIButton *highScoresBtn = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(350, 5, highScoresImg.size.width, highScoresImg.size.height)];
	[highScoresBtn addTarget:self action:@selector(showHighScores:) forControlEvents:UIControlEventTouchUpInside];
	[highScoresBtn setBackgroundImage:highScoresImg forState:UIControlStateNormal];
	[highScoresBtn setBackgroundImage:[UIImage imageNamed:@"stats_high_scores_hl.png"] forState:UIControlStateHighlighted];
	[self.view addSubview:highScoresBtn];
	
	UIImage *weaponsImg = [UIImage imageNamed:@"stats_weapon.png"];
	UIButton *weaponsBtn = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(397, 5, weaponsImg.size.width, weaponsImg.size.height)];
	[weaponsBtn addTarget:self action:@selector(showP2PInventory:) forControlEvents:UIControlEventTouchUpInside];
	[weaponsBtn setBackgroundImage:weaponsImg forState:UIControlStateNormal];
	[weaponsBtn setBackgroundImage:[UIImage imageNamed:@"stats_weapon_hl.png"] forState:UIControlStateHighlighted];
	[self.view addSubview:weaponsBtn];
	
	UIImage *inventoryImg = [UIImage imageNamed:@"stats_inventory.png"];
	UIButton *inventoryBtn = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(440, 9, inventoryImg.size.width, inventoryImg.size.height)];
	[inventoryBtn addTarget:self action:@selector(showInventory:) forControlEvents:UIControlEventTouchUpInside];
	[inventoryBtn setBackgroundImage:inventoryImg forState:UIControlStateNormal];
	[inventoryBtn setBackgroundImage:[UIImage imageNamed:@"stats_inventory_hl.png"] forState:UIControlStateHighlighted];
	[self.view addSubview:inventoryBtn];
	
	// ----
	int leftMargin = 250;
	int topMargin = 25;
	int padding = 28;
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:topMargin andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i",@"Level:",pet.level]]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:topMargin+1*padding andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i/100",@"EXP:",pet.experience]]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:topMargin+2*padding andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i/%i",@"HP:",pet.healthPoints,pet.maxHealthPoints]]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:topMargin+3*padding andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i/%i",@"AP:",pet.abilityPoints,pet.maxAbilityPoints]]];
	
	[self.view addSubview:[HelperMethods createImageWithX:leftMargin andY:topMargin+4*padding andImage:@"stats_right_top_line.png"]];
	[self.view addSubview:[HelperMethods createImageWithX:leftMargin andY:topMargin+4*padding+15 andImage:@"stats_str.png"]];
	[self.view addSubview:[HelperMethods createImageWithX:leftMargin+90 andY:topMargin+4*padding+15 andImage:@"stats_def.png"]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin+40 andY:topMargin+4*padding+15 andWidth:50 andHeight:20 andText:[NSString stringWithFormat:@"%i",pet.strength]]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin+120 andY:topMargin+4*padding+15 andWidth:50 andHeight:20 andText:[NSString stringWithFormat:@"%i",pet.defense]]];
	[self.view addSubview:[HelperMethods createImageWithX:leftMargin andY:topMargin+5.5*padding andImage:@"stats_right_bottom_line.png"]];
	
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:200 andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i",@"AGI:",pet.agility] andTextSize:20.0f]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:225 andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i",@"INT:",pet.intelligence] andTextSize:20.0f]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:250 andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i",@"WIS:",pet.wisdom] andTextSize:20.0f]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin+100 andY:200 andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i",@"DEX:",pet.dexterity] andTextSize:20.0f]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin+100 andY:225 andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i",@"CON:",pet.constitution] andTextSize:20.0f]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin+100 andY:250 andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i",@"RES:",pet.resilience] andTextSize:20.0f]];
	[self.view addSubview:[HelperMethods createLabelWithX:leftMargin andY:275 andWidth:150 andHeight:20 andText:[NSString stringWithFormat:@"%@ %i",@"LUCK:",pet.luck] andTextSize:20.0f]];
}

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

- (void)freeAndNil {
	if(globalDataViewController != nil) {
		[globalDataViewController release];
		globalDataViewController = nil;
	}
	if(inventoryViewController != nil) {
		[inventoryViewController release];
		inventoryViewController = nil;
	}
	if(weaponsViewController != nil) {
		[weaponsViewController release];
		weaponsViewController = nil;
	}
}

- (void)dealloc {
	[globalDataViewController release];
	[inventoryViewController release]; 
	[weaponsViewController release];
	[backButton release];
    [super dealloc];
}


@end
