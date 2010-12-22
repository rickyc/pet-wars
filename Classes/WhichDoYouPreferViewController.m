//
//  WhichDoYouPreferViewController.m
//  firstScreens
//
//  Created by Andrew Saladino on 4/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WhichDoYouPreferViewController.h"
#import "CompleteInHimFont.h"


@implementation WhichDoYouPreferViewController
@synthesize choiceSelectedA, choiceSelectedB, choiceSelectedC;
@synthesize preferChosen;
@synthesize cleanlinessViewController;
@synthesize data;

- (IBAction)choicePressed:(id)sender
{
	int tag = [sender tag];
	[self makeChoicesSelectedHidden];
	
	if (tag == 0)
	{
		choiceSelectedA.hidden = FALSE;
		preferChosen = @"Eat ice cream";
	}
	else if (tag == 1)
	{
		choiceSelectedB.hidden = FALSE;
		preferChosen = @"Sleeping under the sun";
	}
	else if (tag == 2)
	{
		choiceSelectedC.hidden = FALSE;		
		preferChosen = @"Playing sports";
	}
}

- (void) makeChoicesSelectedHidden
{
	choiceSelectedA.hidden = TRUE;
	choiceSelectedB.hidden = TRUE;
	choiceSelectedC.hidden = TRUE;
}

- (IBAction) nextPressed:(id)sender
{
	if (preferChosen != nil)
	{
		cleanlinessViewController = [[CleanlinessViewController alloc] initWithNibName:@"Cleanliness" bundle:[NSBundle mainBundle]];
		
		[data setObject:preferChosen forKey:@"prefer"];
		cleanlinessViewController.data = data;
	
		[self.view addSubview:cleanlinessViewController.view];
	}
}

- (IBAction) backPressed:(id)sender
{
	[self.view removeFromSuperview];
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	CompleteInHimFont *myLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(72, 19, 480, 0)] autorelease];
	[myLabel initTextWithSize:49 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[myLabel updateText:@"Which do you prefer?"];
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

- (void)dealloc {
	[cleanlinessViewController release];
	[choiceSelectedA release];
	[choiceSelectedB release];
	[choiceSelectedC release];
	[preferChosen release];
    [super dealloc];
}


@end
