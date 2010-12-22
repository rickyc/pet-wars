//
//  InfoViewController.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/25/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "InfoViewController.h"
#import "iDrewStuffAppDelegate.h"

@implementation InfoViewController
@synthesize backButton;

- (IBAction)exitInfoView:(id)sender {
	iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
	RootViewController *rootViewController = [appDelegate viewController];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:rootViewController.view cache:YES];
	[rootViewController.view addSubview:rootViewController.titleScreenViewController.view];
	[self.view removeFromSuperview];
	[UIView commitAnimations];
	
	/*
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];	
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	[self.view removeFromSuperview];
	[UIView commitAnimations];*/
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[backButton release];
    [super dealloc];
}


@end
