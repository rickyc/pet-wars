//
//  PWAlert.m
//  iDrewStuff
//
//  Created by Ricky Cheng on 5/24/09.
//  Copyright 2009 Family. All rights reserved.
//

#import "PWAlert.h"

@implementation PWAlert

- (void)setTitle:(NSString*)title andMessage:(NSString*)message {
	[self.view addSubview:[HelperMethods createLabelWithX:150 andY:105 andWidth:210 andHeight:20 andText:title andSize:20 
											 andFontColor:[UIColor whiteColor]]];
	
	UITextView *msg = [[[UITextView alloc] initWithFrame:CGRectMake(140,120,205,105)] autorelease];
	msg.backgroundColor = [UIColor clearColor];
	msg.textColor = [UIColor whiteColor];
	msg.editable = NO;
	msg.userInteractionEnabled = YES;
	msg.text = message;
	[self.view addSubview:msg];
}

- (void)goBack:(id)sender {
	[HelperMethods playSound:@"click"];
	[self.view removeFromSuperview];
	[self release];
}

- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,480,320)];
	contentView.backgroundColor = [UIColor clearColor];
	self.view = contentView;
	[contentView release];
	
	// 228x161
	[self.view addSubview:[HelperMethods createImageWithX:126 andY:80 andImage:@"alert.png"]];
	
	// CHANGE THIS!!! 205 original
	[self.view addSubview:[HelperMethods createButtonWithX:290 andY:235 andUpImage:@"keyboard_back.png" andDownImage:@"keyboard_backDOWN.png" 
												 andTarget:self andSelector:@selector(goBack:)]];
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
    [super dealloc];
}


@end
