//
//  StatsWeaponViewController.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/2/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "StatsWeaponViewController.h"

@implementation StatsWeaponViewController

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
	
	[self.view addSubview:[HelperMethods createLabelWithX:170 andY:15 andWidth:400 andHeight:48 andText:@"P2P Inventory" andTextSize:34]];
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
    [super dealloc];
}

@end
