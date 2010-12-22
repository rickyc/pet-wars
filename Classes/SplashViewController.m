//
//  SplashViewController.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/18/09.
//  Copyright 2009 Family. All rights reserved.
//


#import "SplashViewController.h"
#import "iDrewStuffAppDelegate.h"
#import "RootViewController.h"

@implementation SplashViewController
@synthesize timer, splashImageView, titleScreenViewController;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// Init the view
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UIView *view = [[UIView alloc] initWithFrame:appFrame];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	self.view = view;
	[view release];
	
	splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash.png"]];
	splashImageView.frame = CGRectMake(0, 0, 480, 320);
	[self.view addSubview:splashImageView];
	
	// sorry I made the code ugly, by making RootView basically a global navigation bar... 
	// technically code would be cleaner with a rootViewController variable, but that requires retaining 
	// or the pointer would get released
	self.titleScreenViewController = [[TitleScreenViewController alloc] initWithNibName:@"TitleView" bundle:[NSBundle mainBundle]];
	self.titleScreenViewController.view.alpha = 0.0;
	
	iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
	RootViewController *rootViewController = [appDelegate viewController];
	rootViewController.titleScreenViewController = self.titleScreenViewController;		// INITS TitleScreenViewController
	
	[self.view addSubview:titleScreenViewController.view];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(fadeScreen) userInfo:nil repeats:NO];
}

- (void)fadeScreen {
	[UIView beginAnimations:nil context:nil]; // begins animation block
	[UIView setAnimationDuration:0.75];        // sets animation duration
	[UIView setAnimationDelegate:self];        // sets delegate for this block
	[UIView setAnimationDidStopSelector:@selector(finishedFading)];   // calls the finishedFading method when the animation is done (or done fading out)	
	self.view.alpha = 0.0;       // Fades the alpha channel of this view to "0.0" over the animationDuration of "0.75" seconds
	[UIView commitAnimations];   // commits the animation block.  This Block is done.
}

- (void) finishedFading {
	[UIView beginAnimations:nil context:nil];	// begins animation block
	[UIView setAnimationDuration:0.75];			// sets animation duration
	self.view.alpha = 1.0;						// fades the view to 1.0 alpha over 0.75 seconds
	titleScreenViewController.view.alpha = 1.0;
	[UIView commitAnimations];					// commits the animation block.  This Block is done.
	[splashImageView removeFromSuperview];		// removes the splash screen
	
	// grabs the RootViewController from the App Delegate
	iDrewStuffAppDelegate *appDelegate = (iDrewStuffAppDelegate *)[[UIApplication sharedApplication] delegate];
	RootViewController *rootViewController = [appDelegate viewController];
	
	// removes the faded title screen
	[titleScreenViewController.view removeFromSuperview];

	/*
	// Rotates the view counter clockwise 90 degrees
	CGAffineTransform transform = CGAffineTransformMakeRotation(-3.14159/2);
	titleScreenViewController.view.transform = transform;
	
	// Repositions and resizes the view.
	CGRect contentRect = CGRectMake(0, 0, 480, 320);
	titleScreenViewController.view.bounds = contentRect;
	*/
	
	// replaces the RootViewController with the title screen view
	[rootViewController.view addSubview:[titleScreenViewController view]];
	[rootViewController.splashViewController release];		// doesn't seem to do anything
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[titleScreenViewController release];
	[splashImageView release];
	//[timer release];
	[super dealloc];
}

@end

