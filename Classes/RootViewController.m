//
//  RootViewController.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 4/22/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
@synthesize splashViewController, titleScreenViewController, gameViewController, storeViewController;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	NSLog(@"view frame size: %@, %@",[[UIScreen mainScreen] applicationFrame],[[UIScreen mainScreen] bounds]);
	splashViewController = [[SplashViewController alloc] init];
	[self.view addSubview:splashViewController.view];
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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[storeViewController release];
	[gameViewController release];
	[titleScreenViewController release];
	[splashViewController release];
    [super dealloc];
}

@end