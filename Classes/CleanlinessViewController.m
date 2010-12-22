//
//  CleanlinessViewController.m
//  firstScreens
//
//  Created by Andrew Saladino on 4/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CleanlinessViewController.h"
#import "CompleteInHimFont.h"
#import "iDrewStuffAppDelegate.h"

@implementation CleanlinessViewController
@synthesize choiceSelectedA, choiceSelectedB, choiceSelectedC; // these UIImageViews are so I can draw the box if selected
@synthesize cleanlinessChosen; // this is a string of what the user's answer was
@synthesize data;

- (IBAction) nextPressed:(id)sender // if they click next
{
	if (cleanlinessChosen != nil)
	{
		[data setObject:cleanlinessChosen forKey:@"hygiene"];
		
		NSLog(@"Name: %@", [data objectForKey:@"name"]);
		NSLog(@"Gender: %@", [data objectForKey:@"gender"]);
		NSLog(@"Fav. Color: %@", [data objectForKey:@"fav_color"]);
		NSLog(@"Preference: %@", [data objectForKey:@"prefer"]);
		NSLog(@"Cleanliness: %@", [data objectForKey:@"hygiene"]);
		
		NSLog(@"DO YOUR STUFF RICKY! I DONT knOW WHAT TO DO!"); // start the game
		iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
		RootViewController *rootViewController = [appDelegate viewController];
		
		rootViewController.titleScreenViewController.newPetData = self.data;
		[rootViewController.titleScreenViewController.keyboardViewController.view removeFromSuperview];
		[rootViewController.titleScreenViewController createANewPet];
	}
}

- (IBAction) backPressed:(id)sender // if they clicked back
{
	[self.view removeFromSuperview];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad // this checks if they previously selected something -- if they did, select it again
{
	CompleteInHimFont *myLabel = [[[CompleteInHimFont alloc] initWithFrame:CGRectMake(54, 17, 480, 0)] autorelease];
	[myLabel initTextWithSize:50 color:[UIColor blackColor] bgColor:[UIColor clearColor]];
	[myLabel updateText:@"Does cleanliness matter?"];
	[self.view addSubview:myLabel];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload // does nothing
{
	[self release];
}

- (IBAction)choicePressed:(id)sender // the user clicked A, B, or C
{
	int tag = [sender tag]; // find which one they picked
	[self makeChoicesSelectedHidden]; // turn all the choices hidden
	
	if (tag == 0)
	{
		choiceSelectedA.hidden = FALSE; // unhide this if they picked it
		cleanlinessChosen = @"A lot"; // set the answer string
	}
	else if (tag == 1)
	{
		choiceSelectedB.hidden = FALSE; // unhide this if they picked it
		cleanlinessChosen = @"Not at all"; // set the answer string
	}
	else if (tag == 2)
	{
		choiceSelectedC.hidden = FALSE;	// unhide this if they picked it	
		cleanlinessChosen = @"Don't care"; // set the answer string
	}
}


- (void) makeChoicesSelectedHidden // easy way to isolate one choice --> set them all to hidden
{
	choiceSelectedA.hidden = TRUE;
	choiceSelectedB.hidden = TRUE;
	choiceSelectedC.hidden = TRUE;
}

- (void)dealloc {
	[choiceSelectedA release];
	[choiceSelectedB release];
	[choiceSelectedC release];
	[cleanlinessChosen release];
    [super dealloc];
}


@end
