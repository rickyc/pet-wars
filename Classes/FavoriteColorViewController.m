//
//  FavoriteColorViewController.m
//  firstScreens
//
//  Created by Andrew Saladino on 4/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FavoriteColorViewController.h"
#import "CompleteInHimFont.h"


@implementation FavoriteColorViewController
@synthesize whichDoYouPreferViewController; // allows me to switch to the next view
@synthesize orangeBox, greenBox, blackBox, yellowBox, blueBox, redBox, magentaBox, purpleBox;
@synthesize colorChosen;
@synthesize data;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	CompleteInHimFont *myLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(123, 18, 480, 0)] autorelease];
	[myLabel initTextWithSize:50 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[myLabel updateText:@"Favorite Color?"];
	[self.view addSubview:myLabel];
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

- (IBAction)nextPressed:(id)sender 
{
	if (colorChosen != nil)
	{
		whichDoYouPreferViewController = [[WhichDoYouPreferViewController alloc] initWithNibName:@"WhichDoYouPrefer" bundle:[NSBundle mainBundle]];
	
		[data setObject:colorChosen forKey:@"fav_color"];
		whichDoYouPreferViewController.data = data;
	
		[self.view addSubview:whichDoYouPreferViewController.view];
	}
}

- (IBAction)backPressed:(id)sender 
{
	[self.view removeFromSuperview];
}

- (IBAction)colorPressed:(id)sender {
	int taggedColor = [sender tag]; // tag number of the selected color
	[self resetColorSelected];
	
	
	if (taggedColor == 0)
	{
		colorChosen = @"Orange";
		[orangeBox setImage: [UIImage imageNamed:@"color_orangeDOWN.png"] forState:UIControlStateNormal];
	}
	else if (taggedColor == 1)
	{
		colorChosen = @"Green";
		[greenBox setImage: [UIImage imageNamed:@"color_greenDOWN.png"] forState:UIControlStateNormal];		
	}
	else if (taggedColor == 2)
	{
		colorChosen = @"Blue";
		[blueBox setImage: [UIImage imageNamed:@"color_blueDOWN.png"] forState:UIControlStateNormal];		
	}
	else if (taggedColor == 3)
	{
		colorChosen = @"Yellow";
		[yellowBox setImage: [UIImage imageNamed:@"color_yellowDOWN.png"] forState:UIControlStateNormal];		
	}
	else if (taggedColor == 4)
	{
		colorChosen = @"Magenta";
		[magentaBox setImage: [UIImage imageNamed:@"color_magentaDOWN.png"] forState:UIControlStateNormal];		
	}
	else if (taggedColor == 5)
	{
		colorChosen = @"Red";
		[redBox setImage: [UIImage imageNamed:@"color_redDOWN.png"] forState:UIControlStateNormal];		
	}
	else if (taggedColor == 6)
	{
		colorChosen = @"Purple";
		[purpleBox setImage: [UIImage imageNamed:@"color_purpleDOWN.png"] forState:UIControlStateNormal];		
	}
	else if (taggedColor == 7)
	{
		colorChosen = @"Black";
		[blackBox setImage: [UIImage imageNamed:@"color_blackDOWN.png"] forState:UIControlStateNormal];		
	}
}

- (void) resetColorSelected {
	[greenBox setImage: [UIImage imageNamed:@"color_green.png"] forState:UIControlStateNormal];
	[orangeBox setImage: [UIImage imageNamed:@"color_orange.png"] forState:UIControlStateNormal];
	[blackBox setImage: [UIImage imageNamed:@"color_black.png"] forState:UIControlStateNormal];
	[blueBox setImage: [UIImage imageNamed:@"color_blue.png"] forState:UIControlStateNormal];
	[yellowBox setImage: [UIImage imageNamed:@"color_yellow.png"] forState:UIControlStateNormal];
	[redBox setImage: [UIImage imageNamed:@"color_red.png"] forState:UIControlStateNormal];
	[purpleBox setImage: [UIImage imageNamed:@"color_purple.png"] forState:UIControlStateNormal];
	[magentaBox setImage: [UIImage imageNamed:@"color_magenta.png"] forState:UIControlStateNormal];

	
}
- (void)dealloc {
	[whichDoYouPreferViewController release];
	[greenBox release];
	[orangeBox release];
	[blackBox release];
	[yellowBox release];
	[blueBox release];
	[redBox release];
	[magentaBox release];
	[purpleBox release];
	[colorChosen release];
	[data release];	
    [super dealloc];
}


@end
