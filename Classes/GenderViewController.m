//
//  genderScreenViewController.m
//  firstScreens
//
//  Created by Andrew Saladino on 4/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GenderViewController.h"
#import "CompleteInHimFont.h"


@implementation GenderViewController
@synthesize favoriteColorViewController;
@synthesize male, female;
@synthesize genderChosen;
@synthesize data;

- (void)viewDidLoad 
{
	CompleteInHimFont *myLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(162, 10, 480, 0)] autorelease];
	[myLabel initTextWithSize:62 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[myLabel updateText:@"Gender?"];
	[self.view addSubview:myLabel];	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

// If they didn't select anything -- Don't go to next screen
// If they did, load the next screen
- (IBAction)nextPressed:(id)sender 
{		
	if (genderChosen != nil)
	{
		favoriteColorViewController = [[FavoriteColorViewController alloc] initWithNibName:@"FavoriteColor" bundle:[NSBundle mainBundle]];
	
		[data setObject:genderChosen forKey:@"gender"];
		favoriteColorViewController.data = data;

		[self.view addSubview:favoriteColorViewController.view];
	}
}

// Load the previous screen
- (IBAction)backPressed:(id)sender 
{	
	[self.view removeFromSuperview];
}

// Selected Female -- Show the Female down image
// Show the Male up image
// Set Gender to Female and save it
- (IBAction)femalePressed:(id)sender 
{	
	genderChosen = @"female";

	[female setImage: [UIImage imageNamed:@"gender_femaleDOWN.png"] forState:UIControlStateNormal];
	[male setImage: [UIImage imageNamed:@"gender_male.png"] forState:UIControlStateNormal];
}

// Selected Male -- Show the Male down image
// Show the Female up image
// Set Gender to Male and save it
- (IBAction)malePressed:(id)sender 
{	
	genderChosen = @"male";	

	[female setImage: [UIImage imageNamed:@"gender_female.png"] forState:UIControlStateNormal];
	[male setImage: [UIImage imageNamed:@"gender_maleDOWN.png"] forState:UIControlStateNormal];
}

// Release stuff
- (void)dealloc {
	[favoriteColorViewController release];
	[female release];
	[male release];
	[genderChosen release];
	[super dealloc];
}
@end
